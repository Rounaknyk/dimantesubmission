import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:diamanteblockchain/class/alert.dart';
import 'package:diamanteblockchain/constants.dart';
import 'package:diamanteblockchain/custom/custom_button.dart';
import 'package:diamanteblockchain/custom/icon_textfield.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:diamanteblockchain/services/create_account.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js' as js;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? um;
  bool loading = false;
  var pKey;

  void checkDiamExtension() {

      if (js.context.hasProperty('diam')) {
        print("Diam extension is installed!");

        try {
          var connectResult = js.context['diam'].callMethod('connect');

          if (connectResult is js.JsObject && connectResult.hasProperty('then')) {
            // If it's a Promise-like object
            connectResult.callMethod('then', [
                  (result) {

              setState(() {
                pKey = result['message'][0];
              });
              print(pKey);
                Alert(context: context).alert(result as js.JsObject);
              }
            ]).callMethod('catch', [
                  (error) {
                print('Error: $error');
              }
            ]);
          } else {
            // If it's not a Promise-like object, assume it's the result directly
            print('User active public key is: ${connectResult['message'][0]}');
          }
        } catch (e) {
          print('Error connecting to Diam: $e');
        }
      } else {
        print("Diam extension is not installed.");
      }
  }

  Future<void> connectDiam() async {
    if (js.context.hasProperty('diam')) {
      try {
        final result = await promiseToFuture(js.context['diam'].callMethod('connect'));
        print("Result ${result.runtimeType}");
        if (result != null) {

          if (result is Map) {
            if (result.containsKey('message')) {
              final message = result['message'];
              if (message is List && message.isNotEmpty) {
                final publicKey = message[0];
                print(publicKey);
                pKey = message[0];
                setState(() {

                });
              } else {
                print('Unexpected message structure: $message');
              }
            } else {
              print('Result does not contain "message" key. Keys: ${result.keys.toList()}');
            }
          } else {
            print('Result is not a Map. Type: ${result.runtimeType}');
          }
        } else {
          print('Result is null');
        }
      } catch (error) {
        print('Error connecting to Diam: $error');
      }
    } else {
      print('Diam extension is not installed.');
    }
  }


  // Future<void> connectDiam() async {
  //   if (js.context.hasProperty('diam')) {
  //     try {
  //       final result = await promiseToFuture(js.context['diam'].callMethod('connect'));
  //
  //       print("AWAIT: $result");
  //       window.console.log('RESULTTTT: $result ');
  //
  //       window.console.log('Result as JSON string: ${jsonEncode(result)}');
  //
  //       String prettyJsonString = const JsonEncoder.withIndent('  ').convert(result);
  //       window.console.log('Pretty printed JSON result: $prettyJsonString');
  //       debugPrint('AWAIT LODE: $result', wrapWidth: 10);
  //
  //       print('Raw result from diam.connect(): ${jsonEncode(result)}');
  //       js.context.callMethod('console.log', ['${result}']);
  //
  //       pKey = "NN $result";
  //       setState(() {
  //         pKey = "NN $result";
  //       });
  //
  //       if (result != null) {
  //         pKey = result;
  //         print("THIS IS THE RESULT: ${result}");
  //         if (result is Map) {
  //           if (result.containsKey('message')) {
  //             final message = result['message'];
  //             if (message is List && message.isNotEmpty) {
  //               final publicKey = message[0];
  //               pKey = message[0];
  //               setState(() {
  //
  //               });
  //               js.context.callMethod('console.log', ['${publicKey}']);
  //               // print('User active public key is: $publicKey');
  //               // debugPrint('${publicKey}!', wrapWidth: 10);
  //             } else {
  //               print('Unexpected message structure: $message');
  //             }
  //           } else {
  //             print('Result does not contain "message" key. Keys: ${result.keys.toList()}');
  //           }
  //         } else {
  //           print('Result is not a Map. Type: ${result.runtimeType}');
  //         }
  //       } else {
  //         print('Result is null');
  //       }
  //     } catch (error) {
  //       print('Error connecting to Diam: $error');
  //     }
  //   } else {
  //     print('Diam extension is not installed.');
  //   }
  // }

  Future<dynamic> promiseToFuture(Object jsPromise) {
    final completer = Completer<dynamic>();
    final success = js.allowInterop((result) => completer.complete(result));
    final error = js.allowInterop((e) => completer.completeError(e));
    js.context['Promise'].callMethod('resolve', [jsPromise]).callMethod('then', [success, error]);
    return completer.future;
  }

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

  void signTransaction() async {
    // if (js.context.hasProperty('diam')) {
      // final transactionXdr;
      try {
        final transactionXdr = await CreateAccount(context).getTrx("GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7c");
        print(transactionXdr);
        final shouldSubmit = true;
        final network = "Diamante Testnet";

        // js.context['diam'].callMethod('sign', [
        //   transactionXdr,
        //   shouldSubmit,
        //   network
        // ]).then((result) {
        //   print('Signature result: $result');
        // }).catchError((error) {
        //   print('Error signing transaction: $error');
        // });
      }catch(e){
        print("TRANS ${e}");
      }
      // final transactionXdr = "AAAAAgAAAADD9u0l8B7fMgvRITQuplXFfTskVrNgTgyBN1heDfkLEAAAAGQApCseAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAADId5UakWjIgj3XsdYXl/8mJKTpUSUIu8F3IcB7cKoQ1wAAAAAAAAAAAExLQAAAAAAAAAAA";

    // } else {
    //   print("Diam extension is not installed.");
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkDiamExtension();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        final transactionXdr = await CreateAccount(context).getTrx("GDUJ7O2MRH72ZRGV26RVKM7547O25JAYHOFRZZDYISYM4LNFAEGGUZA7c");
        // checkDiamExtension();
      }, child: Icon(Icons.add, color: Colors.white,),),
      appBar: AppBar(title: Text('$kName'), backgroundColor: kPrimaryColor, centerTitle: false,),
      body: Center(
        child: SafeArea(
          child: Center(
            child: InkWell(child: Text('SIGN'), onTap: (){
              signTransaction();
            },),
          ),
        ),
      ),
    );
  }
}
