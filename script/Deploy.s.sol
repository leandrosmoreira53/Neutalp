// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DeltaNeutralVaultV1.sol";

/**
 * @title DeployScript
 * @notice Script de deploy para Foundry
 * @dev forge script script/Deploy.s.sol:DeployScript --rpc-url $SEPOLIA_RPC_URL --broadcast
 */
contract DeployScript is Script {

    function run() external {
        // Configuração - AJUSTE ESTES ENDEREÇOS
        address USDC_ADDRESS = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d; // Arbitrum Sepolia USDC
        address CHAINLINK_FEED = 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43; // BTC/USD Arbitrum Sepolia
        address POSITION_MANAGER = 0x1238536071E1c677A632429e3655c799b22cDA52; // Arbitrum Sepolia
        address SWAP_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564; // Arbitrum Sepolia
        address ONEINCH_ROUTER = 0x1111111254EEB25477B68fb85Ed929f73A960582; // 1inch v5 Router

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying from:", deployer);
        console.log("Balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy vault
        DeltaNeutralVaultV1 vault = new DeltaNeutralVaultV1(
            IERC20(USDC_ADDRESS),
            "Delta Neutral Vault Shares",
            "dnvUSDC",
            CHAINLINK_FEED,
            deployer, // treasury = deployer inicialmente
            POSITION_MANAGER,
            SWAP_ROUTER,
            ONEINCH_ROUTER
        );

        console.log("Vault deployed at:", address(vault));

        // Configurar keeper
        vault.setKeeper(deployer);
        console.log("Keeper set to:", deployer);

        // Configurar fees
        vault.setFees(
            500,   // 5% performance
            200,   // 2% management
            0,     // 0% entry (must be 0)
            0,     // 0% exit (must be 0)
            30,    // 0.3% swap
            10     // 0.1% keeper
        );
        console.log("Fees configured");

        vm.stopBroadcast();

        console.log("\nDeployment successful!");
        console.log("Vault address:", address(vault));
    }
}
