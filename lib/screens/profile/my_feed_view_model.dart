import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/models/users/user_post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../locator.dart';

class MyFeedViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  RxList<UserPostModel> userPosts = <UserPostModel>[].obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    // await getMyFeed(userModelRx.value!.uid);
    userPosts.bindStream(getMyFeedStrem(userModelRx.value!.uid));
    super.onInit();
  }

  Future getMyFeed(String uid) async {
    userPosts.addAll(await _firestoreService.getMyFeed(uid));
  }

  Stream<List<UserPostModel>> getMyFeedStrem(String uid) {
    return _firestoreService.getMyFeedStream(uid);
  }

  Future<PostModel> getPost(String postId) async {
    return await _firestoreService.getThisPost(postId);
  }
}
