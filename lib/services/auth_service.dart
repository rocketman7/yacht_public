import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../locator.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future registerWithEmail() async {}
}
