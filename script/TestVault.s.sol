// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IVault {
    function totalAssets() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function uniswapPool() external view returns (address);
    function tickLower() external view returns (int24);
    function tickUpper() external view returns (int24);
    function tokenId() external view returns (uint256);
}

interface IPool {
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked);
    function liquidity() external view returns (uint128);
}

contract TestVaultScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;

    function run() external view {
        console.log("========== VAULT TEST ==========");
        
        // Get vault state
        uint256 usdcBal = IERC20(USDC).balanceOf(VAULT);
        uint256 wbtcBal = IERC20(WBTC).balanceOf(VAULT);
        
        console.log("USDC balance:", usdcBal / 1e6);
        console.log("WBTC balance:", wbtcBal / 1e8);
        console.log("");
        
        if (usdcBal > 0 && wbtcBal == 0) {
            console.log("Status: VAULT HAS ONLY USDC");
        } else if (usdcBal > 0 && wbtcBal > 0) {
            console.log("Status: VAULT HAS BOTH USDC AND WBTC");
        }
        console.log("");
        
        // Check if can create position
        if (usdcBal > 0 && wbtcBal > 0) {
            console.log("CAN CREATE LP POSITION: YES");
        } else {
            console.log("CAN CREATE LP POSITION: NO");
        }
        
        console.log("========== END ==========");
    }
}
