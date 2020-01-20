### MetaTransaction
This is an implementation of Meta Transactions.

#### MetaMsg
We define MetaMsg and encode it with EIP721.
MetaMsg has 8 fields:
1. sender: the sender of Meta Transaction
2. to: the contract address
3. value: eth value of Meta Transaction
4. nonce: nonce of the sender in contract
5. refer: dependent Meta Transaction
6. expire: expire of Meta Transaction
7. gasPayload: method and params encode in ABI
8. payload: method and params encode in ABI

MetaMsg in solidity:
```
    struct MetaMsg{
        address sender;
        address to;
        uint256 value;
        uint256 nonce;
        bytes32 refer;
        uint256 expire;
        bytes32 gasPayload;
        bytes32 payload;
    }
```
Demo is [here][demo].

[demo]: MetaMsg.html