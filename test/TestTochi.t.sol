// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {Tochi, TochiTest, tochiLib} from "../src/TochiTest.sol";

/// @title Tochi Library Tests
/// @notice Ensures JSON parsing and nested object support via the tochiLib library
contract TestTochi is TochiTest {
    using tochiLib for Tochi;

    /// @notice Returns the directory under `<projectRoot>` where test JSON fixtures reside
    function _configDir() internal pure override returns (string memory) {
        return "/test";
    }

    /// @notice Returns the base name of the JSON fixture file (without `.json` extension)
    function _configName() internal pure override returns (string memory) {
        return "test";
    }

    /// @notice Verifies that an address value is parsed correctly
    function testGetAddress() public view {
        assertEq(tochi.getAddress("address"), address(0x1));
    }

    /// @notice Verifies that a uint256 value is parsed correctly
    function testGetUint() public view {
        assertEq(tochi.getUint("uint"), 123);
    }

    /// @notice Verifies that an int256 value is parsed correctly
    function testGetInt() public view {
        assertEq(tochi.getInt("int"), -666);
    }

    /// @notice Verifies that a boolean value is parsed correctly
    function testGetBool() public view {
        assertTrue(tochi.getBool("bool"));
    }

    /// @notice Verifies that a bytes32 value is parsed correctly
    function testGetBytes32() public view {
        bytes32 v = tochi.getBytes32("bytes32");
        assertEq(v, bytes32(uint256(0x42)));
    }

    /// @notice Verifies that raw bytes are parsed correctly
    function testGetBytes() public view {
        bytes memory b = tochi.getBytes("bytes");
        assertEq(b, hex"deadbeef");
    }

    /// @notice Verifies that a string value is parsed correctly
    function testGetString() public view {
        assertEq(tochi.getString("string"), "test");
    }

    /// @notice Verifies that a nested JSON object can be extracted and queried
    function testGetObject() public view {
        // Extract the nested object under the 'object' key
        Tochi memory objectTochi = tochi.getObject("object");
        // Ensure its inner 'string' field matches expected
        assertEq(objectTochi.getString("string"), "test");
    }
}
