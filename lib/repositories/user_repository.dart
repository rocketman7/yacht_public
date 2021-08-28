import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../locator.dart';

class UserRepository extends Repository<UserModel> {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  // Future<UserModel> getUserData(String uid) async {
  //   if (userModel == null) {
  //     userModel = await _firestoreService.getUserModel(uid);
  //     print('getting user: $userModel');
  //     return userModel!;
  //   } else {
  //     return userModel!;
  //   }
  // }

  Stream<UserModel> getUserStream(String uid) {
    return _firestoreService.getUserStream(uid);
  }

  Stream<List<UserQuestModel>> getUserQuestStream(String uid) {
    // print('user quest: ${_firestoreService.getUserQuestStream(uid)}');
    return _firestoreService.getUserQuestStream(uid);
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
