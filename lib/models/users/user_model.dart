import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String userName;
  final bool isNameUpdated; // 기준에 맞게 유저네임 변경했는지 체크
  final String email;
  final String? phoneNumber;
  final dynamic account; // 증권계좌
  final String? avatarImage; // 아바타 이미지 url

  final num item;

  final String? friendsCode; // 앱 공유 코드
  final List<String>? insertedFriendsCode; // 자기를 추천한 친구 uid 목록
  final List<String>? blockList; // 내가 차단한 uid 목록

  final int rewardedCnt; // 아이템 리워드 받은 횟수

  final bool? membership; // 멤버쉽 가입 여부
  final dynamic membershipStartAt; // 멤버쉽 시작일
  final dynamic membershipEndAt; // 멤버쉽 종료일
  UserModel({
    required this.uid,
    required this.userName,
    required this.isNameUpdated,
    required this.email,
    required this.phoneNumber,
    required this.account,
    required this.avatarImage,
    required this.item,
    required this.friendsCode,
    required this.insertedFriendsCode,
    required this.blockList,
    required this.rewardedCnt,
    required this.membership,
    required this.membershipStartAt,
    required this.membershipEndAt,
  });

  UserModel copyWith({
    String? uid,
    String? userName,
    bool? isNameUpdated,
    String? email,
    String? phoneNumber,
    dynamic account,
    String? avatarImage,
    num? item,
    String? friendsCode,
    List<String>? insertedFriendsCode,
    List<String>? blockList,
    int? rewardedCnt,
    bool? membership,
    dynamic membershipStartAt,
    dynamic membershipEndAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      isNameUpdated: isNameUpdated ?? this.isNameUpdated,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      account: account ?? this.account,
      avatarImage: avatarImage ?? this.avatarImage,
      item: item ?? this.item,
      friendsCode: friendsCode ?? this.friendsCode,
      insertedFriendsCode: insertedFriendsCode ?? this.insertedFriendsCode,
      blockList: blockList ?? this.blockList,
      rewardedCnt: rewardedCnt ?? this.rewardedCnt,
      membership: membership ?? this.membership,
      membershipStartAt: membershipStartAt ?? this.membershipStartAt,
      membershipEndAt: membershipEndAt ?? this.membershipEndAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'isNameUpdated': isNameUpdated,
      'email': email,
      'phoneNumber': phoneNumber,
      'account': account,
      'avatarImage': avatarImage,
      'item': item,
      'friendsCode': friendsCode,
      'insertedFriendsCode': insertedFriendsCode,
      'blockList': blockList,
      'rewardedCnt': rewardedCnt,
      'membership': membership,
      'membershipStartAt': membershipStartAt,
      'membershipEndAt': membershipEndAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      userName: map['userName'],
      isNameUpdated: map['isNameUpdated'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      account: map['account'],
      avatarImage: map['avatarImage'],
      item: map['item'],
      friendsCode: map['friendsCode'],
      insertedFriendsCode: map['insertedFriendsCode'] == null
          ? null
          : List<String>.from(map['insertedFriendsCode']),
      blockList:
          map['blockList'] == null ? null : List<String>.from(map['blockList']),
      rewardedCnt: map['rewardedCnt'],
      membership: map['membership'],
      membershipStartAt: map['membershipStartAt'],
      membershipEndAt: map['membershipEndAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, userName: $userName, isNameUpdated: $isNameUpdated, email: $email, phoneNumber: $phoneNumber, account: $account, avatarImage: $avatarImage, item: $item, friendsCode: $friendsCode, insertedFriendsCode: $insertedFriendsCode, blockList: $blockList, rewardedCnt: $rewardedCnt, membership: $membership, membershipStartAt: $membershipStartAt, membershipEndAt: $membershipEndAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.userName == userName &&
        other.isNameUpdated == isNameUpdated &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.account == account &&
        other.avatarImage == avatarImage &&
        other.item == item &&
        other.friendsCode == friendsCode &&
        listEquals(other.insertedFriendsCode, insertedFriendsCode) &&
        listEquals(other.blockList, blockList) &&
        other.rewardedCnt == rewardedCnt &&
        other.membership == membership &&
        other.membershipStartAt == membershipStartAt &&
        other.membershipEndAt == membershipEndAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        userName.hashCode ^
        isNameUpdated.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        account.hashCode ^
        avatarImage.hashCode ^
        item.hashCode ^
        friendsCode.hashCode ^
        insertedFriendsCode.hashCode ^
        blockList.hashCode ^
        rewardedCnt.hashCode ^
        membership.hashCode ^
        membershipStartAt.hashCode ^
        membershipEndAt.hashCode;
  }
}
