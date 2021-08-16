import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

class DetailPostViewModel extends GetxController {
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final PostModel post;

  DetailPostViewModel(this.post);
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  final RxString mentionTo = "".obs;
  final RxString hintText = "답글을 달아주세요".obs;

  // 코멘트 받아오기
  Future<List<CommentModel>> getComments(PostModel post) async {
    return await _firestoreService.getComments(post);
  }

  // 코멘트 올리기
  Future uploadComment(PostModel post, String content) async {
    CommentModel newComment =
        convertCommentToCommmentModel(post.postId!, content, false);
    print(newComment);
    _firestoreService.uploadNewComment(newComment);
  }

  // 댓글 내용으로 Comment Model 만들기
  CommentModel convertCommentToCommmentModel(
      String commentToPostId, String content, bool isReply) {
    return CommentModel(
      commentToPostId: commentToPostId,
      content: content,
      isReply: isReply,
      writerUid: userModelRx.value!.uid,
      writerUserName: userModelRx.value!.userName,
    );
  }
}
