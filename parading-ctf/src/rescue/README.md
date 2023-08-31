# Rescue

这道题主要考察 Defi 知识，考察了 uniswap 交互和 MasterChef 的基本操作

## 漏洞

这道题的漏洞主要体现在函数\_addLiquidity。
在添加流动性时，会发现在向 uniswap 池中添加流动性时，其使用的是 MasterChefHelper 的余额进行的支付。

## 代码分析

swapTokenForPoolToken：将某个 token 变换为另外两个 token，然后向 uniswap 的池中添加流动性。
\_swap：将某个代币换成另外一种代币，存在当前合约中。

## 漏洞利用

根据函数\_addLiquidity，我们只需要让目的合约包含两种代币时，在让我们的 exploit 有另一种代币，调用 swapTokenForPoolToken 后，最后在添加流动性时会将余额代币全部作为添加流动性的金额。
这里需要注意的是 uniswap 池在添加流动性时，token0 和 token1 会按照最佳的兑换比例进行添加的，所以在我们添加 token 太小的话，就会导致代币无法全部转出。
所以我们需要设置好代币的数量，对转入目的合约的另一种代币需要足够多的量。
首先我用 usdc 存入目的合约，然后在利用 5 weth 兑换一些 dai 存入 exploit，最后再使用 4 ether 对 weth 和 usdc 的代币对进行目标池流动性添加。

最后执行

```
forge test --match-path test/rescue/Setup.t.sol -vv --fork-url https://mainnet.infura.io/v3/{your_key}
```

## 参考

https://medium.com/amber-group/web3-hacking-paradigm-ctf-2022-writeup-3102944fd6f5
