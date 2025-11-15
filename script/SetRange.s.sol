// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IVault {
    function setRange(int24 tickLower, int24 tickUpper) external;
}

contract SetRangeScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    int24 constant TICK_LOWER = -530700;
    int24 constant TICK_UPPER = -528300;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Setting range from:", deployer);
        console.log("Vault:", VAULT);
        console.log("Tick Lower:", int256(TICK_LOWER));
        console.log("Tick Upper:", int256(TICK_UPPER));

        vm.startBroadcast(deployerPrivateKey);

        IVault vault = IVault(VAULT);
        vault.setRange(TICK_LOWER, TICK_UPPER);

        vm.stopBroadcast();

        console.log("Range set successfully!");
    }
}
