import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  String downloadAddress;

  StorageReference _storageReference =
      FirebaseStorage.instance.ref().child('123.jpg');

  Future downloadImage() async {
    downloadAddress = await _storageReference.getDownloadURL();
    return downloadAddress;
  }
}
