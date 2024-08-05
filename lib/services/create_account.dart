import 'dart:convert';

import 'package:diamanteblockchain/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';


class CreateAccount{

  BuildContext context;
  CreateAccount(this.context);

  Future<AccountModel?> create() async {
    try{
      http.Response res = await http.post(
          Uri.parse('$kUrl/create-account'), body: jsonEncode({
      },), headers: {"Content-Type": "application/json"});

      print(jsonDecode(res.body));
      return AccountModel.fromJson(jsonDecode(res.body));
    }catch(E){
      print("Flutter error: $E");
      return null;
    }
  }
}