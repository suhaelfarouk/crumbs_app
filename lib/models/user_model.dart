import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  static const NUMBER = 'number';
  static const ID = 'id';

  String? _number;
  String? _id;

  String? get number => _number;
  String? get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot.get(NUMBER); //[NUMBER];
    _id = snapshot.get(ID); //[ID];
  }
}
