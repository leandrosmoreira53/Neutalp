// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function approve(address spender, uint256 amount) external returns (bool);
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

contract CreateInitialLiquidityScript is Script {
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address constant WBTC = 0xEf39185d82F3Dd98046107D6Ca9bA2AF77a2B5dF;
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;
    address constant NFPM = 0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65;
    
    int24 constant TICK_LOWER = -530700;
    int24 constant TICK_UPPER = -528300;
    uint24 constant FEE = 3000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Creating initial liquidity for pool...");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Mint USDC to deployer (since USDC mock is only owned by deployer)
        uint256 usdcAmount = 100e6; // 100 USDC
        console.log("Minting USDC...");
        IERC20(USDC).mint(deployer, usdcAmount);
        
        // Step 2: We have WBTC already, check balance
        uint256 wbtcBalance = IERC20(WBTC).balanceOf(deployer);
        console.log("WBTC available:", wbtcBalance / 1e8);
        
        // Use available WBTC but cap at 1 WBTC for this position
        uint256 wbtcAmount = wbtcBalance > 1e8 ? 1e8 : wbtcBalance;
        
        console.log("USDC to deposit:", usdcAmount / 1e6);
        console.log("WBTC to deposit:", wbtcAmount / 1e8);

        // Step 3: Approve tokens
        IERC20(USDC).approve(NFPM, usdcAmount);
        IERC20(WBTC).approve(NFPM, wbtcAmount);
        console.log("Tokens approved");

        // Step 4: Create position
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
        console.log("========== SUCCESS ==========");
        console.log("LP Position Created!");
        console.log("Token ID:", tokenId);
        console.log("Liquidity:", liquidity);
        console.log("USDC used:", amount0 / 1e6);
        console.log("WBTC used:", amount1 / 1e8);
        console.log("");
        console.log("View your NFT on Arbiscan:");
        string memory nftUrl = "https://sepolia.arbiscan.io/nft/0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65/";
        console.log(nftUrl);
        console.log("Token ID:", tokenId);
        console.log("");
        console.log("Direct link:");
        console.log("https://sepolia.arbiscan.io/nft/0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65/", tokenId);
    }
}
