import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  String downloadAddress;

  StorageReference _storageReference = FirebaseStorage.instance.ref();

  Future downloadImage() async {
    downloadAddress = await _storageReference
        .child('avatarImage/avatar001.png')
        .getDownloadURL();
    return downloadAddress;
  }
}
