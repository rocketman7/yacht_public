import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/adManager_service.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../locator.dart';

class CommunityViewModel extends GetxController {
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  RxList<XFile>? images = RxList<XFile>();
  List<String> filePaths = [];
  RxList<PostModel> posts = RxList<PostModel>();
  RxList<PostModel> recentNotice = <PostModel>[].obs;

  ScrollController scrollController = ScrollController();
  int postAtOnceLimit = 20;
  RxBool isGettingPosts = false.obs;
  RxBool hasNextPosts = true.obs;

  RxBool isUploadingNewPost = false.obs;
  RxDouble offset = 0.0.obs;
  RefreshController refreshController = RefreshController();

  final RxString replyToUserName = "".obs; // 대댓글이 향하는 댓글 쓴 사람 유저네임
  final RxString replyToUserUid = "".obs; // 대댓글이 향하는 댓글 쓴 사람 UID
  final RxString replyToCommentId = "".obs; // 대댓글이 향하는 댓글 코멘트 ID
  final RxString hintText = "답글을 달아주세요".obs;
  double screenHeight = ScreenUtil().screenHeight;
  RxBool isAdLoaded = false.obs;
  @override
  void onInit() async {
    refreshController = RefreshController(initialRefreshStatus: RefreshStatus.idle);
    scrollController = ScrollController(initialScrollOffset: 0);
    print('community view model oninit');
    // TODO: implement onInit
    await getNotice();
    await getPost();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // scrollController.animateTo(scrollController.position.maxScrollExtent,
      //     duration: Duration(seconds: 2), curve: Curves.easeIn);

      scrollController.addListener(() {
        // print(scrollController.offset);
        print('max: ${scrollController.position.maxScrollExtent}');
        // print(scrollController.position);
        scrollController.offset < 0 ? offset(0) : offset(scrollController.offset);
        if ((scrollController.offset > scrollController.position.maxScrollExtent - (screenHeight * .5)) &&
            hasNextPosts.value) {
          if (!isGettingPosts.value) {
            print('maxextnt: ${scrollController.position.maxScrollExtent}');
            print(scrollController.offset);
            getPost();
          }
        }
      });
    });

    // _createNativeAd();

    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  // _createNativeAd() {
  //   NativeAd
  // }

  Future getNotice() async {
    var notice = await _firestoreService.getNotice();
    if (notice != null) recentNotice.addAll([await _firestoreService.getNotice()]);
  }

  void onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1200));
    await reloadPost();
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
    // await Future.delayed(Duration(milliseconds: 1200));
  }

  Future reloadPost() async {
    print('reload started');
    if (isGettingPosts.value) return;
    isGettingPosts(true);
    hasNextPosts(true);

    recentNotice.value = [];
    await getNotice();

    List<PostModel> newPosts = [];
    newPosts.addAll(await _firestoreService.getPosts(
      postAtOnceLimit,
    ));

    // block list 포함된 거 삭제
    if (userModelRx.value!.blockList != null) {
      newPosts.removeWhere(
        (element) => userModelRx.value!.blockList!.contains(element.writerUid),
      );
    }

    posts.assignAll(newPosts);

    isGettingPosts(false);

    // update();
  }

  // 코멘트 받아오기
  Future<List<CommentModel>> getComments(PostModel post) async {
    return await _firestoreService.getComments(post);
  }

  // 코멘트 받아오기 스트림
  Stream<List<CommentModel>> getCommentStream(PostModel post) {
    return _firestoreService.getCommentStream(post);
  }

  // 코멘트 올리기
  Future uploadComment(PostModel post, String content) async {
    late CommentModel newComment;
    if (replyToUserName.value.length > 0) {
      newComment = convertCommentToCommmentModel(post.postId!, content, true,
          replyToUserName: replyToUserName.value,
          replyToUserUid: replyToUserUid.value,
          replyToCommentId: replyToCommentId.value);
    } else {
      newComment = convertCommentToCommmentModel(post.postId!, content, false);
    }

    // print(newComment);
    _firestoreService.uploadNewComment(newComment);
  }

  // 댓글 내용으로 Comment Model 만들기
  CommentModel convertCommentToCommmentModel(String commentToPostId, String content, bool isReply,
      {String? replyToUserName, String? replyToUserUid, String? replyToCommentId}) {
    return CommentModel(
      commentToPostId: commentToPostId,
      content: content,
      isReply: isReply,
      replyToUserName: replyToUserName,
      replyToUserUid: replyToUserUid,
      replyToCommentId: replyToCommentId,
      writerUid: userModelRx.value!.uid,
      writerUserName: userModelRx.value!.userName,
      writerAvatarUrl: userModelRx.value!.avatarImage,
      writerExp: userModelRx.value!.exp,
    );
  }

  // 코멘트 삭제
  Future deleteComment(CommentModel comment) async {
    await _firestoreService.deleteComment(comment.commentToPostId, comment.commentId!);
  }

  Future getPost() async {
    print('posts posts0: ${posts.length}');
    if (isGettingPosts.value) return;
    isGettingPosts(true);
    List<PostModel> newPosts = [];
    print('newPosts posts0: ${newPosts.length}');
    print('all posts0: ${posts.length}');
    newPosts.addAll(await _firestoreService.getPosts(postAtOnceLimit,
        startAfterThisPostId: posts.length > 0 ? posts.last.writtenDateTime : null));
    print('newPosts posts1: ${newPosts.length}');
    print('all posts1: ${posts.length}');
    // block list 포함된 거 삭제
    if (userModelRx.value!.blockList != null) {
      newPosts.removeWhere(
        (element) => userModelRx.value!.blockList!.contains(element.writerUid),
      );
    }
    print('all posts2: ${posts.length}');
    posts.addAll(newPosts);
    // posts.sort((b, a) => a.isNotice.toString().compareTo(b.isNotice.toString()));
    if (newPosts.length < postAtOnceLimit) {
      // print('no more posts');
      hasNextPosts(false);
    }
    print('newPosts posts3: ${newPosts.length}');
    print('all posts3: ${posts.length}');
    isGettingPosts(false);
    update();
  }

  // Future getMorePosts() async {
  //   await _firestoreService.getPosts(15);
  // }

  // 기기에서 사진 고르기. 여러개 고를 수 있음.
  // TODO: max length 처리는 필요
  Future getImageFromDevice() async {
    // 유저한테 권한 요청하고 사진 픽
    // 사진은 XFile 형태로 저장된다 => RxList<XFile> images에 저장
    final result = await _imagePicker.pickMultiImage(maxHeight: 1024, maxWidth: 1024);
    if (result != null) {
      //Most people just handle here. So it never returns anything upon cancel (iOS)
      images = images! + result.map((e) => e);
    } else {
      //User canceled the picker. You need do something here, or just add return
      return;
    }
    // XFile 형태로 되어있는 이미지들의 filePaths를 찾아서 List<String> filePaths에 넣어준다.
    // 이 path들은 업로드할 때 파일 위치를 찾아 storage에 저장할 때 쓰인다.
    images!.forEach((element) {
      filePaths.add(element.path);
    });
    print('after adding img: $images');
  }

  // 피드 내용으로 Post Model 만들기
  PostModel convertFeedtoPostModel(String content) {
    // Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
    // String docUid;
    // print(userModelRx.value!.uid);
    // print(userModelRx.value!.userName);
    //   docUid = address.postsSeasonCollection().doc().id;
    return PostModel(
        isPro: false,
        isNotice: false,
        content: content,
        writerUid: userModelRx.value!.uid,
        writerUserName: userModelRx.value!.userName,
        writerExp: userModelRx.value!.exp,
        writerAvatarUrl: userModelRx.value!.avatarImage);
  }

  // 게시글 올리기 버튼
  Future uploadPost(String content) async {
    List<String> imageUrlList = [];
    if (filePaths.length > 0) {
      // 이미지들 경로 이용하여 url 생성

      filePaths.forEach((element) {
        String fileName = basename(element);
        imageUrlList.add('posts/$fileName');
      });

      // 이미지 있으면 스토리지에 업로드
      await _firebaseStorageService.uploadImages(filePaths).then((value) async {
        images!.clear();
        filePaths = [];
        if (value == 'success') {
          // 포스트 모델로 변환
          PostModel _newPost = convertFeedtoPostModel(content).copyWith(imageUrlList: imageUrlList);
          // print(_newPost);
          // 포스트 모델 업로드
          await _firestoreService.uploadNewPost(_newPost);
        }
      });
    } else {
      // 포스트 모델로 변환
      PostModel _newPost = convertFeedtoPostModel(content).copyWith(imageUrlList: imageUrlList);
      // print(_newPost);
      // 포스트 모델 업로드
      await _firestoreService.uploadNewPost(_newPost);
    }
  }

  Future editPost(PostModel post, String content) async {
    PostModel _newPost = convertFeedtoPostModel(content);
    await _firestoreService.editMyPost(post.postId!, _newPost);
  }

  Future deletePost(PostModel post) async {
    // PostModel _newPost = convertFeedtoPostModel(content);
    await _firestoreService.deletePost(post.postId!);
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }

  Future toggleLikePost(PostModel post) async {
    await _firestoreService.toggleLikePost(post, userModelRx.value!.uid);
  }

  Future blockThisUser(String uidToBlock) async {
    await _firestoreService.blockThisUser(uidToBlock);
  }

  Future reportThisUser(PostModel post) async {
    await _firestoreService.reportThisUser(post);
  }
}
