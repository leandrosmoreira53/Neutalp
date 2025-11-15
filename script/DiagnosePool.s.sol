// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IPool {
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked);
    function liquidity() external view returns (uint128);
}

contract DiagnosePoolScript is Script {
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;
    address constant DEPLOYER = 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a;

    function run() external view {
        console.log("===== POOL DIAGNOSTIC =====");
        console.log("");
        
        // Pool state
        IPool pool = IPool(POOL);
        (uint160 sqrtPriceX96, int24 currentTick, , , , , ) = pool.slot0();
        uint128 liquidity = pool.liquidity();
        
        console.log("Pool Address:", POOL);
        console.log("Current Tick:", int256(currentTick));
        console.log("SqrtPriceX96:", sqrtPriceX96);
        console.log("Total Liquidity:", liquidity);
        console.log("");
        
        // Deployer balances
        console.log("Deployer:", DEPLOYER);
        console.log("USDC balance:", IERC20(USDC).balanceOf(DEPLOYER) / 1e6, "USDC");
        console.log("WBTC balance:", IERC20(WBTC).balanceOf(DEPLOYER) / 1e8, "WBTC");
        console.log("");
        
        // Check if we can mint
        if (liquidity == 0) {
            console.log("WARNING: Pool has NO liquidity!");
            console.log("Need to add initial liquidity first");
        } else {
            console.log("Pool has liquidity - OK to add position");
        }
        
        console.log("");
        console.log("===== END DIAGNOSTIC =====");
    }
}
