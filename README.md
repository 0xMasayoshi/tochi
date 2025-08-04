# Tochi

A minimal helper library for loading and parsing JSON configs in Foundry scripts and tests.

## Installation

Install directly from GitHub:

```bash
forge install 0xMasayoshi/tochi
```

## Usage

### Library

Import and attach the tochi library to the Tochi UDVT type:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import { tochiLib, Tochi } from "tochi/src/Tochi.sol";

contract UseTochi is Script {
    using tochiLib for Tochi;

    function run() external {
        // 1) load JSON from file
        Tochi tochi = tochi.fromFile("/script/config", "hello");

        // 2) extract primitives
        string memory name = tochi.getString("name");
        uint256 supply = tochi.getUint("supply");
        address owner = tochi.getAddress("owner");

        // 3) drill into nested object
        Tochi net = tochi.getObject("network");
        string memory url = net.getString("url");

        emit log(string.concat("Name: ", name));
        emit log_uint(supply);
        emit log_address(owner);
        emit log(string.concat("Network URL: ", url));
    }
}
```

### TochiScript

Base contract for Forge scripts - auto-loads your config and exposes tochi:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { TochiScript, tochiLib, Tochi } from "tochi/src/TochiScript.sol";

contract DeployFoo is TochiScript {
    using tochiLib for Tochi;

    // point to your JSON folder (relative to project root)
    function _configDir() internal pure override returns (string memory) {
        return "/script/config";
    }

    // pick the filename (without “.json”)
    function _configName() internal view override returns (string memory) {
        return vm.envString("TOCHI_CONFIG"); 
    }

    function run() external {
        vm.startBroadcast();

        // `tochi` is already loaded
        address owner = tochi.getAddress("owner");
        string memory sym = tochi.getString("symbol");
        uint256 cap = tochi.getUint("cap");

        vm.stopBroadcast();
    }
}
```

Run the script:

```bash
TOCHI_CONFIG=ethereum forge script script/DeployFoo.s.sol --broadcast --slow
```

### TochiTest

Base contract for Forge scripts — auto-loads your config and exposes tochi:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { TochiTest, tochiLib, Tochi } from "tochi/test/TochiTest.sol";

contract TestTochi is TochiTest {
    using tochiLib for Tochi;

    // point to your JSON folder (relative to project root)
    function _configDir()  internal pure override returns (string memory) {
        return "/test";
    }

    // pick the filename (without “.json”)
    function _configName() internal pure override returns (string memory) {
        return "test";
    }

    function testFoo() public view {
        // `tochi` is loaded with test/test.json
        address owner = tochi.getAddress("owner");
        assertEq(owner, address(0));
    }
}
```

Run your tests:

```bash
forge test
```