// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {Test, console2} from "forge-std/Test.sol";
import {SetupFinance} from "../../src/hint-finance/Setup.sol";
import {Exploit} from "../../src/rescue/Attack.sol";

interface ERC20Like {
    function transferFrom(address, address, uint) external;

    function transfer(address, uint) external;

    function approve(address, uint) external;

    function balanceOf(address) external view returns (uint);
}

contract SetupTest is Test {
    SetupFinance public stp;

    function setUp() public {
        stp = new SetupFinance{value: 50 ether}();
    }

    function test_GetFlag() public {
        // ther is input your code

        bool answer = false;
        answer = stp.isSolved();
        assertEq(answer, true);
    }
}
