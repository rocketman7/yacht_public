import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

class DetailPostViewModel extends GetxController {
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final PostModel post;

  final RxList<CommentModel> comments = RxList<CommentModel>();

  DetailPostViewModel(this.post);
  @override
  void onInit() async {
    await getComments(post);
    // TODO: implement onInit
    super.onInit();
  }

  final RxString replyToUserName = "".obs; // 대댓글이 향하는 댓글 쓴 사람 유저네임
  final RxString replyToUserUid = "".obs; // 대댓글이 향하는 댓글 쓴 사람 UID
  final RxString replyToCommentId = "".obs; // 대댓글이 향하는 댓글 코멘트 ID
  final RxString hintText = "답글을 달아주세요".obs;

  // 코멘트 받아오기
  Future getComments(PostModel post) async {
    comments(await _firestoreService.getComments(post));
  }

  // 코멘트 올리기
  Future uploadComment(PostModel post, String content) async {
    late CommentModel newComment;
    if (replyToUserName.value.length > 0) {
      newComment = convertCommentToCommmentModel(post.postId!, content, true, replyToUserName: replyToUserName.value, replyToUserUid: replyToUserUid.value, replyToCommentId: replyToCommentId.value);
    } else {
      newComment = convertCommentToCommmentModel(post.postId!, content, false);
    }

    print(newComment);
    _firestoreService.uploadNewComment(newComment);
  }

  // 댓글 내용으로 Comment Model 만들기
  CommentModel convertCommentToCommmentModel(String commentToPostId, String content, bool isReply, {String? replyToUserName, String? replyToUserUid, String? replyToCommentId}) {
    return CommentModel(
      commentToPostId: commentToPostId,
      content: content,
      isReply: isReply,
      replyToUserName: replyToUserName,
      replyToUserUid: replyToUserUid,
      replyToCommentId: replyToCommentId,
      writerUid: userModelRx.value!.uid,
      writerUserName: userModelRx.value!.userName,
    );
  }
}
