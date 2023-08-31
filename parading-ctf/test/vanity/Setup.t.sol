// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {Test, console2} from "forge-std/Test.sol";
import {SetupVanity} from "../../src/vanity/SetupVanity.sol";

interface ERC20Like {
    function transferFrom(address, address, uint) external;

    function transfer(address, uint) external;

    function approve(address, uint) external;

    function balanceOf(address) external view returns (uint);
}

contract SetupTest is Test {
    function setUp() public {
        stp = new SetupVanity{value: 30 ether}();
    }

    function test_GetFlag() public {
        // ther is input your code

        bool answer = false;
        answer = stp.isSolved();
        assertEq(answer, true);
    }
}
