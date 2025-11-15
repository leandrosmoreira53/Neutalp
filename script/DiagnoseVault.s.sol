// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IVault {
    function uniswapPool() external view returns (address);
    function positionManager() external view returns (address);
    function swapRouter() external view returns (address);
    function tickLower() external view returns (int24);
    function tickUpper() external view returns (int24);
    function tokenId() external view returns (uint256);
}

interface IPool {
    function tickSpacing() external view returns (int24);
    function fee() external view returns (uint24);
}

contract DiagnoseVaultScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;

    function run() external view {
        console.log("===== VAULT DIAGNOSTIC =====");
        
        IVault vault = IVault(VAULT);
        
        // Check configuration
        address pool = vault.uniswapPool();
        address nfpm = vault.positionManager();
        address router = vault.swapRouter();
        
        console.log("Configuration Status:");
        console.log("  Pool:", pool);
        console.log("  Pool configured:", pool != address(0) ? "YES" : "NO");
        console.log("  NFPM:", nfpm);
        console.log("  Router:", router);
        
        // Check range
        int24 lower = vault.tickLower();
        int24 upper = vault.tickUpper();
        uint256 tokenId = vault.tokenId();
        
        console.log("");
        console.log("Range Status:");
        console.log("  Tick Lower:", int256(lower));
        console.log("  Tick Upper:", int256(upper));
        console.log("  Token ID:", tokenId);
        console.log("  Has LP Position:", tokenId != 0 ? "YES" : "NO");
        
        // Check pool parameters
        if (pool != address(0)) {
            IPool ipool = IPool(pool);
            int24 spacing = ipool.tickSpacing();
            uint24 fee = ipool.fee();
            
            console.log("");
            console.log("Pool Parameters:");
            console.log("  Tick Spacing:", int256(spacing));
            console.log("  Fee (bps):", uint256(fee));
            
            // Validate ticks
            bool lowerValid = lower % spacing == 0;
            bool upperValid = upper % spacing == 0;
            bool orderValid = lower < upper;
            
            console.log("");
            console.log("Tick Validation:");
            console.log("  Lower % spacing == 0:", lowerValid);
            console.log("  Upper % spacing == 0:", upperValid);
            console.log("  Lower < Upper:", orderValid);
            
            if (!lowerValid || !upperValid || !orderValid) {
                console.log("");
                console.log("ISSUES FOUND - Check above");
            } else {
                console.log("");
                console.log("All checks passed!");
            }
        }
        
        console.log("");
        console.log("===== END DIAGNOSTIC =====");
    }
}
