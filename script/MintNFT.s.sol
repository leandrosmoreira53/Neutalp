// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
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

contract MintNFTFromVaultScript is Script {
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

        console.log("Step 1: Check available funds");
        console.log("Deployer USDC:", IERC20(USDC).balanceOf(deployer) / 1e6);
        console.log("Deployer WBTC:", IERC20(WBTC).balanceOf(deployer) / 1e8);
        console.log("Vault USDC:", IERC20(USDC).balanceOf(VAULT) / 1e6);
        console.log("");

        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Transfer USDC from Vault to deployer (only owner can do this)
        // Actually, we need the vault to be the owner calling this
        // Instead, let's just use direct deployment since deployer has WBTC
        
        // Since deployer has 10 WBTC but 0 USDC, let's use a smaller amounts
        // and assume we need to do a deposit in the UI first
        
        // Alternative: Withdraw from deposit in vault to get USDC back
        // This is getting complex - let me just try creating with what we have
        
        uint256 wbtcAmount = 1e7; // 0.1 WBTC
        uint256 usdcAmount = 1e5; // We need at least some USDC
        
        console.log("Need to solve: Deployer has no USDC!");
        console.log("Solution: Make a deposit in UI with MetaMask first");
        console.log("Then the deployer will have shares which can be withdrawn");
        console.log("");
        console.log("For now, showing what needs to happen:");
        console.log("1. Use UI to deposit 5 USDC -> get shares");
        console.log("2. Use UI to withdraw shares -> get USDC back");
        console.log("3. Then run this script to mint NFT");

        vm.stopBroadcast();
    }
}
