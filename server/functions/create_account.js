const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const accRouter = express.Router();
const { Asset } = require('diamante-sdk-js');
const {TransactionBuilder} = require('diamante-sdk-js');
const {Keypair} = require('diamante-sdk-js');
const {BASE_FEE} = require('diamante-sdk-js');
const {Operation} = require('diamante-sdk-js');

async function assetMinter(asset_name, distributor, recevier) {
    try {
        var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

        const account = await server.loadAccount("GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J");
        const asset = new Asset(
            "HH",
            "GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J"
        );

        const transaction = new TransactionBuilder(account, {
            fee: BASE_FEE,
            networkPassphrase: "Diamante Testnet",
        })
            .addOperation(
                Operation.payment({
                    destination: "GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ",
                    asset,
                    amount: "30",
                })
            )
            .setTimeout(100)
            .build();

        transaction.sign(Keypair.fromSecret("SDZZMINYGBXBP2YWNRFBYSFOJYSCB2EB2FHK27X3GCLMMWITYL3D6I6W"));
        const result = await server.submitTransaction(transaction);
        if (result.successful === true) {
            console.log("###################################")

            console.log()
            console.log("Asset ", asset.code, " distributed  to ", "GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ")
            console.log("Transaction hash: ", result.hash)

            console.log()

            console.log("###################################")

        }
    } catch (e) {
        console.log(e);

    }
}

async function getTrx(res, key){
  var parentKey = Buffer.from(key, 'utf8').toString();;
  try{
    const pair = DiamSdk.Keypair.random();

    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

    var parentAccount = await server.loadAccount(parentKey); //make sure the parent account exists on ledger
    console.log(parentAccount);
    var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    });

    const pairPublicKey = pair.publicKey();
    const pairSecretKey = pair.secret();

    console.log("CHILD KEY "+pairPublicKey);
    
  var createAccountTx = await createAccountTx
      .addOperation(
        DiamSdk.Operation.createAccount({
          destination: pairPublicKey,
          startingBalance: "2.01",
        })
      )
      .setTimeout(0)
      .build();

      res.json({'text' : createAccountTx.toEnvelope().toXDR('base64')});

  }catch(e){
    res.json(e);
    console.log(e);
  }
}

accRouter.post('/trx', async (req, res) => {
  console.log("HELLO!");
  const {key} = req.body;
  console.log(key);
  await getTrx(res, key);
});

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
    //await assetMinter('HH', 'GD57QPEMR5ITCIAGA3PGIU4TU7CQPCHXQ7UAWTHGLDJDL5KPH3KEQA7J', 'GBMW4OURLY5J6PFU7VBLBC2LSSX3CE377MN2QVSR76CWIZMLAHGVNCQJ');
      await createAccount(res);
    }catch(e){
        console.log(e);
        return res.status(500).json({"error" : `Server error ${e}`});
    }
});

module.exports = accRouter;