import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset('animations/connect.json', height: size.height * 0.2, width: size.width * 0.2,),
              SizedBox(height: 16.0,),
              RichText(text: TextSpan(
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 32, fontFamily: 'Baloo'),
                  children: [
                    TextSpan(text: 'Hey ', style: TextStyle(color: Colors.black, )),
                    TextSpan(text: 'Rounak!', ),
                  ]
              )),
              SizedBox(height: 16.0,),
              Text('Connect your wallet and get started!', style: TextStyle(fontSize: 28, color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),),
              SizedBox(height: 32.0,),
              Container(child: CustomButton(text: 'CONNECT', backgroundColor: kPrimaryColor, onPressed: (){
                Navigator.pushNamed(context, '/home');
              }), width: 100,),
            ],
          ),
        ),
      ),
    );
  }
}
