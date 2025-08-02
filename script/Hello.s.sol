// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {TochiScript} from "../src/TochiScript.sol";
import {console} from "forge-std/console.sol";

contract Hello is TochiScript {
    function _configDir() internal pure override returns (string memory) {
        return "/script";
    }

    function _configName() internal pure override returns (string memory) {
        return "hello";
    }

    function run() external view {
        string memory location = tochi.getString("location");
        console.log(string.concat("Hello ", location, "!"));
    }
}