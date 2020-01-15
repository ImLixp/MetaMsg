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
    mapping(address=>uint256) public nonce;
    mapping(bytes32=>uint256) public txid;

    function hashMetaMsg(MetaMsg memory metamsg) private pure returns (bytes32) {
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

    function MetaMsgHandler(MetaMsg memory metamsg, bytes memory gasPayload, bytes memory payload, bytes32 sigR, bytes32 sigS, uint8 sigV) public payable  {
        require(keccak256(gasPayload) == metamsg.gasPayload, "gasPayload is wrong");
        require(keccak256(payload) == metamsg.payload, "payload is wrong");
        require(address(this) == metamsg.to, "to is wrong");
        bytes32 id = hashMetaMsg(metamsg);
        address recaddr = ecrecover(id, sigV, sigR, sigS);
        require(metamsg.sender == recaddr, "verify failed!");
        require(metamsg.nonce == 0 || metamsg.nonce == nonce[metamsg.sender]+1, "nonce wrong!");
        require(uint256(metamsg.refer) == 0 || txid[metamsg.refer] > 0, "refer wrong!");
        require(txid[id] == 0, "tx is exist!");
        require(metamsg.expire == 0 || now < metamsg.expire, "tx is expired!");
        require(msg.value == metamsg.value, "value is invalid!");
        bool ret;
        bytes memory returnData;
        if (gasPayload.length > 0){
            (ret, returnData) = metamsg.to.call(gasPayload);
            require(ret, "gas insufficient");
        }
        (ret, returnData) = metamsg.to.call.value(msg.value)(payload);
        require(ret, string(returnData));
        nonce[metamsg.sender]++;
        txid[id] = block.number;
    }
}

    
contract MetaContract is MetaMsg{    
    modifier onlyThis(){
        require(msg.sender==address(this), "onlyThis");
        _;
    }
    address public owner;
    function SetOwner(address _owner) public onlyThis{
        owner = _owner;
    }
}