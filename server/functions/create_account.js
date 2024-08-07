const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const accRouter = express.Router();
const { Asset } = require('diamante-sdk-js');
const {TransactionBuilder} = require('diamante-sdk-js');
const {Keypair} = require('diamante-sdk-js');
const {BASE_FEE} = require('diamante-sdk-js');
const {Aurora} = require('diamante-sdk-js');
const {Server} = require('diamante-sdk-js');
const {Operation} = require('diamante-sdk-js');
const { Resolver } = require('diamante-sdk-js/lib/stellartoml');

// setupRecevier("GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57", "GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7", "BridgeGoa").then(function () {
//   assetMinter("BridgeGoa", "GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57");
// })

// mintAndTransferAsset("", "", "", "");

async function mintAndTransferAsset(pair, publicKey, assetCode, supply) {
  const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

  try {
    // Load the account
    const pairAccount = await server.loadAccount("GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57");

    // Create asset
    const _asset = new DiamSdk.Asset("Bridggg", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57");

    // Build the minting transaction
    let transaction = new DiamSdk.TransactionBuilder(pairAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    })
      .addOperation(
        DiamSdk.Operation.payment({
          destination: "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI",
          asset: _asset,
          amount: "8",
        })
      )
      .setTimeout(100)
      .build();

    // Sign the transaction
    const issuingKeys = DiamSdk.Keypair.fromSecret("SBEQSONKMFK6ZNPL64TMRC3666REZUZLO7SSD3AYOK2FRK5LTF4JJTX7");
    transaction.sign(issuingKeys);

    // Submit the minting transaction
    const mintResult = await server.submitTransaction(transaction);
    console.log('Minting transaction successful:', mintResult);

    // Build the transfer transaction
    let transferTx = new DiamSdk.TransactionBuilder(pairAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    })
      .addOperation(
        DiamSdk.Operation.payment({
          destination: "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI",
          asset: _asset,
          amount: "1000",
        })
      )
      .setTimeout(0)
      .build();

    // Sign the transfer transaction
    transferTx.sign(issuingKeys);

    // Submit the transfer transaction
    const transferResult = await server.submitTransaction(transferTx);
    console.log('Transfer transaction successful:', transferResult);

    if (transferResult.successful) {
      console.log('Asset minted and transferred successfully. Check your wallet, happy tokenisation!');
      return true;
    } else {
      console.log('Transactions failed');
      return false;
    }
  } catch (error) {
    console.error('Error:', error);
    return false;
  }
}

// Usage example:
// const pair = DiamanteSdk.Keypair.fromSecret('YOUR_SECRET_KEY');
// const publicKey = 'DESTINATION_PUBLIC_KEY';
// const assetCode = 'ASSET_CODE';
// const supply = '1000'; // as a string

// mintAndTransferAsset(pair, publicKey, assetCode, supply)
//   .then(result => console.log('Operation result:', result))
//   .catch(error => console.error('Operation failed:', error));


accRouter.post('/mint', async (req, res) =>{
  await assetMinter(res, "", "", "");
});

// assetMinter(res, "", "", "");
async function assetMinter(res,asset_name, distributor, recevier) {
  console.log("Asda");
  try {
      const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

      const account = await server.loadAccount("GAPKDJ7S6L7VSCVVI3GRAJMBM3H3M2KODCPPXWHVIYS75EPTMHOXEESP");
      const asset = new Asset(
          "BLOW",
          "GAGWNMFNSF2H4HJBO6ITTW7LRQDPJNQ3JV753D5IPEKXADKICZS4BJEK"
      );

      const transaction = new TransactionBuilder(account, {
          fee: BASE_FEE,
          networkPassphrase: "Diamante Testnet",
      })
          .addOperation(
              Operation.payment({
                  destination: "GAGWNMFNSF2H4HJBO6ITTW7LRQDPJNQ3JV753D5IPEKXADKICZS4BJEK",
                  asset,
                  amount: "30",
              })
          )
          .addOperation(
            Operation.manageData({
                name: "BLOW",
                value: "BLOW asset",
            })
          )
            .addOperation(
              Operation.setOptions({
                masterWeight: 0,
              })
            )
            
        
          .setTimeout(100)
          .build();

          return res.json({'text' : transaction.toEnvelope().toXDR('base64')});

          // console.log(`TRANSSSS: ${transaction}`);
      // transaction.sign(Keypair.fromSecret("SBEQSONKMFK6ZNPL64TMRC3666REZUZLO7SSD3AYOK2FRK5LTF4JJTX7"));
      // const result = await server.submitTransaction(transaction);
      // if (result.successful === true) {
      //     console.log("###################################")

      //     console.log()
      //     console.log("Asset ", asset.code, " distributed  to ", "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI")
      //     console.log("Transaction hash: ", result.hash)

      //     console.log()

      //     console.log("###################################")

      // }
  } catch (e) {
      console.log(e);

  }


}

// setupRecevier("", "", "");
async function setupRecevier(recevier, distributor, asset_name) {
  try {
    const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

      var issuingKeys = DiamSdk.Keypair.fromSecret(
        "SC4I55A7DI3UGH4S72PGDCH5JL4C3G3OKRGOHDYQSI6OOP35PLCUYLPP"
      );
      
      var receivingKeys = DiamSdk.Keypair.fromSecret(
        "SDILEZ54H53ILMRKZ72JRWRGTYOR7YPN457ASA3KHPCI4IWD74DUVFBS"
      );


      const account = await server.loadAccount(receivingKeys.publicKey());

      const _asset = new Asset(
          "RBj",
          issuingKeys.publicKey(), //issuer
      );

      const transaction = new TransactionBuilder(account, {
          fee: BASE_FEE,
          networkPassphrase: "Diamante Testnet",
      })
          .addOperation(
              Operation.changeTrust({ asset: _asset, limit: "1000" })
          )
          .setTimeout(100)
          .build();

      transaction.sign(receivingKeys);
      const result = await server.submitTransaction(transaction);
      if (result.successful === true) {
          console.log("###################################")

          console.log()
          console.log("Trustline created for ", _asset.code, " with issuer ", _asset.getIssuer())
          console.log("Transaction hash: ", result.hash)

          console.log()

          console.log("###################################")
      }
  } catch (e) {
      console.log(e);

  }
}

async function getTrx(res, key){
  console.log("HEOA");
  var parentKey = Buffer.from(key, 'utf8').toString();;
  try{
    const pair = DiamSdk.Keypair.random();
    console.log(pair);

    console.log("Child Public key: "+pair.publicKey());
    console.log("Child Private key: "+pair.secret());
    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

    var parentAccount = await server.loadAccount(parentKey); //make sure the parent account exists on ledger
    console.log(`parent ${parentAccount}`);
    var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
      fee: DiamSdk.BASE_FEE,
      networkPassphrase: DiamSdk.Networks.TESTNET,
    });

    const pairPublicKey = pair.publicKey();
    const pairSecretKey = pair.secret();

    // console.log("CHILD KEY "+pairPublicKey);
    
    createAccountTx = await createAccountTx
    .addOperation(
      DiamSdk.Operation.createAccount({
        destination: pair.publicKey(),
        startingBalance: "2.01",
      })
    )
    .setTimeout(0)
    .build();

      /**
       * await createAccountTx.sign(pair);
    //submit the transaction
    let txResponse = await server
      .submitTransaction(createAccountTx)
       */

      return res.json({'text' : createAccountTx.toEnvelope().toXDR('base64')});

  }catch(e){
    res.json(e);
    console.log(e);
  }
}

async function createTrust(res, pAcc, cAcc){

  var parentAcc = Buffer.from(pAcc, 'utf8').toString();
  var childAcc = Buffer.from(cAcc, 'utf8').toString();;

  console.log("Parent Account Secret:", parentAcc);
  console.log("Child Account Secret:", childAcc);


  try {
    const server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");

      var issKey = DiamSdk.Keypair.fromSecret(
        "SDILEZ54H53ILMRKZ72JRWRGTYOR7YPN457ASA3KHPCI4IWD74DUVFBS"
      );
      var recKey = DiamSdk.Keypair.fromSecret(
        "SDSAS2G55D4O24EIGMBC62SCSZNXPMYSU3JKW27ASVGINERFMECRVZYA"
      );

      const account = await server.loadAccount(recKey.publicKey());

      const _asset = new Asset(
          "GM",
          issKey.publicKey(), //issuer
      );

      const transaction = new TransactionBuilder(account, {
          fee: BASE_FEE,
          networkPassphrase: "Diamante Testnet",
      })
          .addOperation(
              Operation.changeTrust({ asset: _asset, limit: "1000" })
          )
          .setTimeout(100)
          .build();

      transaction.sign(recKey);
      const result = await server.submitTransaction(transaction);
      if (result.successful === true) {
          console.log("###################################")

          console.log()
          console.log("Trustline created for ", _asset.code, " with issuer ", _asset.getIssuer())
          console.log("Transaction hash: ", result.hash)

          console.log()

          console.log("###################################")
      }
  } catch (e) {
      console.log(e);

  }
}

accRouter.post('/create-trust', async (req, res) => {
  try{
    const {issKey, recKey} = req.body;
    await createTrust(res, "GCNLWIT4BKHN4Y4KSNLEOCTRC7YKWSHULAYGQN3FN4GCZSYSKE4G7FTC", "SDSAS2G55D4O24EIGMBC62SCSZNXPMYSU3JKW27ASVGINERFMECRVZYA");
  }catch(e){
    console.log(e);
  }
});

accRouter.post('/trx', async (req, res) => {
  console.log("eajs2")
  const {key} = req.body;
  console.log(key);
  await getTrx(res, key);
});

// createAccount("SBEQSONKMFK6ZNPL64TMRC3666REZUZLO7SSD3AYOK2FRK5LTF4JJTX7");
// assetMinter("bRIDHH", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57", "GDPAAM26D55ORFAZQPZBCQF3KHE25K5AU6CUMAADI4CXSC2PJXU2AUEI");

async function createParentAcc(res, publicKey){
  try {
      const response = await fetch(
            `https://friendbot.diamcircle.io?addr=${encodeURIComponent(publicKey)}`
          );
        const responseJSON = await response.json();
              console.log("SUCCESS! You have a new account :)\n", responseJSON);
              parentJson = responseJSON;
              return res.json(responseJSON);
      } catch (e) {
      console.error("ERROR!", e);
      parentJson = null;
      
      return null;
    }
}

accRouter.post('/create-parent-account', async (req, res) => {
  try{
    const {key} = req.body;
    await createParentAcc(res, key);
  }catch(e){
    console.log(e);
  }
});

async function createAccount(parentKey){

    // console.log(Keypair.fromSecret(parentKey));

    const pair = DiamSdk.Keypair.random();

    console.log("PAIR: "+pair.publicKey());
    console.log("PAIR: "+pair.secret());
    const pairPublicKey = pair.publicKey();
    const pairSecretKey = pair.secret();
    var parentJson;
    var childJson;
    // try {
    //   const response = await fetch(
    //         `https://friendbot.diamcircle.io?addr=${encodeURIComponent(pairPublicKey)}`
    //       );
    //     const responseJSON = await response.json();
    //           console.log("SUCCESS! You have a new account :)\n", responseJSON);
    //           parentJson = responseJSON;
    //   } catch (e) {
    //   console.error("ERROR!", e);
    //   parentJson = null;
    //   return null;
    // }
    // After you've got your test lumens from friendbot, we can also use that account to create a new account on the ledger.
    try {
      const server = new DiamSdk.Horizon.Server(
        "https://diamtestnet.diamcircle.io/"
      );
      var parentAccount = await server.loadAccount("GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57"); //make sure the parent account exists on ledger
      var childAccount = DiamSdk.Keypair.random(); //generate a random account to create
      //create a transacion object.
      var createAccountTx = new DiamSdk.TransactionBuilder(parentAccount, {
        fee: DiamSdk.BASE_FEE,
        networkPassphrase: DiamSdk.Networks.TESTNET,
      });
      //add the create account operation to the createAccountTx transaction.
      const _asset = new Asset(
        "BridgeGoa",
        "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57"
    );
      createAccountTx = await createAccountTx
        .addOperation(
          DiamSdk.Operation.createAccount({
            destination: childAccount.publicKey(),
            asset: _asset,
            startingBalance: "7",
          })
        )
        .setTimeout(180)
        .build();
      //sign the transaction with the account that was created from friendbot.
      // var acc = await Keypair.fromPublicKey(parentKey);
      await createAccountTx.sign(Keypair.fromSecret(parentKey));
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
      console.log(data);
      assetMinter("Vurdd", "GAS56X7NFIVQUAXA3JMLPIPPNWV4FOTJ7ODTRU3VDC5TM4Y7NSAEEB57", childAccount.publicKey()); 
      // return res.json({parentJson: parentJson, childJson: childJson, childPublicKey: childAccount.publicKey(), pairPublicKey: pairPublicKey, pairSecretKey: pairSecretKey});
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