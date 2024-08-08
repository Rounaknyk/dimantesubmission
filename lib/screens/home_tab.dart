import 'package:diamanteblockchain/class/alert.dart';
import 'package:diamanteblockchain/class/firebase_service.dart';
import 'package:diamanteblockchain/class/local_data.dart';
import 'package:diamanteblockchain/custom/child_card.dart';
import 'package:diamanteblockchain/custom/dropdown_textfield.dart';
import 'package:diamanteblockchain/models/child_model.dart';
import 'package:diamanteblockchain/models/user_model.dart';
import 'package:diamanteblockchain/services/create_account.dart';
import 'package:diamanteblockchain/services/payment_service.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:js' as js;

import '../constants.dart';
import '../custom/custom_button.dart';
import '../custom/icon_textfield.dart';

class HomeTab extends StatefulWidget {
  HomeTab({required this.pKey, required this.role});
  String pKey;
  String role;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  showAddAssetsDialog(Size size) async {
    String assetName = '', amount = '2', publicKey = '';
    publicKey = widget.pKey;
    showDialog(
        context: context,
        builder: (context) {

          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Asset',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Enter asset name',
                            icon: Icons.abc,
                            onChanged: (value) {
                              setState(() {
                                assetName = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Amount',
                            icon: Icons.money,
                            onChanged: (value) {
                              setState(() {
                                amount = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                          hintText: 'Enter public key',
                          icon: Icons.key,
                          onChanged: (value) {
                            setState(() {
                              publicKey = value;
                            });
                          },
                          isSecured: true,
                          inputValue: publicKey,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'ADD',
                            backgroundColor: kPrimaryColor,
                            onPressed: () async {
                              mintAssets(assetName, amount, publicKey, childPublicKey);
                              // await CreateAccount(context).mint();
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  sendAssets(userPublicKey, amount, childPublicKey, assetName) async {
    var res = await PaymentServices(context).sendAssets(userPublicKey!, amount, childPublicKey, assetName);
  }

  showAddAccount(Size size) async {
    String assetName = 'default';
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Account',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        IconTextField(
                            hintText: 'Enter asset name',
                            icon: Icons.abc,
                            onChanged: (value) {
                              setState(() {
                                assetName = value;
                              });
                            }),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'SIGN',
                            backgroundColor: kPrimaryColor,
                            onPressed: () {
                              signTransaction(assetName);
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  showSendAssetDialog(Size size, assetName) async {
    String amount = '2.02';
    UserModel? um;

    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: size.width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Send Assets',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('To: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: TextDropdown(title: 'Enter username', list: umList.map((element){
                            return DropDownValueModel(name: element!.name, value: element);
                          }).toList(), onChanged: (val){
                            print("VALUE OF DROPDOWN: ${val.value}");
                            setState(() {
                              um = val.value;
                            });
                          },),
                        ),
                        // IconTextField(
                        //     hintText: 'Enter user name',
                        //     icon: Icons.abc,
                        //     onChanged: (value) {}),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text('Amount: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 4.0),
                        IconTextField(
                            hintText: 'Amount',
                            icon: Icons.money,
                            onChanged: (value) {}),
                        SizedBox(
                          height: 12.0,
                        ),
                        CustomButton(
                            text: 'SEND',
                            backgroundColor: kPrimaryColor,
                            onPressed: () {
                              sendAssets(um!.publicKey, amount, childPublicKey, 'assetName');
                            }),
                      ],
                    ),
                    Positioned(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      right: 0,
                      top: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // signTrx() async {
  //   final trx = await CreateAccount(context).getTrx("");
  //   print("TRNS : $trx}");
  // }

  List<ChildModel> childList = [];
  void mintAssets(String assetName, String amount, String parentPublicKey, String childPublicKey) async {
    // if (js.context.hasProperty('diam')) {
    // final transactionXdr;
    try {
      // final transactionXdr = await CreateAccount(context)
      //     .getTrx("GBOGTJ5FNGEVS2ILE7YDZMAWMMOLBBKXKEFHAX3UYYTF6PKQQPMPXIBJ");
      print("THIS IS UR PKEY ${parentPublicKey}");
      final transactionXdr = await CreateAccount(context).mint(assetName, amount, parentPublicKey, childPublicKey);
      print("NSS ${transactionXdr}");
      final shouldSubmit = true;
      final network = "Diamante Testnet";

      print("${transactionXdr} xdr generated");
      try {
        js.JsObject diam = js.context['diam'];
        js.JsObject signResult = diam.callMethod('sign', [transactionXdr, shouldSubmit, network]);

        // Check if the result is a Promise-like object
        if (signResult is js.JsObject && signResult.hasProperty('then')) {
          signResult.callMethod('then', [
                (result) {
              print('Signature result: $result');
            }
          ]).callMethod('catch', [
                (error) {
              print('Error signing transaction: $error');
            }
          ]);
        } else {
          // If it's not a Promise, assume it's the direct result
          print('Signature result: $signResult');
        }
      } catch (e) {
        print('Error calling sign method: $e');
      }
    } catch (e) {
      print("TRANS ${e}");
    }
    // final transactionXdr = "AAAAAgAAAADD9u0l8B7fMgvRITQuplXFfTskVrNgTgyBN1heDfkLEAAAAGQApCseAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAADId5UakWjIgj3XsdYXl/8mJKTpUSUIu8F3IcB7cKoQ1wAAAAAAAAAAAExLQAAAAAAAAAAA";

    // } else {
    //   print("Diam extension is not installed.");
    // }
  }

  void signTransaction(assetName) async {

    try {
      print("THIS IS UR PKEY ${widget.pKey}");
      final res = await CreateAccount(context)
          .getTrx(widget.pKey);
      childSecretKey = res['childSecretKey'];
      childPublicKey = res['childPublicKey'];
      LocalData().saveToLocalStorage('childPublicKey', res['childPublicKey']);
      LocalData().saveToLocalStorage('childSecretKey', res['childSecretKey']);
      var transactionXdr = res['text'];
      // print(transactionXdr);
      final shouldSubmit = true;
      final network = "Diamante Testnet";

      // print("${transactionXdr} xdr generated");
      try {
        js.JsObject diam = js.context['diam'];
        js.JsObject signResult = diam.callMethod('sign', [transactionXdr, shouldSubmit, network]);

        // Check if the result is a Promise-like object
        if (signResult is js.JsObject && signResult.hasProperty('then')) {
          signResult.callMethod('then', [
                (result) {
              print('Signature result: $result');
            }
          ]).callMethod('catch', [
                (error) {
              print('Error signing transaction: $error');
            }
          ]);
        } else {
          // If it's not a Promise, assume it's the direct result
          print('Signature result: $signResult');
        }
      } catch (e) {
        print('Error calling sign method: $e');
      }
    } catch (e) {
      print("TRANS ${e}");
    }
    // final transactionXdr = "AAAAAgAAAADD9u0l8B7fMgvRITQuplXFfTskVrNgTgyBN1heDfkLEAAAAGQApCseAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAADId5UakWjIgj3XsdYXl/8mJKTpUSUIu8F3IcB7cKoQ1wAAAAAAAAAAAExLQAAAAAAAAAAA";

    // } else {
    //   print("Diam extension is not installed.");
    // }
    setState(() {

    });
    childList.add(ChildModel(id: '1', childPublicKey: childPublicKey, assetName: assetName, childSecretKey: childSecretKey, balance: '0', parentPubicKey: widget.pKey));
    Navigator.pop(context);
  }

  List<UserModel?> umList = [
    UserModel(name: 'Select someone', publicKey: 'publicKey', email: 'email', role: 'role'),
  ];
  String parentSecretKey = '', childSecretKey = '', childPublicKey = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKeys();
    getUsers();
  }

  getKeys() async {
    var parentSecretKey = await LocalData().loadStoredValue('secretKey');
    print("THIS IS PARENT KEY $parentSecretKey");

    try {
      childSecretKey = await LocalData().loadStoredValue('childSecretKey');
      childPublicKey = await LocalData().loadStoredValue('childPublicKey');
      print("THIS IS CHILD S KEY $childSecretKey");
      print("THIS IS CHILD P KEY $childPublicKey");

    }catch(e){
      childSecretKey = '';
      Alert(context: context).alert('Error getting child key');
    }
  }

  getUsers() async {
    umList = await FirebaseService().getAllUsers();
    print(umList.length);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  showAddAccount(size);
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 250,
                    width: 230,
                    padding:
                    EdgeInsets.symmetric(vertical: 50.0, horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kPrimaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Add account',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            childList.isEmpty ? Container() : ChildCard(cm: childList[0], childSecretKey: childList[0].childSecretKey, parentPublicKey: childList[0].parentPubicKey, childPublicKey: childPublicKey, role: widget.role),
    // ChildCard(cm: ChildModel(childPublicKey: childPublicKey, assetName: 'bridgeGoa', childSecretKey: childSecretKey, balance: '1800', parentPubicKey: widget.pKey, id: '1'), childSecretKey: childSecretKey, parentPublicKey: widget.pKey, childPublicKey: childPublicKey, role: widget.role),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send assets',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.0,
              ),
              InkWell(
                onTap: () {
                  showSendAssetDialog(size, 'assetName');
                  // onPressed();
                },
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'SEND ASSETS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14),
                          ),
                          SizedBox(width: 8.0,),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text('${widget.pKey}'),
              // Text('Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus, voluptates.\nQui ratione aspernatur tempore incidunt alias, aperiam \naccusamus ullam natus?'),
              SizedBox(
                height: 12.0,
              ),
              Text(
                'Transactions',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('BridgeGoa'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('232'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('From',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('To',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('DATE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('24 June 2024'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('BridgeGoa'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('232'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('From',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('To',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('DATE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('24 June 2024'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('BridgeGoa'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('232'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('From',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('To',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('DATE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('24 June 2024'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('BridgeGoa'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('232'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('From',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('To',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('KJHAS...SADAD'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Text('DATE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('24 June 2024'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
