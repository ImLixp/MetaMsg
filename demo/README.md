This is an example of MetaMsg.
1. Copy and paste [this code][MetaMsgSol] into [Remix][remix], deploy it in the Javascript VM environment.  
    ![step1][deploy1]
2. Open [this page][MetaMsgDemo], and input the contract address in the `to` input box.
3. Copy the payload of `SetOwner(address)` from [Remix][remix] into `payload` input box.  
    ![step2-3][encode3]
4. Click the 'SignMeta' button.  
    ![step4][sign4]
5. Copy the arguments into [Remix][remix], and call the `MetaMsgHandler(...)` method.  
    ![step5][metacall5]
6. Call the 'owner()' method, check the result.  
    ![step6][owner6]


[remix]: http://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.5.12+commit.7709ece9.js
[MetaMsgSol]: MetaMsg.sol
[MetaMsgDemo]: https://imlixp.github.io/MetaMsg/demo/MetaMsg.html
[deploy1]: img/deploy.png
[encode3]: img/encode.png
[sign4]: img/sign.png
[metacall5]: img/metacall.png
[owner6]: img/owner.png