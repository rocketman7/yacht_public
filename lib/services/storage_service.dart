import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

abstract class StorageService {
  Future downloadImageURL(String storageAddress);
}

class FirebaseStorageService extends StorageService {
  Reference _storageReference = FirebaseStorage.instance.ref();

  // 이미지 다운로드
  Future<String> downloadImageURL(String storageAddress) async {
    String downloadAddress = "";
    try {
      print('start to get download url: $downloadAddress, ${DateTime.now()}');

      downloadAddress = await _storageReference.child(storageAddress.toString()).getDownloadURL();
      print('url get: $downloadAddress, ${DateTime.now()}');
    } catch (e) {
      print('downloadImagURL error : ${e.toString()}');
      downloadAddress =
          "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatar_new_admin.png?alt=media&token=bab121d4-8dcf-4cb6-9748-b3650a6b9753";
    }
    return downloadAddress;
  }

  // 이미지 업로드
  Future uploadImages(List<String> filePaths) async {
    filePaths.forEach((element) async {
      String fileName = basename(element);
      await _storageReference.child('posts/$fileName').putFile(File(element)).whenComplete(() => print("upload done"));
    });
  }
}

// https://storage.googleapis.com/ggook-5fb08.appspot.com/
