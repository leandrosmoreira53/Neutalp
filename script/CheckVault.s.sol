// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/DeltaNeutralVaultV1.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title CheckVaultScript
 * @notice Script para ler estado do vault SEM fazer transações
 * @dev forge script script/CheckVault.s.sol:CheckVaultScript --rpc-url $SEPOLIA_RPC_URL
 */
contract CheckVaultScript is Script {
    address constant VAULT_ADDRESS = 0x6cf5791356EEf878536Ee006f18410861D93198D;
    address constant USDC_ADDRESS = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;

    function run() external view {
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");
        if (deployer == address(0)) {
            deployer = 0x90F51A05bD8DaC2d8A5b10c2930BD8415416515a;
        }

        DeltaNeutralVaultV1 vault = DeltaNeutralVaultV1(VAULT_ADDRESS);
        IERC20 usdc = IERC20(USDC_ADDRESS);

        console.log("\n========== ESTADO ATUAL DO VAULT ==========\n");
        console.log("Deployer/Keeper:", deployer);
        console.log("Vault Address:", VAULT_ADDRESS);
        
        // Info do Vault
        console.log("\n--- INFO DO VAULT ---");
        console.log("Nome:", vault.name());
        console.log("Símbolo:", vault.symbol());
        console.log("Decimais:", vault.decimals());
        console.log("Total Assets (USDC):", vault.totalAssets());
        console.log("Total Supply (shares):", vault.totalSupply());

        // Info de Posição
        console.log("\n--- POSIÇÃO UNISWAP ---");
        try {
            (
                uint256 tokenId,
                uint128 liquidity,
                uint256 amount0,
                uint256 amount1
            ) = vault.testnet_getPositionInfo();
            
            if (tokenId > 0) {
                console.log("Token ID:", tokenId);
                console.log("Liquidity:", liquidity);
                console.log("Amount0:", amount0);
                console.log("Amount1:", amount1);
            } else {
                console.log("Nenhuma posição ativa ainda");
            }
        } catch {
            console.log("Erro ao obter info da posição");
        }

        // Info do Depositor
        console.log("\n--- INFO DO DEPOSITOR ---");
        console.log("USDC balance:", usdc.balanceOf(deployer));
        console.log("Shares (dnvUSDC):", vault.balanceOf(deployer));
        console.log("Value em USDC (share value):", 
            vault.totalAssets() > 0 ? (vault.balanceOf(deployer) * vault.totalAssets()) / vault.totalSupply() : 0
        );

        // Fees
        console.log("\n--- CONFIGURAÇÃO DE FEES ---");
        try {
            uint256 perfFee = vault.performanceFeeRate();
            uint256 mgmtFee = vault.managementFeeRate();
            uint256 swapFee = vault.swapFeeRate();
            uint256 keeperFee = vault.keeperFeeRate();
            
            console.log("Performance Fee:", perfFee, "bps");
            console.log("Management Fee:", mgmtFee, "bps");
            console.log("Swap Fee:", swapFee, "bps");
            console.log("Keeper Fee:", keeperFee, "bps");
        } catch {
            console.log("Erro ao obter fees");
        }

        console.log("\n========== FIM DO CHECK ==========\n");
    }
}
