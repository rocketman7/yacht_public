import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageService {
  Future downloadImageURL(String storageAddress);
}

class FirebaseStorageService extends StorageService {
  late String downloadAddress;

  Reference _storageReference = FirebaseStorage.instance.ref();

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
