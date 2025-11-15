// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/DeltaNeutralVaultV1.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title TestVaultScript
 * @notice Script completo para testar o vault na testnet
 * @dev forge script script/TestVault.s.sol:TestVaultScript --rpc-url $SEPOLIA_RPC_URL --broadcast
 */
contract TestVaultScript is Script {
    // Endereço do vault deployado
    address constant VAULT_ADDRESS = 0x6cf5791356EEf878536Ee006f18410861D93198D;
    
    // Endereço do USDC na testnet Arbitrum Sepolia
    address constant USDC_ADDRESS = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    
    // Quantidade para teste (1 USDC = 1000000 em 6 decimais)
    uint256 constant DEPOSIT_AMOUNT = 1000000; // 1 USDC para começar

    DeltaNeutralVaultV1 vault;
    IERC20 usdc;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("\n========== TESTE DO VAULT TESTNET ==========\n");
        console.log("Deployer:", deployer);
        console.log("Vault Address:", VAULT_ADDRESS);
        console.log("USDC Address:", USDC_ADDRESS);
        
        vault = DeltaNeutralVaultV1(VAULT_ADDRESS);
        usdc = IERC20(USDC_ADDRESS);

        vm.startBroadcast(deployerPrivateKey);

        // ============ PASSO 1: VER ESTADO INICIAL ============
        console.log("\n--- PASSO 1: Estado Inicial ---");
        console.log("USDC balance:", usdc.balanceOf(deployer));
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("Vault totalSupply:", vault.totalSupply());
        console.log("Meus shares antes:", vault.balanceOf(deployer));

        // ============ PASSO 2: APROVAR USDC ============
        console.log("\n--- PASSO 2: Aprovar USDC para o Vault ---");
        usdc.approve(VAULT_ADDRESS, DEPOSIT_AMOUNT);
        console.log("USDC aprovado: ", DEPOSIT_AMOUNT);

        // ============ PASSO 3: DEPOSITAR USDC ============
        console.log("\n--- PASSO 3: Depositar USDC no Vault ---");
        uint256 sharesMinted = vault.deposit(DEPOSIT_AMOUNT, deployer);
        console.log("USDC depositado:", DEPOSIT_AMOUNT);
        console.log("Shares recebidas:", sharesMinted);

        // ============ PASSO 4: VER ESTADO PÓS-DEPÓSITO ============
        console.log("\n--- PASSO 4: Estado Pós-Depósito ---");
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("Vault totalSupply:", vault.totalSupply());
        console.log("Meus shares agora:", vault.balanceOf(deployer));
        console.log("Preview redeem (1 share):", vault.previewRedeem(1e18));

        // ============ PASSO 5: DEFINIR RANGE ============
        console.log("\n--- PASSO 5: Definir Range para a Posição ---");
        // Range típico para BTC: 
        // Ticks negativos = preço mais baixo
        // Ticks positivos = preço mais alto
        int24 tickLower = -887000;  // Range inferior (preço mais baixo)
        int24 tickUpper = -882000;  // Range superior (preço mais alto)
        vault.setRange(tickLower, tickUpper);
        console.log("Range definido:", tickLower, " <-> ", tickUpper);

        // ============ PASSO 6: FORÇAR REBALANCE ============
        console.log("\n--- PASSO 6: Forçar Criação de Posição (Rebalance) ---");
        vault.testnet_forceRebalance();
        console.log("Rebalance executado!");

        // ============ PASSO 7: VER INFORMAÇÕES DA POSIÇÃO ============
        console.log("\n--- PASSO 7: Informações da Posição Uniswap ---");
        (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        ) = vault.testnet_getPositionInfo();
        
        console.log("Token ID:", tokenId);
        console.log("Liquidity:", liquidity);
        console.log("Amount0 (USDC ou equiv):", amount0);
        console.log("Amount1 (token1):", amount1);

        // ============ PASSO 8: SIMULAR REBALANCE ============
        console.log("\n--- PASSO 8: Simular o que Aconteceria se Rebalanceasse ---");
        (
            bool shouldExit,
            bool shouldReenter,
            int24 newTickLower,
            int24 newTickUpper,
            uint256 estimatedSwapFee
        ) = vault.testnet_simulateRebalance();
        
        console.log("Should Exit:", shouldExit);
        console.log("Should Reenter:", shouldReenter);
        console.log("New Range (se aplica):", newTickLower, " <-> ", newTickUpper);
        console.log("Estimated Swap Fee:", estimatedSwapFee);

        // ============ PASSO 9: VER ESTADO FINAL ============
        console.log("\n--- PASSO 9: Estado Final ---");
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("Vault totalSupply:", vault.totalSupply());
        console.log("Meus shares:", vault.balanceOf(deployer));
        console.log("USDC restante na carteira:", usdc.balanceOf(deployer));

        // ============ PASSO 10: TESTAR SACAR (WITHDRAW) ============
        console.log("\n--- PASSO 10: Testar Saque Parcial ---");
        uint256 sharesToWithdraw = sharesMinted / 2;  // Sacar metade
        if (sharesToWithdraw > 0) {
            uint256 assetsReceived = vault.redeem(sharesToWithdraw, deployer, deployer);
            console.log("Shares retiradas:", sharesToWithdraw);
            console.log("USDC recebidos:", assetsReceived);
        }

        console.log("\n--- ESTADO FINAL APÓS SAQUE ---");
        console.log("Shares restantes:", vault.balanceOf(deployer));
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("USDC na carteira:", usdc.balanceOf(deployer));

        vm.stopBroadcast();

        console.log("\n========== TESTE COMPLETO! ==========\n");
        console.log("Próximos passos:");
        console.log("1. Monitore o preço de BTC");
        console.log("2. Quando sair do range, execute testnet_simulateRebalance() novamente");
        console.log("3. O vault deve detectar saída e fazer auto-exit/reenter");
        console.log("4. Verifique as fees sendo cobradas em cada transação");
    }
}
