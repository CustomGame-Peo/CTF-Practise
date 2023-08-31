# Hint-Finance

这是一道跟 defi 相关的题目

## 代码分析

首先我们看看 Setup 做了什么事

### Setup

该合约的构造函数创建了 3 个 HintFinanceVault 的钱包，分别对应代币为 PNT、SAND、AMP，并且将合约里的这三个代币分别转到对应的金库中。接着让 initialUnderlyingBalances 的值分别为这三个金库余额的初始值
然后将所有的奖励代币加入白名单。

获取 flag 的方法是让每个金库的 underlyingTokens 小于 initialUnderlyingBalances 的百分之一
所以我们最终目的是让每个金库的金额缩水百分之 99
