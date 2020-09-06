import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageService {
  Future downloadImageURL(String storageAddress);
}

class StorageServiceFirebase extends StorageService {
  String downloadAddress;

  StorageReference _storageReference = FirebaseStorage.instance.ref();

  Future<String> downloadImageURL(String storageAddress) async {
    try {
      downloadAddress = await _storageReference
          .child(storageAddress.toString())
          .getDownloadURL();
    } catch (e) {
      print('downloadImagURL error : ${e.toString()}');
    }

    return downloadAddress;
  }
}
