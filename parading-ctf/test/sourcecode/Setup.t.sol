// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import {Test, console2} from "forge-std/Test.sol";
import {SetupSourceCode} from "../../src/sourcecode/SetupSourceCode.sol";

contract SetupTest {
    SetupSourceCode public stp;

    function setUp() public {
        stp = new SetupSourceCode{value: 30 ether}();
    }

    function test_GetFlag() public {
        // ther is input your code

        bool answer = false;
        answer = stp.isSolved();
        assertEq(answer, true);
    }
}
