### MetaTransaction
This is an implementation of Meta Transactions.

#### MetaMsg
We define MetaMsg and encode it with [EIP712][EIP712].

MetaMsg has 8 fields:
1. sender: the sender of Meta Transaction
2. to: the contract address
3. value: number of wei sent with Meta Transaction
4. nonce: nonce of the sender record by the contract
5. refer: dependent Meta Transaction
6. expire: the time at which a transaction expires
7. gasPayload: function signature and arguements encode in [Solidity ABI][ABI]. This used for repaying the submitter/relayer.
8. payload: function signature and arguements encode in [Solidity ABI][ABI]


MetaMsg in solidity:
```
string private constant MetaMsg_TYPE = "MetaMsg(address sender,address to,uint256 value,uint256 nonce,bytes32 refer,uint256 expire,bytes32 gasPayload,bytes32 payload)";
bytes32 private constant MetaMsg_TYPEHASH = keccak256(abi.encodePacked(MetaMsg_TYPE));
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
Demo is [here][DemoDoc].

[DemoDoc]: demo
[EIP712]: https://eips.ethereum.org/EIPS/eip-712
[ABI]: https://solidity.readthedocs.io/en/v0.6.1/abi-spec.html#abi