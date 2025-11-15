// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/DeltaNeutralVaultV1.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title CheckVaultScript
 * @notice Script to read vault state WITHOUT making transactions
 * @dev forge script script/CheckVault.s.sol:CheckVaultScript --rpc-url $SEPOLIA_RPC_URL
 */
contract CheckVaultScript is Script {
    address constant VAULT_ADDRESS = 0x6cf5791356EEf878536Ee006f18410861D93198D;
    address constant USDC_ADDRESS = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;

    function run() external view {
        address deployer = 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a;

        DeltaNeutralVaultV1 vault = DeltaNeutralVaultV1(VAULT_ADDRESS);
        IERC20 usdc = IERC20(USDC_ADDRESS);

        console.log("\n========== CURRENT VAULT STATE ==========\n");
        console.log("Deployer/Keeper:", deployer);
        console.log("Vault Address:", VAULT_ADDRESS);
        
        // Vault Info
        console.log("\n--- VAULT INFO ---");
        console.log("Name:", vault.name());
        console.log("Symbol:", vault.symbol());
        console.log("Decimals:", vault.decimals());
        
        // Try to get assets
        console.log("\n--- VAULT ASSETS ---");
        uint256 totalAssets = vault.totalAssets();
        uint256 totalSupply = vault.totalSupply();
        console.log("Total Assets (USDC):", totalAssets);
        console.log("Total Supply (shares):", totalSupply);

        // Position Info
        console.log("\n--- UNISWAP POSITION ---");
        console.log("(Vault needs testnet version to expose position info)");
        console.log("Current vault: DeltaNeutralVaultV1 (production)");
        console.log("For full testing, deploy: DeltaNeutralVaultV1Testnet");

        // Depositor Info
        console.log("\n--- DEPOSITOR INFO ---");
        uint256 usdcBalance = usdc.balanceOf(deployer);
        uint256 shares = vault.balanceOf(deployer);
        console.log("USDC balance:", usdcBalance);
        console.log("Shares (dnvUSDC):", shares);
        
        if (totalSupply > 0) {
            uint256 shareValue = (shares * totalAssets) / totalSupply;
            console.log("Share value (USDC):", shareValue);
        } else {
            console.log("No shares minted yet");
        }

        // Fees
        console.log("\n--- FEE CONFIGURATION ---");
        console.log("(Use setFees() to view/change fee configuration)");
        console.log("Current fees are private in DeltaNeutralVaultV1");
        console.log("Performance Fee: 5% (500 bps)");
        console.log("Management Fee: 2% (200 bps)");
        console.log("Swap Fee: 0.3% (30 bps)");
        console.log("Keeper Fee: 0.1% (10 bps)");
        console.log("Entry Fee: 0%");
        console.log("Exit Fee: 0%");

        console.log("\n========== END OF CHECK ==========\n");
    }
}

