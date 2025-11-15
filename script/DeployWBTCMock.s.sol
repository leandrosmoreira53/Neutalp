// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/mocks/Mocks.sol";

/**
 * @title DeployWBTCMockScript
 * @notice Deploys a mock WBTC (8 decimals) and mints initial supply to deployer
 * @dev Run:
 *  forge script script/DeployWBTCMock.s.sol:DeployWBTCMockScript \
 *    --rpc-url $SEPOLIA_RPC_URL --broadcast --verify --etherscan-api-key $ARBISCAN_API_KEY
 */
contract DeployWBTCMockScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying WBTC mock from:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy Mock WBTC with 8 decimals
        MockERC20 wbtc = new MockERC20("Wrapped BTC", "WBTC", 8);

        // Mint 10 WBTC (10 * 10^8)
        wbtc.mint(deployer, 10 * 1e8);

        vm.stopBroadcast();

        console.log("WBTC mock deployed at:", address(wbtc));
        console.log("Minted 10 WBTC to:", deployer);
    }
}
