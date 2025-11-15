// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

// Minimal interface for NFPM
interface IPositionManager {
    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable returns (address pool);
}

/**
 * @title CreatePoolScript
 * @notice Script para criar e inicializar pool WBTC/USDC na Uniswap v3
 * @dev Run:
 *  forge script script/CreatePool.s.sol:CreatePoolScript \
 *    --rpc-url $SEPOLIA_RPC_URL --broadcast
 */
contract CreatePoolScript is Script {
    // Arbitrum Sepolia addresses (from official Uniswap v3 docs)
    address constant POSITION_MANAGER = 0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65; // NFPM testnet
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    uint24 constant FEE = 3000; // 0.3%
    uint160 constant SQRT_PRICE_X96 = 251754800101319638; // sqrt(100000) * 2^96

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Creating pool from:", deployer);
        console.log("USDC:", USDC);
        console.log("WBTC:", WBTC);
        console.log("Fee:", FEE, "bps");
        console.log("sqrtPriceX96:", SQRT_PRICE_X96);

        vm.startBroadcast(deployerPrivateKey);

        // Create and initialize pool
        IPositionManager nfpm = IPositionManager(POSITION_MANAGER);
        
        // Ensure USDC < WBTC (sorted token addresses)
        address token0 = USDC < WBTC ? USDC : WBTC;
        address token1 = USDC < WBTC ? WBTC : USDC;
        
        console.log("Token0:", token0);
        console.log("Token1:", token1);
        
        address pool = nfpm.createAndInitializePoolIfNecessary(token0, token1, FEE, SQRT_PRICE_X96);

        vm.stopBroadcast();

        console.log("Pool created at:", pool);
        console.log("Use this address in the vault configuration:");
        console.log(pool);
    }
}
