import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:crumbs_app/constants.dart';
import 'package:crumbs_app/providers/auth_provider.dart';
import 'package:crumbs_app/providers/location_provider.dart';
import 'package:crumbs_app/screens/map_screen.dart';
import 'package:crumbs_app/screens/onboard_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        //constraints: BoxConstraints.tight(Size(250, 250)),
        //elevation: 40,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                //color: Colors.white,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: auth.error == 'Invalid OTP' ? true : false,
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                auth.error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Enter your phone number.',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          height: 1,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Text(
                      //   'We will send an OTP to verify your number',
                      //   style: TextStyle(fontSize: 14, color: Colors.black),
                      // ),
                      SizedBox(
                        height: 0,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          focusColor: Theme.of(context).primaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixText: '+91',
                          labelText: '10 digit number',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _phoneNumberController,
                        onChanged: (value) {
                          if (value.length == 10) {
                            myState(() {
                              _validPhoneNumber = true;
                            });
                          } else {
                            myState(() {
                              _validPhoneNumber = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: _validPhoneNumber ? false : true,
                              child: ElevatedButton(
                                onPressed: () {
                                  myState(() {
                                    auth.loading = true;
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  });
                                  String number =
                                      '+91${_phoneNumberController.text}';
                                  // No location Data So No Location Parameters
                                  auth
                                      .verifyPhone(
                                    context: context,
                                    number: number,
                                  )
                                      .then((value) {
                                    _phoneNumberController.clear();
                                  });
                                  // myState(() {
                                  //   auth.loading = false;
                                  // });

                                  // Navigator.pushReplacementNamed(
                                  //     context, HomeScreen.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  fixedSize: Size(250, 55),
                                  //fixedSize: Size.fromHeight(),
                                  primary: _validPhoneNumber
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: auth.loading
                                    ? LinearProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      )
                                    : Text(_validPhoneNumber
                                        ? 'CONTINUE'
                                        : 'ENTER PHONE NUMBER'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      //backgroundColor: const Color(0xffFBDF6A),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Stack(
          children: [
            // Positioned(
            //   right: 20.0,
            //   top: 30.0,
            //   child: GestureDetector(
            //     child: Text(
            //       'SKIP',
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     onTap: () {},
            //   ),
            // ),
            Column(
              children: [
                Expanded(child: OnBoardScreen()),
                // Text(
                //   'Ready to order from your favourite Bakery?',
                //   style: TextStyle(fontWeight: FontWeight.w400),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      locationData.loading = true;
                    });

                    await locationData.getCurrentPosition();
                    //await locationData.getMoveCamera();
                    if (locationData.permissionAllowed == true) {
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading = false;
                      });
                    } else {
                      print('Permission Not Allowed');
                      setState(() {
                        locationData.loading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    fixedSize: Size(300, 55),
                    //fixedSize: Size.fromHeight(),
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: locationData.loading
                      ? LinearProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Icon(Icons.location_on_outlined),
                            SizedBox(width: 5),
                            Text(
                              'SET DELIVERY LOCATION',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      auth.screen = 'screen';
                    });
                    showBottomSheet(context);
                  },
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontFamily: 'NeueHaasGroteskTextPro'),
                        children: [
                          TextSpan(
                            text: 'Already a customer ?  ',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                                // fontFamily: 'Hind',
                                ),
                          ),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor,
                              //fontFamily: 'Hind',
                            ),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
