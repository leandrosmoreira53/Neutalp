// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface INonfungiblePositionManager {
    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }

    function mint(MintParams calldata params) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
}

interface IPool {
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked);
}

contract CreatePoolPositionScript is Script {
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;
    address constant NFPM = 0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65;
    
    int24 constant TICK_LOWER = -530700;
    int24 constant TICK_UPPER = -528300;
    uint24 constant FEE = 3000;
    
    uint256 constant USDC_AMOUNT = 5e6; // 5 USDC (6 decimals)
    uint256 constant WBTC_AMOUNT = 1e7; // 0.1 WBTC (8 decimals)

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Creating LP position...");
        console.log("Deployer:", deployer);
        console.log("Pool:", POOL);
        console.log("USDC amount:", USDC_AMOUNT / 1e6);
        console.log("WBTC amount:", WBTC_AMOUNT / 1e8);
        console.log("Tick Lower:", int256(TICK_LOWER));
        console.log("Tick Upper:", int256(TICK_UPPER));

        vm.startBroadcast(deployerPrivateKey);

        // Approve tokens
        IERC20(USDC).approve(NFPM, USDC_AMOUNT);
        IERC20(WBTC).approve(NFPM, WBTC_AMOUNT);
        console.log("Tokens approved");

        // Create position
        INonfungiblePositionManager nfpm = INonfungiblePositionManager(NFPM);
        
        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: USDC,
            token1: WBTC,
            fee: FEE,
            tickLower: TICK_LOWER,
            tickUpper: TICK_UPPER,
            amount0Desired: USDC_AMOUNT,
            amount1Desired: WBTC_AMOUNT,
            amount0Min: 0,
            amount1Min: 0,
            recipient: deployer,
            deadline: block.timestamp + 600
        });

        (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) = nfpm.mint(params);

        vm.stopBroadcast();

        console.log("");
        console.log("=== POSITION CREATED ===");
        console.log("Token ID (NFT):", tokenId);
        console.log("Liquidity:", liquidity);
        console.log("Amount0 (USDC):", amount0 / 1e6);
        console.log("Amount1 (WBTC):", amount1 / 1e8);
        console.log("");
        console.log("View on Arbiscan:");
        console.log("NFT: https://sepolia.arbiscan.io/token/", NFPM);
        console.log("Position #", tokenId);
    }
}
