// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
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

interface IVault {
    function deposit(uint256 assets, address receiver) external returns (uint256);
    function asset() external view returns (address);
}

contract CreateLPPositionFundedScript is Script {
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    address constant NFPM = 0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65;
    
    int24 constant TICK_LOWER = -530700;
    int24 constant TICK_UPPER = -528300;
    uint24 constant FEE = 3000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Creating LP Position...");
        console.log("Deployer:", deployer);
        console.log("");
        
        // Check balances
        uint256 deployerUsdc = IERC20(USDC).balanceOf(deployer);
        uint256 deployerWbtc = IERC20(WBTC).balanceOf(deployer);
        uint256 vaultUsdc = IERC20(USDC).balanceOf(VAULT);
        
        console.log("Deployer USDC:", deployerUsdc / 1e6);
        console.log("Deployer WBTC:", deployerWbtc / 1e8);
        console.log("Vault USDC:", vaultUsdc / 1e6);
        console.log("");

        vm.startBroadcast(deployerPrivateKey);

        // Use available tokens - smaller amounts to ensure we have both
        // Use 1 USDC and 0.01 WBTC for initial position
        uint256 usdcAmount = 1e6; // 1 USDC
        uint256 wbtcAmount = 1e6; // 0.01 WBTC (8 decimals = 1e6 = 0.01)
        
        console.log("Depositing to pool...");
        console.log("USDC amount:", usdcAmount / 1e6);
        console.log("WBTC amount:", wbtcAmount / 1e8);

        // Approve tokens for NFPM
        IERC20(USDC).approve(NFPM, usdcAmount);
        IERC20(WBTC).approve(NFPM, wbtcAmount);

        // Create position
        INonfungiblePositionManager nfpm = INonfungiblePositionManager(NFPM);
        
        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: USDC,
            token1: WBTC,
            fee: FEE,
            tickLower: TICK_LOWER,
            tickUpper: TICK_UPPER,
            amount0Desired: usdcAmount,
            amount1Desired: wbtcAmount,
            amount0Min: 0,
            amount1Min: 0,
            recipient: deployer,
            deadline: block.timestamp + 600
        });

        (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) = nfpm.mint(params);

        vm.stopBroadcast();

        console.log("");
        console.log("========== LP POSITION CREATED! ==========");
        console.log("Token ID (NFT):", tokenId);
        console.log("Liquidity:", liquidity);
        console.log("USDC used:", amount0 / 1e6);
        console.log("WBTC used:", amount1 / 1e8);
        console.log("");
        console.log("View on Arbiscan Sepolia:");
        console.log("https://sepolia.arbiscan.io/nft/0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65/", tokenId);
    }
}
