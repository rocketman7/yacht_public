import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../locator.dart';

class UserRepository extends Repository<UserModel> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  @override
  Future<UserModel> getUserData(String uid) async {
    if (userModel == null) {
      userModel = await _firestoreService.getUserModel(uid);
      return userModel!;
    } else {
      return userModel!;
    }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
