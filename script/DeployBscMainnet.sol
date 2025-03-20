pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

import {BrevisFee} from "../src/BrevisFeeVault.sol";
import {BinVipHook,IBinPoolManager} from "../src/pool-bin/BinVipHook.sol";
import {CLVipHook,ICLPoolManager} from "../src/pool-cl/CLVipHook.sol";

/**
 * forge script script/DeployBscMainnet.sol --rpc-url https://binance.llamarpc.com --keystore xxxxx.json --broadcast --verify
 */
contract Deploy is Script {
    string public deployConfigPath = string.concat("script/config/bscMainnet.json");

    function run() public {
        string memory config = vm.readFile(deployConfigPath);
        address brevReq = stdJson.readAddress(config, ".brevisRequest");
        address clpm = stdJson.readAddress(config, ".clPoolManager");
        address binpm = stdJson.readAddress(config, ".binPoolManager");

        vm.startBroadcast();

        BrevisFee feev = new BrevisFee();
        console.log("BrevisFee contract deployed at ", address(feev));

        BinVipHook binHook = new BinVipHook(IBinPoolManager(binpm), 0, brevReq);
        console.log("binHook contract deployed at ", address(binHook));

        CLVipHook clHook = new CLVipHook(ICLPoolManager(clpm), 0, brevReq);
        console.log("clHook contract deployed at ", address(clHook));
        
        vm.stopBroadcast();
    }
}