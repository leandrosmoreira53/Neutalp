// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IVault {
    function deposit(uint256 assets, address receiver) external returns (uint256);
}

contract DepositScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    address constant USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    uint256 constant DEPOSIT_AMOUNT = 8e6; // 8 USDC (6 decimals)

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Depositing from:", deployer);
        console.log("Vault:", VAULT);
        console.log("USDC:", USDC);
        console.log("Amount:", DEPOSIT_AMOUNT / 1e6, "USDC");

        vm.startBroadcast(deployerPrivateKey);

        // Approve USDC
        IERC20 usdc = IERC20(USDC);
        usdc.approve(VAULT, DEPOSIT_AMOUNT);
        console.log("USDC approved");

        // Deposit
        IVault vault = IVault(VAULT);
        uint256 shares = vault.deposit(DEPOSIT_AMOUNT, deployer);

        vm.stopBroadcast();

        console.log("Deposit successful!");
        console.log("Shares received:", shares);
    }
}
