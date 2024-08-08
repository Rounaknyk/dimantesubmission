import 'dart:convert';

import 'package:diamanteblockchain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class PaymentServices{

  BuildContext context;
  PaymentServices(this.context);

  Future sendAssets(userPublicKey, amount, childSecretKey, assetName) async {
    try{
      http.Response res = await http.post(
          Uri.parse('$kUrl/send-assets'), body: jsonEncode({
        "userPublicKey" : userPublicKey,
        "amount" : amount,
        "childSecretKey" : childSecretKey,
        "assetName" : assetName
      },), headers: {"Content-Type": "application/json"});

      print("PAYMENT RESPONSE : ${jsonDecode(res.body)}");
      return jsonDecode(res.body);
    }catch(E){
      print("Flutter payment error: $E");
      return {};
    }
  }
}