import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//*
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yachtOne/services/adManager_service.dart';
//*

import '../../services/firestore_service.dart';
import '../../locator.dart';

// 1:1 문의 리스트 및 답변
class OneOnOneAdminModel {
  final String uid;
  final String userName;
  final String? docId; // 혹시 생성이 안되어 있을 가능성?
  final String myDocId; // 이 놈 자체의 닥아이디
  final String category;
  final String content;
  final Timestamp dateTime;
  final String? answer;

  OneOnOneAdminModel({
    required this.uid,
    required this.userName,
    this.docId,
    required this.myDocId,
    required this.category,
    required this.content,
    required this.dateTime,
    this.answer,
  });

  OneOnOneAdminModel.fromData(Map<String, dynamic> data, String id)
      : uid = data['uid'],
        userName = data['userName'],
        docId = data['docId'] ?? '',
        myDocId = id,
        category = data['category'],
        content = data['content'],
        dateTime = data['dateTime'],
        answer = data['answer'] ?? '';
}

class AdminModeOneOnOneViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  late List<OneOnOneAdminModel> oneOnOneAdminModels = [];
  late List<OneOnOneAdminModel> visualOneOnOneAdminModels = [];
  bool visualAnswerDoneOneOnOnes = false;

  bool isAllOneOnOneLoaded = false;

  //*
  // static final _kAdIndex = 4;
  late NativeAd ad;
  bool isAdLoaded = false;
  //*
  //*
  // int _getDestinationItemIndex(int rawIndex) {
  //   if (rawIndex >= _kAdIndex && _isAdLoaded) {
  //     return rawIndex - 1;
  //   }
  //   return rawIndex;
  // }
  //*

  @override
  void onInit() async {
    await _firestoreService.firestoreService
        .collection('admin')
        .doc('userOneOnOne')
        .collection('userOneOnOne')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        oneOnOneAdminModels
            .add(OneOnOneAdminModel.fromData(element.data(), element.id));
      });
    });

    switchVisualAnswerDoneOneOnOnes();
    isAllOneOnOneLoaded = true;
    update();

    //*
    ad = NativeAd(
      // adUnitId: AdHelper.nativeAdUnitId,
      // adUnitId: 'ca-app-pub-3940256099942544/3986624511',
      // adUnitId: Platform.isAndroid
      //     ? 'ca-app-pub-3940256099942544/2247696110'
      //     : 'ca-app-pub-3940256099942544/3986624511',
      adUnitId: AdManager.nativeAdUnitId,
      // adUnitId: 'ca-app-pub-3726614606720353/2848820155',
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          // setState(() {
          // _isAdLoaded = true;
          print('ad ddddd');
          isAdLoaded = true;
          update();
          // });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          // ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    ad.load();
    //*

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    ad.dispose();
    super.onClose();
  }

  void switchVisualAnswerDoneOneOnOnes() {
    visualOneOnOneAdminModels = [];

    if (!visualAnswerDoneOneOnOnes) {
      for (int i = 0; i < oneOnOneAdminModels.length; i++) {
        if (oneOnOneAdminModels[i].answer == '') {
          visualOneOnOneAdminModels.add(oneOnOneAdminModels[i]);
        }
      }
    } else {
      for (int i = 0; i < oneOnOneAdminModels.length; i++) {
        visualOneOnOneAdminModels.add(oneOnOneAdminModels[i]);
      }
    }

    visualAnswerDoneOneOnOnes = !visualAnswerDoneOneOnOnes;

    update();
  }
}

class AdminModeOneOnOneDetailViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final OneOnOneAdminModel oneOnOneAdminModel;
  AdminModeOneOnOneDetailViewModel({required this.oneOnOneAdminModel});

  final TextEditingController contentController = TextEditingController();
  RxString content = ''.obs;
  RxBool questionVisible = false.obs;

  Future answerToQuestion(String answer) async {
    await _firestoreService.firestoreService
        .collection('admin')
        .doc('userOneOnOne')
        .collection('userOneOnOne')
        .doc(oneOnOneAdminModel.myDocId)
        .update({'answer': answer});

    await _firestoreService.firestoreService
        .collection('users')
        .doc(oneOnOneAdminModel.uid)
        .collection('userOneOnOne')
        .doc(oneOnOneAdminModel.docId!)
        .update({'answer': answer});
  }
}
