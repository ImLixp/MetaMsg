This is a simple example of MetaMsg.
1. Copy and paste [this code][MetaMsgSol] into Remix, deploy it in the Javascript VM environment.
    ![step1][deploy1]
2. Open [this page][MetaMsgDemo], and input the contract address in the `to` text-box.
3. Copy the payload of `SetOwner(address)` from remix into `payload` text-box.
    ![step2-3][encode2]
4. Click the 'SignMeta' button.
    ![setp4][sign4]
5. Copy the arguments into remix-ide, and call the `MetaMsgHandler(...)` method.
    ![setp5][metacall5]
6. Call the 'owner()' method, check the result.

[MetaMsgSol]: MetaMsg.sol
[MetaMsgDemo]: MetaMsg.html
[deploy1]: img/deploy.png
[encode3]: img/encode.png
[sign4]: img/sign.png
[metacall5]: img/metacall.png