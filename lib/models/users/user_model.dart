import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  String userName;
  // final String userName;
  final bool? isNameUpdated; // 기준에 맞게 유저네임 변경했는지 체크
  final String? email;
  final String? phoneNumber;
  final dynamic account; // 증권계좌
  String? avatarImage; // 아바타 이미지 url
  // final String? avatarImage; // 아바타 이미지 url

  final num item;

  final String? friendsCode; // 앱 공유 코드
  final bool? friendsCodeDone; // 추천완료
  final String? insertedFriendsCode; // 내가 추천한 추천코드
  final List<String>? friendsUidRecommededMe; // 나를 추천한 UID LIST
  final List<String>? blockList; // 내가 차단한 uid 목록

  final int? rewardedCnt; // 아이템 리워드 받은 횟수

  final int exp;
  final String? tier;

  // final num? followersNum;
  final List<String>? followers;
  // final num? followingNum;
  final List<String>? followings;

  String? intro;
  // final String? intro;
  final List<String>? favoriteStocks;
  final List<String>? badges;

  final bool? membership; // 멤버쉽 가입 여부
  final dynamic membershipStartAt; // 멤버쉽 시작일
  final dynamic membershipEndAt; // 멤버쉽 종료일

  final dynamic lastNotificationCheckDateTime; // 마지막으로 알림 확인한 일시

  final String? token;
  UserModel({
    required this.uid,
    required this.userName,
    this.isNameUpdated,
    this.email,
    this.phoneNumber,
    this.account,
    this.avatarImage,
    required this.item,
    this.friendsCode,
    this.friendsCodeDone,
    this.insertedFriendsCode,
    this.friendsUidRecommededMe,
    this.blockList,
    this.rewardedCnt,
    required this.exp,
    this.tier,
    this.followers,
    this.followings,
    this.intro,
    this.favoriteStocks,
    this.badges,
    this.membership,
    this.membershipStartAt,
    this.membershipEndAt,
    this.token,
    this.lastNotificationCheckDateTime,
  });

  UserModel copyWith({
    String? uid,
    String? userName,
    bool? isNameUpdated,
    String? email,
    String? phoneNumber,
    dynamic? account,
    String? avatarImage,
    num? item,
    String? friendsCode,
    bool? friendsCodeDone,
    String? insertedFriendsCode,
    List<String>? friendsUidRecommededMe,
    List<String>? blockList,
    int? rewardedCnt,
    int? exp,
    String? tier,
    List<String>? followers,
    List<String>? followings,
    String? intro,
    List<String>? favoriteStocks,
    List<String>? badges,
    bool? membership,
    dynamic? membershipStartAt,
    dynamic? membershipEndAt,
    String? token,
    dynamic lastNotificationCheckDateTime,
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
      friendsCodeDone: friendsCodeDone ?? this.friendsCodeDone,
      insertedFriendsCode: insertedFriendsCode ?? this.insertedFriendsCode,
      friendsUidRecommededMe:
          friendsUidRecommededMe ?? this.friendsUidRecommededMe,
      blockList: blockList ?? this.blockList,
      rewardedCnt: rewardedCnt ?? this.rewardedCnt,
      exp: exp ?? this.exp,
      tier: tier ?? this.tier,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      intro: intro ?? this.intro,
      favoriteStocks: favoriteStocks ?? this.favoriteStocks,
      badges: badges ?? this.badges,
      membership: membership ?? this.membership,
      membershipStartAt: membershipStartAt ?? this.membershipStartAt,
      membershipEndAt: membershipEndAt ?? this.membershipEndAt,
      token: token ?? this.token,
      lastNotificationCheckDateTime:
          lastNotificationCheckDateTime ?? this.lastNotificationCheckDateTime,
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
      'friendsCodeDone': friendsCodeDone,
      'insertedFriendsCode': insertedFriendsCode,
      'friendsUidRecommededMe': friendsUidRecommededMe,
      'blockList': blockList,
      'rewardedCnt': rewardedCnt,
      'exp': exp,
      'tier': tier,
      'followers': followers,
      'followings': followings,
      'intro': intro,
      'favoriteStocks': favoriteStocks,
      'badges': badges,
      'membership': membership,
      'membershipStartAt': membershipStartAt,
      'membershipEndAt': membershipEndAt,
      'token': token,
      'lastNotificationCheckDateTime': lastNotificationCheckDateTime,
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
      friendsCodeDone: map['friendsCodeDone'],
      insertedFriendsCode: map['insertedFriendsCode'],
      friendsUidRecommededMe: map['friendsUidRecommededMe'] == null
          ? null
          : List<String>.from(map['friendsUidRecommededMe']),
      blockList:
          map['blockList'] == null ? null : List<String>.from(map['blockList']),
      rewardedCnt: map['rewardedCnt'] ?? 0,
      exp: map['exp'] ?? 0,
      tier: map['tier'],
      followers:
          map['followers'] == null ? null : List<String>.from(map['followers']),
      followings: map['followings'] == null
          ? null
          : List<String>.from(map['followings']),
      intro: map['intro'],
      favoriteStocks: map['favoriteStocks'] == null
          ? null
          : List<String>.from(map['favoriteStocks']),
      badges: map['badges'] == null ? null : List<String>.from(map['badges']),
      membership: map['membership'],
      membershipStartAt: map['membershipStartAt'],
      membershipEndAt: map['membershipEndAt'],
      token: map['token'],
      lastNotificationCheckDateTime: map['lastNotificationCheckDateTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, userName: $userName, isNameUpdated: $isNameUpdated, email: $email, phoneNumber: $phoneNumber, account: $account, avatarImage: $avatarImage, item: $item, friendsCode: $friendsCode, friendsCodeDone: $friendsCodeDone, insertedFriendsCode: $insertedFriendsCode, friendsUidRecommededMe: $friendsUidRecommededMe, blockList: $blockList, rewardedCnt: $rewardedCnt, exp: $exp, tier: $tier, followers: $followers, followings: $followings, intro: $intro, favoriteStocks: $favoriteStocks, badges: $badges, membership: $membership, membershipStartAt: $membershipStartAt, membershipEndAt: $membershipEndAt, token: $token, lastNotificationCheckDateTime: $lastNotificationCheckDateTime)';
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
        other.friendsCodeDone == friendsCodeDone &&
        other.insertedFriendsCode == insertedFriendsCode &&
        listEquals(other.friendsUidRecommededMe, friendsUidRecommededMe) &&
        listEquals(other.blockList, blockList) &&
        other.rewardedCnt == rewardedCnt &&
        other.exp == exp &&
        other.tier == tier &&
        listEquals(other.followers, followers) &&
        listEquals(other.followings, followings) &&
        other.intro == intro &&
        listEquals(other.favoriteStocks, favoriteStocks) &&
        listEquals(other.badges, badges) &&
        other.membership == membership &&
        other.membershipStartAt == membershipStartAt &&
        other.membershipEndAt == membershipEndAt &&
        other.token == token &&
        other.lastNotificationCheckDateTime == lastNotificationCheckDateTime;
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
        friendsCodeDone.hashCode ^
        insertedFriendsCode.hashCode ^
        friendsUidRecommededMe.hashCode ^
        blockList.hashCode ^
        rewardedCnt.hashCode ^
        exp.hashCode ^
        tier.hashCode ^
        followers.hashCode ^
        followings.hashCode ^
        intro.hashCode ^
        favoriteStocks.hashCode ^
        badges.hashCode ^
        membership.hashCode ^
        membershipStartAt.hashCode ^
        membershipEndAt.hashCode ^
        token.hashCode ^
        lastNotificationCheckDateTime;
  }
}

// 유저가 없을 때 초기 유저모델
UserModel newUserModel({
  required String uid,
  required String userName,
  String? email,
  String? phoneNumber,
}) {
  return UserModel(
      uid: uid,
      userName: userName,
      email: email,
      avatarImage: "avatar001",
      account: null,
      item: 10,
      friendsCode: null,
      isNameUpdated: false,
      rewardedCnt: 0,
      phoneNumber: phoneNumber,
      blockList: null,
      exp: 0,
      insertedFriendsCode: null,
      membership: false,
      membershipEndAt: null,
      membershipStartAt: null,
      token: null,
      lastNotificationCheckDateTime: null);
}
