const express = require('express');
var DiamSdk = require("diamante-sdk-js");
var fetch = require("node-fetch");
const paymentRouter = express.Router();
//source secret account = SAUNVMEY5TOYOGQKH63V4IFCKZNHSKTM5VBPSH6XWUE44F4UAVTMQCSY
//source account = GA2JXIMKVSGPAKK53MFHY3YBQYIMDY6P77W4F35TFFCR3EJPUNBMWJUO
//desintaion account = GDA2RMC5O5GTEUB654ZKAE7K2JMTDVP4QYCLM6BBWXOUBA2FHKPLY47W
//desintation account = 
//
//sendPayment('18', 'Hello there from Rounak', 'GAP6DRIHKH3A3QUQ7HG4IXCRRU654RGN54TLHXTHUINWNLHZHSCTWBAR', 'SBXR47PLRQIHWIWMR6SW62CGMPF2TULBWPI6VV56DSLAD55EGVTLNJ2R');

async function sendPayment(res, am,me,de,so){
        console.log(typeof me);
        var amount = Buffer.from(am, 'utf8').toString();;
        var memo = Buffer.from(me, 'utf8').toString();
        var destinationId = Buffer.from(de, 'utf8').toString();
        var sourceSecretKey = Buffer.from(so, 'utf8').toString();
        console.log("Reached");
            var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
        var sourceKeys = DiamSdk.Keypair.fromSecret(""+`${sourceSecretKey}`);
        //var destinationId = "GC4ZJJRESNHECNST6HA5HUBYAUUGETMKGESJMEKYQLYBCQXTLYNVCUY7";
        // Transaction will hold a built transaction we can resubmit if the result is unknown.
        var transaction;

        // First, check to make sure that the destination account exists.
        // You could skip this, but if the account does not exist, you will be charged
        // the transaction fee when the transaction fails.

        server
          .loadAccount(""+`${destinationId}`)
          // If the account is not found, surface a nicer error message for logging.
          .catch(function (error) {
            if (error instanceof DiamSdk.NotFoundError) {
              throw new Error("The destination account does not exist!");
            } else return error;
          })
          // If there was no error, load up-to-date information on your account.
          .then(function () {
            return server.loadAccount(sourceKeys.publicKey());
          })
          .then(function (sourceAccount) {
            // Start building the transaction.
            transaction = new DiamSdk.TransactionBuilder(sourceAccount, {
              fee: DiamSdk.BASE_FEE,
              networkPassphrase: DiamSdk.Networks.TESTNET,
            })
              .addOperation(
                DiamSdk.Operation.payment({
                  destination: ""+`${destinationId}`,
                  // Because Diamante allows transaction in many currencies, you must
                  // specify the asset type. The special "native" asset represents Lumens.
                  asset: DiamSdk.Asset.native(),
                  amount: ""+`${amount}`,
                })
              )
              // A memo allows you to add your own metadata to a transaction. It's
              // optional and does not affect how Diamante treats the transaction.
              .addMemo(DiamSdk.Memo.text(""+`${memo}`))
              // Wait a maximum of three minutes for the transaction
              .setTimeout(180)
              .build();
            // Sign the transaction to prove you are actually the person sending it.
            transaction.sign(sourceKeys);
            // And finally, send it off to Diamante!
            return server.submitTransaction(transaction);
          })
          .then(function (result) {
            console.log("Success! Results:", result);
            return res.json(result);
          })
          .catch(function (error) {
            console.error("Something went wrong!", error);
            // If the result is unknown (no response body, timeout etc.) we simply resubmit
            // already built transaction:
            // server.submitTransaction(transaction);
          });
}

paymentRouter.post('/send-payment', async (req, res) => {
    try{
      await sendPayment(res, "2", "Hello there from Rounak", "GAH6GDAR47ZKAVXEQJN2DF3AFP6NOXFYAHIRTV73BC2TGZRTRBFVDKXR", "SAUNVMEY5TOYOGQKH63V4IFCKZNHSKTM5VBPSH6XWUE44F4UAVTMQCSY");
    }catch(e){
        console.log(e);
    }
});

//recPayment();

async function recPayment(res, accountPublicKey) {
  var accountId = Buffer.from(accountPublicKey, 'utf8').toString();;
  return new Promise((resolve, reject) => {
    var paymentList = [];
    var server = new DiamSdk.Horizon.Server("https://diamtestnet.diamcircle.io");
    //var accountId = "GAP6DRIHKH3A3QUQ7HG4IXCRRU654RGN54TLHXTHUINWNLHZHSCTWBAR";

    // Create an API call to query payments involving the account.
    var payments = server.payments().forAccount(accountId);

    var lastToken = loadLastPagingToken();
    if (lastToken) {
      payments.cursor(lastToken);
    }

    let streamEnded = false;
    let timer = setTimeout(() => {
      streamEnded = true;
      resolve(res.json(paymentList));
    }, 10000); // Wait for 10 seconds before resolving

    payments.stream({
      onmessage: function (payment) {
        if (streamEnded) return;

        savePagingToken(payment.paging_token);

        if (payment.to !== accountId) {
          return;
        }

        var asset;
        if (payment.asset_type === "native") {
          asset = "diam";
        } else {
          asset = payment.asset_code + ":" + payment.asset_issuer;
        }

        paymentList.push({
          'amount': payment.amount,
          'asset': asset,
          'from': payment.from
        });
        console.log(payment.amount + " " + asset + " from " + payment.from);
      },

      onerror: function (error) {
        console.error("Error in payment stream");
        clearTimeout(timer);
        reject(error);
      },
    });
  });
}

function savePagingToken(token) {
  // In most cases, you should save this to a local database or file so that
  // you can load it next time you stream new payments.
}

function loadLastPagingToken() {
  // Get the last paging token from a local database or file
}

paymentRouter.post('/rec-payment', async (req, res) => {
 console.log("Hllo");
  try{
    var list = await recPayment(res, "GAP6DRIHKH3A3QUQ7HG4IXCRRU654RGN54TLHXTHUINWNLHZHSCTWBAR");
    return res.json(list);
  }catch(e){
    
  }
});

module.exports = paymentRouter;