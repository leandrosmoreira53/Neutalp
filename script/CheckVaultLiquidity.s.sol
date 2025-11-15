// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IVault {
    function uniswapPool() external view returns (address);
}

contract CheckVaultLiquidityScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;

    function run() external view {
        console.log("===== VAULT & POOL STATE =====");
        console.log("");
        
        // Vault balances
        uint256 vaultUsdc = IERC20(USDC).balanceOf(VAULT);
        uint256 vaultWbtc = IERC20(WBTC).balanceOf(VAULT);
        
        console.log("Vault USDC balance:", vaultUsdc / 1e6, "USDC");
        console.log("Vault WBTC balance:", vaultWbtc / 1e8, "WBTC");
        console.log("");
        
        console.log("To create LP position in the pool:");
        console.log("1. USDC in vault:", vaultUsdc / 1e6, "(can be used)");
        console.log("2. WBTC in vault:", vaultWbtc / 1e8, "(NOT enough to create LP)");
        console.log("3. Need to transfer USDC from vault to deployer");
        console.log("4. Need to get more WBTC testnet tokens");
        console.log("");
        
        console.log("===== END STATE =====");
    }
}
