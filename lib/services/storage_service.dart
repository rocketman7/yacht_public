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
      downloadAddress = await _storageReference.child(storageAddress.toString()).getDownloadURL();
    } catch (e) {
      print('downloadImagURL error : ${e.toString()}');
      downloadAddress =
          "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F001.png?alt=media&token=3035b5da-debe-465d-b3be-57ce73c68ec7";
    }
    return downloadAddress;
  }

  // 이미지 업로드
  Future uploadImages(List<String> filePaths) async {
    filePaths.forEach((element) {
      String fileName = basename(element);
      _storageReference.child('posts/$fileName').putFile(File(element));
    });
  }
}
