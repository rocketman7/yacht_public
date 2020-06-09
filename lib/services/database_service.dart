import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yachtOne/models/user_model.dart';

class DatabaseService {
  Firestore _databaseService = Firestore.instance;
  Firestore get databaseService => _databaseService;

  // users collection reference
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users'); //_databaseService 사용 왜 불가한지?

  // Create: User정보 users collection에 넣기
  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  // Read: User정보 users Collection으로부터 읽기
  Future getUser(String uid) async {
    try {
      // print('DB' + uid);
      var userData = await _usersCollectionReference.document(uid).get();
      // print(userData);
      return UserModel.fromData(userData.data);
    } catch (e) {
      print(e.toString());
    }
  }
}
