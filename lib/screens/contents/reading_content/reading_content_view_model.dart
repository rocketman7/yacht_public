import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../locator.dart';

class ReadingContentViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  RxList<ReadingContentModel> readingContents = <ReadingContentModel>[].obs;
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  @override
  void onInit() async {
    await getReadingContents();
    // TODO: implement onInit
    super.onInit();
  }

  Future getReadingContents() async {
    readingContents(await _firestoreService.getReadingContents());
  }

  // Future<String> getImageUrlFromStorage(String imageUrl) async {
  //   return await _firebaseStorageService.downloadImageURL(imageUrl);
  // }

  Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
