import 'dart:convert';

import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/custom/icon_textfield.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? um;
  bool loading = false;

  getUsers() async {
    um = await getUserModel();
    print("NAME: ${um!.name}");
  }

  Future<UserModel?> getUserModel() async {
    setState(() {
      loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user_model');
    print(userJsonString);
    if (userJsonString != null) {
      // Convert JSON string to UserModel
      final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
      setState(() {
        loading = false;
      });
      return UserModel.fromJson(userJson);
    }
    setState(() {
      loading = false;
    });
    return null; // Return null if no data found
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('HELLO NISHHHbdgfvgffszfhszf sbzhf zbhsf hb zhbf zbhf'),
      ),
    );
  }
}
