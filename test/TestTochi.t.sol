// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {TochiTest} from "../src/TochiTest.sol";

contract TestTochi is TochiTest {
    function _configDir() internal pure override returns (string memory) {
        return "/test";
    }

    function _configName() internal pure override returns (string memory) {
        return "test";
    }

    function testGetAddress() public view {
        assertEq(tochi.getAddress("address"), address(0x1));
    }

    function testGetUint() public view {
        assertEq(tochi.getUint("uint"), 123);
    }

    function testGetInt() public view {
        assertEq(tochi.getInt("int"), -666);
    }

    function testGetBool() public view {
        assertTrue(tochi.getBool("bool"));
    }

    function testGetBytes32() public view {
        bytes32 v = tochi.getBytes32("bytes32");
        assertEq(v, bytes32(uint256(0x42)));
    }

    function testGetBytes() public view {
        bytes memory b = tochi.getBytes("bytes");
        assertEq(b, hex"deadbeef");
    }

    function testGetString() public view{
        assertEq(tochi.getString("string"), "test");
    }
}
