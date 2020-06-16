import 'package:flutter/material.dart';
import 'package:yachtOne/models/user_vote_model.dart';

class UserModel {
  final String uid;
  final String userName;
  final String email;
  final int combo;
  // final List<UserVote> userVotes;

  UserModel({
    this.uid,
    this.userName,
    this.email,
    this.combo,
    // this.userVotes,
  });

  // Json -> UserModel 변환 constructor
  UserModel.fromData(
    Map<String, dynamic> data,
  )   : uid = data['uid'],
        userName = data['userName'],
        email = data['email'],
        combo = data['combo'];
  // UserModel -> Json 변환 함수
  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'userName': this.userName,
      'email': this.email,
    };
  }
}
