// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {stdJson} from "forge-std/StdJson.sol";

contract Tochi {
    using stdJson for string;

    string private tochi;

    /// @param _tochi The raw JSON blob to parse
    constructor(string memory _tochi) {
        require(bytes(_tochi).length > 0, "Tochi: empty JSON");
        tochi = _tochi;
    }

    /// @dev prepend a “.” to key if missing
    function _dot(string memory key) private pure returns (string memory) {
        bytes memory b = bytes(key);
        if (b.length > 0 && b[0] == ".") return key;
        return string.concat(".", key);
    }

    /// @notice pull an address
    function getAddress(string memory key) external view returns (address) {
        return tochi.readAddress(_dot(key));
    }

    /// @notice pull a uint256
    function getUint(string memory key) external view returns (uint256) {
        return tochi.readUint(_dot(key));
    }

    /// @notice pull an int256
    function getInt(string memory key) external view returns (int256) {
        return tochi.readInt(_dot(key));
    }

    /// @notice pull a bool
    function getBool(string memory key) external view returns (bool) {
        return tochi.readBool(_dot(key));
    }

    /// @notice pull a bytes32
    function getBytes32(string memory key) external view returns (bytes32) {
        return tochi.readBytes32(_dot(key));
    }

    /// @notice pull a string
    function getString(string memory key) external view returns (string memory) {
        return tochi.readString(_dot(key));
    }

    /// @notice pull raw bytes
    function getBytes(string memory key) external view returns (bytes memory) {
        return tochi.readBytes(_dot(key));
    }
}
