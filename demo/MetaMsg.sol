pragma experimental ABIEncoderV2;
pragma solidity ^0.5.0;

contract MetaMsg {
    uint256 constant chainId = 1;
    address constant verifyingContract = 0x1C56346CD2A2Bf3202F771f50d3D14a367B48070;
    bytes32 constant salt = 0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558;
    string private constant EIP712_DOMAIN  = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)";
    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(EIP712_DOMAIN));
    bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256("My amazing dApp"),
        keccak256("2"),
        chainId,
        verifyingContract,
        salt
    ));
    
    string private constant MetaMsg_TYPE = "MetaMsg(address sender,address to,uint256 value,uint256 nonce,bytes32 refer,uint256 expire,bytes32 gasPayload,bytes32 payload)";
    bytes32 private constant MetaMsg_TYPEHASH = keccak256(abi.encodePacked(MetaMsg_TYPE));
    struct Msg{
        address sender;
        address to;
        uint256 value;
        uint256 nonce;
        bytes32 refer;
        uint256 expire;
        bytes32 gasPayload;
        bytes32 payload;
    }
    mapping(address=>uint256) public nonce;
    mapping(bytes32=>uint256) public txid;
    address sender;

    modifier onlyMeta(){
        require(msg.sender==address(this), "onlyMeta");
        _;
    }

    function hashMetaMsg(Msg memory metamsg) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                MetaMsg_TYPEHASH,
                metamsg.sender,
                metamsg.to,
                metamsg.value,
                metamsg.nonce,
                metamsg.refer,
                metamsg.expire,
                metamsg.gasPayload,
                metamsg.payload
            ))
        ));
    }

    function MetaMsgHandler(Msg memory metamsg, bytes memory gasPayload, bytes memory payload, bytes32 sigR, bytes32 sigS, uint8 sigV) public payable  {
        require(metamsg.nonce == 0 || metamsg.nonce == nonce[metamsg.sender]+1, "nonce wrong!");
        require(uint256(metamsg.refer) == 0 || txid[metamsg.refer] > 0, "refer wrong!");
        require(metamsg.expire == 0 || block.timestamp < metamsg.expire, "tx is expired!");
        require(msg.value == metamsg.value, "value is invalid!");
        require(address(this) == metamsg.to, "to is wrong");

        require(keccak256(gasPayload) == metamsg.gasPayload, "gasPayload is wrong");
        require(keccak256(payload) == metamsg.payload, "payload is wrong");

        bytes32 txID = hashMetaMsg(metamsg);
        address ecAddress = ecrecover(txID, sigV, sigR, sigS);
        require(metamsg.sender == ecAddress, "verify failed!");
        require(txid[txID] == 0, "tx is exist!");
        bool ret;
        bytes memory returnData;
        if (gasPayload.length > 0){
            (ret, returnData) = metamsg.to.call(gasPayload);
            require(ret, string(returnData));
        }
        sender = metamsg.sender;
        (ret, returnData) = metamsg.to.call.value(msg.value)(payload);
        require(ret, string(returnData));
        nonce[metamsg.sender]++;
        txid[txID] = block.number;
    }
    function MetaImpl() private; // just prevent generate bin
}

    
contract MetaContract is MetaMsg{
    address public owner;
    modifier onlyOwner(){require(MetaMsg.sender == owner, "onlyOwner");_;}
    function SetOwner(address newOwner) public onlyMeta onlyOwner {
        owner = newOwner;
    }

    function MetaImpl() private{}
}