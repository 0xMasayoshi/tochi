# Tochi

A minimal helper for loading JSON configs in Forge scripts.

## Installation

Install directly from GitHub:

```bash
forge install 0xMasayoshi/tochi
```

## Usage

### Tochi

Parser Contract: Create a Tochi instance with a raw JSON string and use its typed getters to extract values

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import { Tochi } from "tochi/src/Tochi.sol";

contract UseTochi is Script {
    function run() external {
        // 1) read raw JSON from disk
        string memory json = vm.readFile(string.concat(
            vm.projectRoot(),
            "/script/config",
            "/hello.json"
        ));

        // 2) create new Tochi instance
        Tochi tochi = new Tochi(json);

        // 3) use Tochi to extract values
        string memory loc   = tochi.getString("location");
        address       owner = tochi.getAddress("owner");
        uint256       cap   = tochi.getUint("cap");

        emit log(string.concat("Location: ", loc));
        emit log_address(owner);
        emit log_uint(cap);
    }
}
```

### TochiScript

Script Base: Inherit `TochiScript` in Forge scripts to get zero-boilerplate config loading and getters:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { TochiScript } from "tochi/src/TochiScript.sol";

contract DeployFoo is TochiScript {
    // 1) point to your JSON folder (relative to project root)
    function _configDir() internal pure override returns (string memory) {
        return "/script/config";
    }

    // 2) pick the filename (without “.json”)
    function _configName() internal view override returns (string memory) {
        return vm.envString("TOCHI_CONFIG");  // e.g. “goerli” or “mainnet”
    }

    function run() external {
        vm.startBroadcast();

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

Test Base: Extend TochiTest in your Forge tests to auto‐load a JSON fixture and use getters:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { TochiTest } from "tochi/test/TochiTest.sol";

contract TestTochi is TochiTest {
    function _configDir()  internal pure override returns (string memory) {
        return "/test";    // loads `<projectRoot>/test/test.json`
    }
    function _configName() internal pure override returns (string memory) {
        return "test";
    }

    function testFoo() public view {
        address owner = tochi.getAddress("owner");
        assertEq(owner, address(0));
    }
}
```

Run your tests:

```bash
forge test
```

### TochiChef

Factory Contract: A helper contract for deploying Tochi instances.

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import { TochiChef } from "tochi/src/TochiChef.sol";

contract DeployHello is Script {
    function run() external {
        vm.startBroadcast();
        TochiChef chef = new TochiChef();
        Tochi tochi = chef.fromFile("/script/config", "hello");
        string memory loc = tochi.getString("location");
        emit log(string.concat("Hello ", loc, "!"));
        vm.stopBroadcast();
    }
}
```