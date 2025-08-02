// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {Tochi} from "./Tochi.sol";
import {TochiChef} from "./TochiChef.sol";

abstract contract TochiTest is Test {
    Tochi internal tochi;

    /// sealed setUp() – always loads your config
    function setUp() public {
        TochiChef tochiChef = new TochiChef();
        tochi = tochiChef.fromFile(_configDir(), _configName());
        _afterConfigLoaded();
    }

    /// optional hook for logging or sanity checks
    function _afterConfigLoaded() internal virtual {}

    /// child must point at the JSON folder, e.g. "/script/config"
    function _configDir()  internal view virtual returns (string memory);

    /// child must pick a name, e.g. via envString("CONFIG")
    function _configName() internal view virtual returns (string memory);
}
