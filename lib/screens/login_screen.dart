import 'dart:ui';

import 'package:crumbs_app/providers/auth_provider.dart';
import 'package:crumbs_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  // Text(
                  //   'We will send an OTP to verify your number',
                  //   style: TextStyle(fontSize: 14, color: Colors.black),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    //style: TextStyle(fontSize: 18),
                    //enabled: true,
                    decoration: InputDecoration(
                        //enabledBorder: InputBorder.none,
                        focusColor: Theme.of(context).primaryColor,
                        // border: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixText: '+91',
                        labelText: '10 digit number',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(color: Colors.grey)),
                    autofocus: false,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    controller: _phoneNumberController,
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          _validPhoneNumber = true;
                        });
                      } else {
                        setState(() {
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
                              setState(() {
                                auth.loading = true;
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                auth.screen = 'Map Screen';
                                auth.latitudeL = locationData.latitude;
                                auth.longitudeL = locationData.longitude;
                                auth.addressL = locationData.fullAddress;
                              });
                              String number =
                                  '+91${_phoneNumberController.text}';
                              auth
                                  .verifyPhone(
                                context: context,
                                number: number,
                              )
                                  .then((value) {
                                _phoneNumberController.clear();
                                // setState(() {
                                //   auth.loading = false;
                                // });
                                // Navigator.pushReplacementNamed(
                                //     context, HomeScreen.id);
                              });
                            },
                            style: ElevatedButton.styleFrom(
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
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
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
        ),
      ),
    );
  }
}
