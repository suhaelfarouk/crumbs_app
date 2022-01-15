import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crumbs_app/providers/location_provider.dart';
import 'package:crumbs_app/screens/home_screen.dart';
import 'package:crumbs_app/screens/map_screen.dart';
import 'package:crumbs_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String? screen;
  String? addressL;
  double? latitudeL;
  double? longitudeL;

  Future<void> verifyPhone({
    required BuildContext context,
    required String number,
  }) async {
    this.loading = true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      this.verificationId = verId;
      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          });
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // insetPadding: EdgeInsets.all(30),
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Enter 6 digit OTP recieved as SMS',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 65,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text('DONE'),
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsOtp,
                    );
                    final User? user =
                        (await _auth.signInWithCredential(credential)).user;

                    if (user != null) {
                      _userServices.getUserById(user.uid).then((snapshot) {
                        if (snapshot.exists) {
                          // User Data Already Exists
                          if (this.screen == 'Login') {
                            // Need To Check The Data Already Exists In Firebase Or Not.
                            // If Its Login No New Data So Need To Update.
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          } else {
                            // Need To Update New Selected Address
                            updateUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          }
                        } else {
                          // User Data Not Exists
                          // Will Create New Data
                          _createUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.id);
                        }
                      });
                    } else {
                      print('Login Failed');
                    }

                    // Navigate to HomePage After Login
                  } catch (e) {
                    //print(e);
                    this.error = 'Invaid OTP';
                    notifyListeners();
                    print(e.toString());

                    Navigator.pop(context);

                    // Dont Want To Come Back To Welcome Screen After Login

                    //Navigator.pushReplacementNamed(context, HomeScreen.id);
                  }
                },
              )
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({
    String? id,
    String? number,
  }) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitudeL,
      'longitude': this.longitudeL,
      'address': this.addressL,
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    String? id,
    String? number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': this.latitudeL,
        'longitude': this.longitudeL,
        'address': this.addressL,
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }
}
