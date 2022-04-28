import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/community/post_model.dart';

import '../../locator.dart';
import '../../models/community/comment_model.dart';
import '../../repositories/repository.dart';
import '../../services/firestore_service.dart';

class NewFeedWidgetController extends GetxController {
  NewFeedWidgetController(this.post);
  final PostModel post;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final Rxn<PostModel> postRx = Rxn<PostModel>();
  final RxBool isFocused = false.obs;
  final FocusNode commentFocusNode = FocusNode();
  @override
  void onInit() {
    // TODO: implement onInit
    commentFocusNode.addListener(() {
      isFocused(commentFocusNode.hasFocus);
      isFocused.refresh();
      print(isFocused.value);
    });
    postRx(post);
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print('closed');
    commentFocusNode.unfocus();
    super.onClose();
  }

  Future reloadThisPost(PostModel post) async {
    postRx(await _firestoreService.getThisPost(post.postId!));
    print('reloaded');
    // print(postRx.value)
  }

  Future toggleLikePost(PostModel post) async {
    await _firestoreService.toggleLikePost(
      post,
      userModelRx.value!.uid,
    );
  }

  Future toggleLikeComment(PostModel post, CommentModel comment) async {
    await _firestoreService.toggleLikeComment(
      post,
      comment,
      userModelRx.value!.uid,
    );
  }
}
