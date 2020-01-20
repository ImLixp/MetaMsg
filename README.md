### MetaTransaction
This is an implementation of Meta Transactions.

1. metaMsg结构体
2. metaMsg


3. 复制合约到remix编译
4. 将合约地址填到to
5. 在remix中复制对应方法的payload，并填到payload中
6. 点击sign按钮，将在下方生成参数
7. 将生成的参数复制到remix中，并调用对应方法

这里是meta txs的实现。
Use EIP721 to encode MetaMsg, and then verify and exec it;
MetaMsg in solidity
```
```
MetaMsg in js
```
```
MetaMsg.sender: sender address
MetaMsg.to: the contract address
MetaMsg.value: need euqal msg.value
MetaMsg.nonce: nonce of sender in Contract
MetaMsg.refer: refer pre txs
MetaMsg.expire: expire time
MetaMsg.gasPayload: use gasPayload to pay back gas
MetaMsg.payload: call method

demo is here