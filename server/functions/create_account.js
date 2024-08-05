const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const accRouter = express.Router();

async function createAccount(res){

    const pair = DiamSdk.Keypair.random();

    console.log("PAIR: "+pair.publicKey());
    console.log("PAIR: "+pair.secret());
    const pairPublicKey = pair.publicKey();
    const pairSecretKey = pair.secret();
    var parentJson;
    var childJson
    try {
      const response = await fetch(
            `https://friendbot.diamcircle.io?addr=${encodeURIComponent(pairPublicKey)}`
          );
        const responseJSON = await response.json();
              console.log("SUCCESS! You have a new account :)\n", responseJSON);
              parentJson = responseJSON;
      } catch (e) {
      console.error("ERROR!", e);
      parentJson = null;
      return null;
    }
    // After you've got your test lumens from friendbot, we can also use that account to create a new account on the ledger.
    try {
      const server = new DiamSdk.Horizon.Server(
        "https://diamtestnet.diamcircle.io/"
      );
      var parentAccount = await server.loadAccount(pair.publicKey()); //make sure the parent account exists on ledger
      var childAccount = DiamSdk.Keypair.random(); //generate a random account to create
      //create a transacion object.
      var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
        fee: DiamSdk.BASE_FEE,
        networkPassphrase: DiamSdk.Networks.TESTNET,
      });
      //add the create account operation to the createAccountTx transaction.
      createAccountTx = await createAccountTx
        .addOperation(
          DiamSdk.Operation.createAccount({
            destination: childAccount.publicKey(),
            startingBalance: "5",
          })
        )
        .setTimeout(180)
        .build();
      //sign the transaction with the account that was created from friendbot.
      await createAccountTx.sign(pair);
      //submit the transaction
      let txResponse = await server
        .submitTransaction(createAccountTx)
        // some simple error handling
        .catch(function (error) {
          console.log("there was an error");
          console.log(error.response);
          console.log(error.status);
          console.log(error.extras);
          return null;
        });
      childJson = txResponse;
      //console.log(txResponse);
        var data = {"parentJson": parentJson, "childJson": childJson, "childPublicKey": childAccount.publicKey(), "pairPublicKey": pairPublicKey, "pairSecretKey": pairSecretKey};
      //console.log(data);
      console.log(txResponse);
      return res.json({parentJson: parentJson, childJson: childJson, childPublicKey: childAccount.publicKey(), pairPublicKey: pairPublicKey, pairSecretKey: pairSecretKey});
    } catch (e) {
      console.error("ERROR!", e);
      childJson = null;
  }
};

accRouter.post('/create-account', async (req, res) => {
    try{
        await createAccount(res);
    }catch(e){
        console.log(e);
        return res.status(500).json({"error" : `Server error ${e}`});
    }
});

module.exports = accRouter;