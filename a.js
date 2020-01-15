D = console.log;
Json = JSON.parse;

function MetaMsgHandler(metaMsg, signMsg, sign) {
    var metaFmt = '["<sender>","<to>",<value>,<nonce>,"<refer>",<expire>,"<gasPayload>","<payload>"]';
    var metaArg = metaFmt
    .replace("<sender>", metaMsg.sender)
    .replace("<to>", metaMsg.to)
    .replace("<value>", metaMsg.value)
    .replace("<nonce>", metaMsg.nonce)
    .replace("<refer>", signMsg.refer)
    .replace("<expire>", metaMsg.expire)
    .replace("<gasPayload>", metaMsg.gasPayload)
    .replace("<payload>", metaMsg.payload);
    document.getElementById("_metamsg").value = metaArg;
    document.getElementById("_gasPayload").value = signMsg.gasPayload
    document.getElementById("_payload").value = signMsg.payload
    document.getElementById("_sigR").value = sign.r
    document.getElementById("_sigS").value = sign.s
    document.getElementById("_sigV").value = sign.v
}

function Sign(signMsg) {
    sha3=(e)=>{return web3.sha3(e=="0x"?"":e, {encoding: 'hex'})};
    bigInt=web3.toBigNumber;
    const domain = [
        { name: "name", type: "string" },
        { name: "version", type: "string" },
        { name: "chainId", type: "uint256" },
        { name: "verifyingContract", type: "address" },
        { name: "salt", type: "bytes32" },
    ];
    const MetaMsg = [
        { name: "sender", type: "address" },
        { name: "to", type: "address" },
        { name: "value", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "refer", type: "bytes32" },
        { name: "expire", type: "uint256" },
        { name: "gasPayload", type: "bytes32" },
        { name: "payload", type: "bytes32" },
    ];
    const chainId = parseInt(web3.version.network, 10);
    const domainData = {
        name: "My amazing dApp",
        version: "2",
        chainId: chainId,
        verifyingContract: "0x1C56346CD2A2Bf3202F771f50d3D14a367B48070",
        salt: "0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558"
      };

    var metaMsg = {
        sender: signMsg.sender,
        to: signMsg.to,
        value: bigInt(signMsg.value),
        nonce: bigInt(signMsg.nonce),
        refer: signMsg.refer,
        expire: bigInt(signMsg.expire),
        gasPayload: sha3(signMsg.gasPayload),
        payload: sha3(signMsg.payload),
    };
    const data = JSON.stringify({
        types: {
            EIP712Domain: domain,
            MetaMsg: MetaMsg,
        },
        domain: domainData,
        primaryType: "MetaMsg",
        message: metaMsg,
    });
    const signer = web3.toChecksumAddress(signMsg.sender);

    web3.currentProvider.sendAsync(
        {
            method: "eth_signTypedData_v4",
            params: [signer, data],
            from: signer
        },
        function(err, result) {
            if (err)
                return console.error(err);
            const signature = result.result.substring(2);
            const r = "0x" + signature.substring(0, 64);
            const s = "0x" + signature.substring(64, 128);
            const v = parseInt(signature.substring(128, 130), 16);    // The signature is now comprised of r, s, and v.
            D("r:", r);
            D("s:", s);
            D("v:", v);
            D(domainData.chainId, metaMsg);
            MetaMsgHandler(metaMsg, signMsg, {r:r, s:s, v:v});
        }
    );
}

function onBtnClick(e) {
    D("click!")
    if (web3.eth.accounts[0] == null) {
        alert("Please unlock MetaMask first");
        // Trigger login request with MetaMask
        web3.currentProvider.enable().catch(alert)
    }
    sender = web3.eth.accounts[0];
    to = document.getElementById("to").value;
    value = document.getElementById("value").value;
    nonce = document.getElementById("nonce").value;
    refer = document.getElementById("refer").value;
    expire = document.getElementById("expire").value;
    gasPayload = document.getElementById("gasPayload").value;
    payload = document.getElementById("payload").value;

    HexRegTest = (s,e=s)=>{
        if (e == -1){
            e = 4096;
        }
        return (data)=>{
            var reg = "0x[0-9a-zA-Z]{<s>,<e>}".replace("<s>", s*2).replace("<e>", e*2);
            if (data.length%2==1)
                return false;
            return new RegExp(reg).test(data);
        }
    }
    gasPayloadTest = HexRegTest(0, -1);
    payloadTest = HexRegTest(4, -1);
    referTest = HexRegTest(32);
    if (!gasPayloadTest(gasPayload)){
        D("gasPayload is wrong");
        return;
    };
    
    if (!payloadTest(payload)){
        D("payload is wrong");
        return;
    };
    
    if (!referTest(refer)){
        D("refer is wrong");
        return;
    }

    Sign({
        sender: sender,
        to : to,
        value : value,
        nonce : nonce,
        refer : refer,
        expire : expire,
        gasPayload : gasPayload,
        payload : payload,
    });
}
//function ()
window.onload = (e)=>{
    D("hello");
    var signBtn = document.getElementById("SignMeta");
    signBtn.onclick = onBtnClick; 
}