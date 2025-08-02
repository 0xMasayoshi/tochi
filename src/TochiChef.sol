// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {VmSafe} from "forge-std/Vm.sol";
import {Tochi}  from "./Tochi.sol";

/// @notice A little factory for Tochi
contract TochiChef {
    /// bind the cheat-code interface so we can read files
    VmSafe private constant VM = VmSafe(
        address(uint160(uint256(keccak256("hevm cheat code"))))
    );

    /// @notice Creates new Tochi from an on-disk JSON file
    /// @param dir  path under projectRoot (e.g. "/script/config")
    /// @param name filename without “.json” (e.g. "hello")
    /// @return instance of a Tochi contract wrapping that JSON
    function fromFile(string memory dir, string memory name) external returns (Tochi) {
        string memory path = string.concat(VM.projectRoot(), dir, "/", name, ".json");
        string memory raw  = VM.readFile(path);
        require(bytes(raw).length > 0, "TochiChef: file not found");
        return new Tochi(raw);
    }

    /// @notice Deploys a new Tochi parser directly from a JSON string
    /// @param raw JSON text
    /// @return instance of a Tochi contract wrapping that JSON
    function fromJson(string memory raw) external returns (Tochi) {
        require(bytes(raw).length > 0, "TochiChef: empty JSON");
        return new Tochi(raw);
    }
}
