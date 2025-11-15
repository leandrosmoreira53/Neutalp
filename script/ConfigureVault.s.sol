// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IVault {
    function setUniswapConfig(address pool, address positionManager, address swapRouter) external;
}

contract ConfigureVaultScript is Script {
    address constant VAULT = 0x844bc19AEB38436131c2b4893f5E0772162F67d6;
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;
    address constant POSITION_MANAGER = 0x6b2937Bde17889EDCf8fbD8dE31C3C2a70Bc4d65;
    address constant SWAP_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Configuring vault from:", deployer);
        console.log("Vault:", VAULT);
        console.log("Pool:", POOL);
        console.log("NFPM:", POSITION_MANAGER);
        console.log("Router:", SWAP_ROUTER);

        vm.startBroadcast(deployerPrivateKey);

        IVault vault = IVault(VAULT);
        vault.setUniswapConfig(POOL, POSITION_MANAGER, SWAP_ROUTER);

        vm.stopBroadcast();

        console.log("Vault configured successfully!");
    }
}
