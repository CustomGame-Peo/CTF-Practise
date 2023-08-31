
# Challenge #1 - Unstoppable  
挑战#1 - 势不可挡

There’s a tokenized vault with a million DVT tokens deposited. It’s offering flash loans for free, until the grace period ends.  
有一个代币化的金库，存有 100 万个 DVT 代币。它免费提供闪电贷款，直到宽限期结束。

To pass the challenge, make the vault stop offering flash loans.  
要通过挑战，请让金库停止提供闪电贷。

You start with 10 DVT tokens in balance.  
您一开始有 10 个 DVT 代币余额。

### solved
这题我们可以看到函数flashLoan有一个如下条件判断
```
if (convertToShares(totalSupply) != balanceBefore)
revert InvalidBalance(); // enforce ERC4626 requirement
```
也就是说当前合约的铸造币数量如果不等于合约的金额，就会进入这个错误，所以我们只需要向该合约转入金额即可。
涉及EIP 4626 金库(vault)相关
# Challenge #2 - Naive receiver  
挑战 #2 - 幼稚的接收者

There’s a pool with 1000 ETH in balance, offering flash loans. It has a fixed fee of 1 ETH.  
有一个余额为 1000 ETH 的资金池，提供闪电贷。它的固定费用为 1 ETH。

A user has deployed a contract with 10 ETH in balance. It’s capable of interacting with the pool and receiving flash loans of ETH.  
用户部署了一份余额为 10 ETH 的合约。它能够与矿池交互并接收 ETH 的闪贷。

Take all ETH out of the user’s contract. If possible, in a single transaction.  
从用户合约中取出所有 ETH。如果可能的话，在一次交易中。

### solved
这题每次闪电贷的费用是1 eth，最后通过的要求是用户合约金额为0，池中的金额为1000+用户金额，所以我们只需要连续10次闪电贷即可。
```
const ETH = await pool.ETH();
var hack = await pool.connect(player);
for (var i = 0; i < 10; i++) {
pool.flashLoan(receiver.address, ETH, 0, 0);
}
```


# Challenge #3 - Truster 挑战 #3 - 信任者 

More and more lending pools are offering flash loans. In this case, a new pool has launched that is offering flash loans of DVT tokens for free.  
越来越多的贷款池提供闪电贷款。在这种情况下，推出了一个新的池，免费提供 DVT 代币的闪电贷。

The pool holds 1 million DVT tokens. You have nothing.  
该池持有 100 万个 DVT 代币。你什么都没有。

To pass this challenge, take all tokens out of the pool. If possible, in a single transaction.  
要通过此挑战，请将所有代币从池中取出。如果可能的话，在一次交易中。

### solved
观察代码可以知道这道题在`flashLoan`调用了其他合约里的代码`functionCall`与`call`一样，所以一个比较常见的方法就是调用`approve`，使我们可以任意操作这个合约的代币，在用transferFrom进行金额的转移即可。
```
function solve(
address token,
TrusterLenderPool pool,
address attack
) public {

uint256 poolBalance = IERC20(token).balanceOf(address(pool));

bytes memory byteApprove = abi.encodeWithSignature(
"approve(address,uint256)",
address(this),
poolBalance
);

pool.flashLoan(0, attack, address(token), byteApprove);
IERC20(token).transferFrom(address(pool), attack, poolBalance);

}
```

# Challenge #4 - Side Entrance  
挑战 #4 - 侧入口

A surprisingly simple pool allows anyone to deposit ETH, and withdraw it at any point in time.  
一个令人惊讶的简单池允许任何人存入 ETH，并在任何时间点提取它。

It has 1000 ETH in balance already, and is offering free flash loans using the deposited ETH to promote their system.  
它已经有 1000 ETH 余额，并使用存入的 ETH 提供免费闪电贷来推广他们的系统。

Starting with 1 ETH in balance, pass the challenge by taking all ETH from the pool.  
从余额 1 ETH 开始，通过从池中取出所有 ETH 来通过挑战。



### solved


# Challenge #5 - The Rewarder  
挑战 #5 - 奖励者

There’s a pool offering rewards in tokens every 5 days for those who deposit their DVT tokens into it.  
有一个池子每 5 天为那些将 DVT 代币存入其中的人提供代币奖励。

Alice, Bob, Charlie and David have already deposited some DVT tokens, and have won their rewards!  
Alice、Bob、Charlie 和 David 已经存入了一些 DVT 代币，并赢得了奖励！

You don’t have any DVT tokens. But in the upcoming round, you must claim most rewards for yourself.  
您没有任何 DVT 代币。但在接下来的回合中，你必须为自己争取最多的奖励。

By the way, rumours say a new pool has just launched. Isn’t it offering flash loans of DVT tokens?  
顺便说一句，有传言说新的矿池刚刚推出。它不是提供 DVT 代币的闪电贷吗？


这道题存款金额越多，奖励的代币越多并且没有上限，其计算公式为despoitAmount * rewardAmount，我们的目标是要尽可能拿最多的奖励，而代码中快找并不是连续不断的数据点，而是通过某个固定时间进行一次快照。所以我们只要在快照之前闪电贷借入大量的金额，并触发快照，在下次周期来之前，我们就可以获得最多的奖励token。如下：
```

```
# Challenge #6 - Selfie 挑战 #6 - 自拍

A new cool lending pool has launched! It’s now offering flash loans of DVT tokens. It even includes a fancy governance mechanism to control it.  
一个新的炫酷借贷池已经推出！它现在提供 DVT 代币的闪电贷款。它甚至包括一个奇特的治理机制来控制它。

What could go wrong, right ?  
可能会出什么问题，对吧？

You start with no DVT tokens in balance, and the pool has 1.5 million. Your goal is to take them all.  
一开始没有余额的 DVT 代币，池中有 150 万枚。你的目标是把它们全部拿走。

### solved

鲸鱼攻击：攻击者持有大量某个token，用于控制合约。

这道题跟上面那道题类似，只要我们在发出提案的所持有的代币大于DVT的supply一半，就可以将我们的提案加入执行队列，再去执行。所以通过闪电贷，我们可以直接获取150万的DVT，而DTV总发行量为200万，然后再去执行pool里的一个名为emergencyExit函数，这个函数会清空池，发送给指定接收者，但该函数执行需要治理角色，所以我们将我们的提案发给治理合约，再让治理合约去执行这个函数即可。approve也可以其实。

# Challenge #7 - Compromised

# 挑战 #7 - 妥协

While poking around a web service of one of the most popular DeFi projects in the space, you get a somewhat strange response from their server. Here’s a snippet:  
在浏览该领域最受欢迎的 DeFi 项目之一的 Web 服务时，您会从他们的服务器得到有点奇怪的响应。这是一个片段：

```
HTTP/2 200 OK
content-type: text/html
content-language: en
vary: Accept-Encoding
server: cloudflare

4d 48 68 6a 4e 6a 63 34 5a 57 59 78 59 57 45 30 4e 54 5a 6b 59 54 59 31 59 7a 5a 6d 59 7a 55 34 4e 6a 46 6b 4e 44 51 34 4f 54 4a 6a 5a 47 5a 68 59 7a 42 6a 4e 6d 4d 34 59 7a 49 31 4e 6a 42 69 5a 6a 42 6a 4f 57 5a 69 59 32 52 68 5a 54 4a 6d 4e 44 63 7a 4e 57 45 35

4d 48 67 79 4d 44 67 79 4e 44 4a 6a 4e 44 42 68 59 32 52 6d 59 54 6c 6c 5a 44 67 34 4f 57 55 32 4f 44 56 6a 4d 6a 4d 31 4e 44 64 68 59 32 4a 6c 5a 44 6c 69 5a 57 5a 6a 4e 6a 41 7a 4e 7a 46 6c 4f 54 67 33 4e 57 5a 69 59 32 51 33 4d 7a 59 7a 4e 44 42 69 59 6a 51 34
```

A related on-chain exchange is selling (absurdly overpriced) collectibles called “DVNFT”, now at 999 ETH each.  
一个相关的链上交易所正在出售（定价高得离谱）名为“DVNFT”的收藏品，目前每件售价 999 ETH。

This price is fetched from an on-chain oracle, based on 3 trusted reporters: `0xA732...A105`,`0xe924...9D15` and `0x81A5...850c`.  
该价格是从链上预言机获取的，基于 3 个可信报告者： `0xA732...A105` 、 `0xe924...9D15` 和 `0x81A5...850c` 。

Starting with just 0.1 ETH in balance, pass the challenge by obtaining all ETH available in the exchange.  
从余额只有 0.1 ETH 开始，通过获取交易所中所有可用的 ETH 来通过挑战。

这道题先不写


# Challenge #8 - Puppet 挑战 #8 - 木偶

There’s a lending pool where users can borrow Damn Valuable Tokens (DVTs). To do so, they first need to deposit twice the borrow amount in ETH as collateral. The pool currently has 100000 DVTs in liquidity.  
有一个借贷池，用户可以借用该死的有价值的代币（DVT）。为此，他们首先需要存入两倍于借款金额的 ETH 作为抵押品。该池目前流动性为 100000 DVT。

There’s a DVT market opened in an old [Uniswap v1 exchange](https://docs.uniswap.org/contracts/v1/overview), currently with 10 ETH and 10 DVT in liquidity.  
旧的 Uniswap v1 交易所开设了一个 DVT 市场，目前有 10 ETH 和 10 DVT 的流动性。

Pass the challenge by taking all tokens from the lending pool. You start with 25 ETH and 1000 DVTs in balance.  
通过从借贷池中取出所有代币来通过挑战。您一开始有 25 个 ETH 和 1000 个 DVT 余额。



### solved

这道题问题主要出现在池中的价格是根据uniswap池中的两个代币的商进行计算的，所以而我们手中掌握的token是可以控制unniswap池里的价格的，所以首先将DVT token全部转入池中，就可以让eth的价格迅速升高，1000个DVT可以用几乎20个eth就可以全部兑换出抵押池里的物品。

# Challenge #9 - Puppet V2  
挑战 #9 - 木偶 V2

The developers of the [previous pool](https://damnvulnerabledefi.xyz/challenges/puppet/) seem to have learned the lesson. And released a new version!  
之前矿池的开发者们似乎已经吸取了教训。并发布了新版本！

Now they’re using a [Uniswap v2 exchange](https://docs.uniswap.org/contracts/v2/overview) as a price oracle, along with the recommended utility libraries. That should be enough.  
现在，他们使用 Uniswap v2 交易所作为价格预言机，以及推荐的实用程序库。那应该足够了。

You start with 20 ETH and 10000 DVT tokens in balance. The pool has a million DVT tokens in balance. You know what to do.  
您一开始有 20 个 ETH 和 10000 个 DVT 代币余额。该池有 100 万个 DVT 代币余额。你知道该做什么。

跟上道题一样，就是调用的api不同


# Challenge #10 - Free Rider  
挑战 #10 - 搭便车者

A new marketplace of Damn Valuable NFTs has been released! There’s been an initial mint of 6 NFTs, which are available for sale in the marketplace. Each one at 15 ETH.  
一个新的有价值的 NFT 市场已经发布！最初铸造了 6 种 NFT，可在市场上出售。每一件售价 15 ETH。

The developers behind it have been notified the marketplace is vulnerable. All tokens can be taken. Yet they have absolutely no idea how to do it. So they’re offering a bounty of 45 ETH for whoever is willing to take the NFTs out and send them their way.  
其背后的开发人员已被告知该市场很容易受到攻击。所有代币都可以拿走。但他们完全不知道该怎么做。因此，他们悬赏 45 ETH，奖励任何愿意将 NFT 拿出来发送的人。

You’ve agreed to help. Although, you only have 0.1 ETH in balance. The devs just won’t reply to your messages asking for more.  
您已同意提供帮助。虽然，你的余额只有 0.1 ETH。开发人员不会回复您要求更多信息的消息。

If only you could get free ETH, at least for an instant.  
如果你能获得免费的 ETH 就好了，至少是暂时的。

### solved

这道题问题出现在buyMany，不过需要先看buyOne，这个函数在买入nft时，会先比较msg.value是否大于等于priceToPay，满足条件就可以买入，但是buyMany是循环执行buyOne的，也就是说我们只要付1次的钱，便可以把所有的nft全部取出来。但是我们首先要有第一次付款的金额，这个我们应该如何来呢？答案是unswap闪电贷款，FreeRiderRecovery合约，这个合约可以让我们出售前5个nft之一时，获取45 ether的金额，但只有一次。

思路：先通过uniswap获取15 ether，然后buyMany买下所有nft，再将买下的nft发送给FreeRiderRecovery，其接收nft函数onERC721Received(ERC721)会给卖家45 ether，在用这钱还给uniswap。