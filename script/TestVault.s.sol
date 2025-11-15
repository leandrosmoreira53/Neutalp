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

        console.log("\n========== VAULT TESTNET TEST ==========\n");
        console.log("Deployer:", deployer);
        console.log("Vault Address:", VAULT_ADDRESS);
        console.log("USDC Address:", USDC_ADDRESS);
        
        vault = DeltaNeutralVaultV1(VAULT_ADDRESS);
        usdc = IERC20(USDC_ADDRESS);

        vm.startBroadcast(deployerPrivateKey);

        // ============ STEP 1: CHECK INITIAL STATE ============
        console.log("\n--- STEP 1: Initial State ---");
        console.log("USDC balance:", usdc.balanceOf(deployer));
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("Vault totalSupply:", vault.totalSupply());
        console.log("My shares before:", vault.balanceOf(deployer));

        // ============ STEP 2: APPROVE USDC ============
        console.log("\n--- STEP 2: Approve USDC for Vault ---");
        usdc.approve(VAULT_ADDRESS, DEPOSIT_AMOUNT);
        console.log("USDC approved: ", DEPOSIT_AMOUNT);

        // ============ STEP 3: DEPOSIT USDC ============
        console.log("\n--- STEP 3: Deposit USDC to Vault ---");
        uint256 sharesMinted = vault.deposit(DEPOSIT_AMOUNT, deployer);
        console.log("USDC deposited:", DEPOSIT_AMOUNT);
        console.log("Shares received:", sharesMinted);

        // ============ STEP 4: CHECK STATE AFTER DEPOSIT ============
        console.log("\n--- STEP 4: State After Deposit ---");
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("Vault totalSupply:", vault.totalSupply());
        console.log("My shares now:", vault.balanceOf(deployer));
        console.log("Preview redeem (1 share):", vault.previewRedeem(1e18));

        // ============ STEP 5: SET RANGE ============
        console.log("\n--- STEP 5: Set Range for Position ---");
        // Typical range for BTC:
        // Negative ticks = lower price
        // Positive ticks = higher price
        int24 tickLower = -887000;  // Range lower (lower price)
        int24 tickUpper = -882000;  // Range upper (higher price)
        vault.setRange(tickLower, tickUpper);
        console.log("Range set:", tickLower, " <-> ", tickUpper);

        // ============ STEP 6: FORCE REBALANCE ============
        console.log("\n--- STEP 6: Force Position Creation (Rebalance) ---");
        vault.testnet_forceRebalance();
        console.log("Rebalance executed!");

        // ============ STEP 7: CHECK POSITION INFO ============
        console.log("\n--- STEP 7: Uniswap Position Information ---");
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

        // ============ STEP 8: SIMULATE REBALANCE ============
        console.log("\n--- STEP 8: Simulate What Would Happen If Rebalanced ---");
        (
            bool shouldExit,
            bool shouldReenter,
            int24 newTickLower,
            int24 newTickUpper,
            uint256 estimatedSwapFee
        ) = vault.testnet_simulateRebalance();
        
        console.log("Should Exit:", shouldExit);
        console.log("Should Reenter:", shouldReenter);
        console.log("New Range (if applies):", newTickLower, " <-> ", newTickUpper);
        console.log("Estimated Swap Fee:", estimatedSwapFee);

        // ============ STEP 9: CHECK FINAL STATE ============
        console.log("\n--- STEP 9: Final State ---");
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("Vault totalSupply:", vault.totalSupply());
        console.log("My shares:", vault.balanceOf(deployer));
        console.log("USDC remaining in wallet:", usdc.balanceOf(deployer));

        // ============ STEP 10: TEST PARTIAL WITHDRAW ============
        console.log("\n--- STEP 10: Test Partial Withdrawal ---");
        uint256 sharesToWithdraw = sharesMinted / 2;  // Withdraw half
        if (sharesToWithdraw > 0) {
            uint256 assetsReceived = vault.redeem(sharesToWithdraw, deployer, deployer);
            console.log("Shares withdrawn:", sharesToWithdraw);
            console.log("USDC received:", assetsReceived);
        }

        console.log("\n--- FINAL STATE AFTER WITHDRAWAL ---");
        console.log("Shares remaining:", vault.balanceOf(deployer));
        console.log("Vault totalAssets:", vault.totalAssets());
        console.log("USDC in wallet:", usdc.balanceOf(deployer));

        vm.stopBroadcast();

        console.log("\n========== TEST COMPLETE! ==========\n");
        console.log("Next steps:");
        console.log("1. Monitor BTC price");
        console.log("2. When price exits range, run testnet_simulateRebalance() again");
        console.log("3. Vault should detect exit and do auto-exit/reenter");
        console.log("4. Check fees being deducted in each transaction");
    }
}
