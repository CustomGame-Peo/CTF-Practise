// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {Test, console2} from "forge-std/Test.sol";
import {SetupRescue} from "../../src/rescue/SetupRescue.sol";
import {Exploit} from "../../src/rescue/Attack.sol";

interface ERC20Like {
    function transferFrom(address, address, uint) external;

    function transfer(address, uint) external;

    function approve(address, uint) external;

    function balanceOf(address) external view returns (uint);
}

contract SetupTest is Test {
    SetupRescue public stp;

    function setUp() public {
        stp = new SetupRescue{value: 50 ether}();
    }

    function test_GetFlag() public {
        // ther is input your code

        //这里是从MasterChef中获取池，然后从池获取uniswap的path兑换路径，这里打印了28组
        //0:WETH->USDT   1:USDC->WETH  2DAI->WETH  3:sUSD->WETH ...
        Exploit a;
        a = new Exploit{value: 100 ether}(stp);
        /*
        string memory b;
        string memory c;
        address d;
        address f;
        uint i = 0;
        for (i = 0; i < 28; i++) {
            (b, c) = a.getTokenSymbol(i);
            assertEq(b, c);

            (d, f) = a.getTokenAddress(i);
            assertEq(d, f);
        }
        */

        bool answer = false;
        answer = stp.isSolved();
        assertEq(answer, true);
    }
}
