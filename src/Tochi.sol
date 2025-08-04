// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {VmSafe} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

/// @dev Represents a JSON document with a path prefix
struct Tochi {
    string raw; // Raw JSON text
    string prefix; // Current JSON path prefix, e.g. ".object.nested"
}

/// @title Tochi JSON Helper Library
/// @notice Provides methods to load, navigate, and parse JSON configs in Foundry scripts/tests
library tochiLib {
    using stdJson for string;

    /// @dev Bound cheat-code interface for file and JSON parsing
    VmSafe private constant VM =
        VmSafe(address(uint160(uint256(keccak256("hevm cheat code")))));

    /// @notice Load a JSON file from disk and wrap it in a Tochi struct
    /// @param dir Directory path relative to the project root (e.g. "/script/config")
    /// @param name Filename without the ".json" extension
    /// @return A new Tochi struct with raw JSON and empty prefix
    function fromFile(
        string memory dir,
        string memory name
    ) internal view returns (Tochi memory) {
        string memory path = string.concat(
            VM.projectRoot(),
            dir,
            "/",
            name,
            ".json"
        );
        string memory raw = VM.readFile(path);
        require(bytes(raw).length > 0, "Tochi: file not found");
        return Tochi({raw: raw, prefix: ""});
    }

    /// @dev Ensure key has a leading dot for JSON path concatenation
    /// @param key The JSON key (without leading dot)
    /// @return The key prefixed with a dot
    function _dot(string memory key) private pure returns (string memory) {
        bytes memory b = bytes(key);
        if (b.length > 0 && b[0] == ".") return key;
        return string.concat(".", key);
    }

    /// @dev Build the full JSON path by merging prefix and key
    /// @param t The Tochi struct containing raw JSON and prefix
    /// @param key The JSON key to append
    /// @return The combined JSON path (e.g. ".prefix.key")
    function _path(
        Tochi memory t,
        string memory key
    ) private pure returns (string memory) {
        string memory _key = _dot(key);
        return
            bytes(t.prefix).length == 0 ? _key : string.concat(t.prefix, _key);
    }

    /// @notice Create a new Tochi scoped to a nested JSON object/array
    /// @param t The parent Tochi struct
    /// @param key The key of the nested object or array
    /// @return A new Tochi struct with updated prefix
    function getObject(
        Tochi memory t,
        string memory key
    ) internal pure returns (Tochi memory) {
        string memory newPrefix = _path(t, key);
        return Tochi({raw: t.raw, prefix: newPrefix});
    }

    /// @notice Parse an address value at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The parsed address
    function getAddress(
        Tochi memory t,
        string memory key
    ) internal pure returns (address) {
        return t.raw.readAddress(_path(t, key));
    }

    /// @notice Parse a uint256 value at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The parsed uint256
    function getUint(
        Tochi memory t,
        string memory key
    ) external pure returns (uint256) {
        return t.raw.readUint(_dot(key));
    }

    /// @notice Parse an int256 value at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The parsed int256
    function getInt(
        Tochi memory t,
        string memory key
    ) external pure returns (int256) {
        return t.raw.readInt(_dot(key));
    }

    /// @notice Parse a bool value at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The parsed bool
    function getBool(
        Tochi memory t,
        string memory key
    ) external pure returns (bool) {
        return t.raw.readBool(_dot(key));
    }

    /// @notice Parse a bytes32 value at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The parsed bytes32
    function getBytes32(
        Tochi memory t,
        string memory key
    ) external pure returns (bytes32) {
        return t.raw.readBytes32(_dot(key));
    }

    /// @notice Parse a string value at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The parsed string
    function getString(
        Tochi memory t,
        string memory key
    ) external pure returns (string memory) {
        return t.raw.readString(_dot(key));
    }

    /// @notice Parse raw bytes (e.g. for arrays) at the specified JSON path
    /// @param t The Tochi struct
    /// @param key The JSON key to read
    /// @return The raw bytes
    function getBytes(
        Tochi memory t,
        string memory key
    ) external pure returns (bytes memory) {
        return t.raw.readBytes(_dot(key));
    }
}
