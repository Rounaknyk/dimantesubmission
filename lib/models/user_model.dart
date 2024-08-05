import 'package:diamanteblockchain/models/account_model.dart';
import 'package:flutter/material.dart';

class UserModel{
  String name, email, phone;
  AccountModel accModel;

  UserModel({required this.name, required this.email, required this.phone, required this.accModel});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      accModel: AccountModel.fromJson(json['accModel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'accModel': accModel.toJson(),
    };
  }

}