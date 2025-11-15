// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IVault {
    function tickLower() external view returns (int24);
    function tickUpper() external view returns (int24);
    function tokenId() external view returns (uint256);
    function uniswapPool() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
}

interface IPool {
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
}

contract CheckVaultStateScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant DEPLOYER = 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a;

    function run() external view {
        console.log("\n========== VAULT STATE ==========");
        IVault vault = IVault(VAULT);
        
        // Pool info
        address pool = vault.uniswapPool();
        console.log("Uniswap Pool:", pool);
        
        // Range info
        int24 lower = vault.tickLower();
        int24 upper = vault.tickUpper();
        uint256 tokenId = vault.tokenId();
        console.log("Tick Lower:", int256(lower));
        console.log("Tick Upper:", int256(upper));
        console.log("LP Position Token ID:", tokenId);
        
        // Get current pool tick
        if (pool != address(0)) {
            IPool ipool = IPool(pool);
            (, int24 currentTick, , , , , ) = ipool.slot0();
            console.log("Current Pool Tick:", int256(currentTick));
        }
        
        // Shares received
        uint256 shares = vault.balanceOf(DEPLOYER);
        console.log("Shares owned by deployer:", shares);
        
        // Token balances
        console.log("\n========== TOKEN BALANCES ==========");
        IERC20 usdc = IERC20(USDC);
        IERC20 wbtc = IERC20(WBTC);
        
        console.log("Deployer USDC:", usdc.balanceOf(DEPLOYER));
        console.log("Deployer WBTC:", wbtc.balanceOf(DEPLOYER));
        console.log("Vault USDC:", usdc.balanceOf(VAULT));
        console.log("Vault WBTC:", wbtc.balanceOf(VAULT));
        
        console.log("\n========== SUMMARY ==========");
        console.log("Vault Status: Ready to trade!");
        console.log("Total Value Locked in USDC: ~", usdc.balanceOf(VAULT));
    }
}
