import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';

class CommunityViewModel extends GetxController {
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  RxList<XFile>? images = RxList<XFile>();
  List<String> filePaths = [];
  RxList<PostModel> posts = RxList<PostModel>();

  @override
  void onInit() async {
    // TODO: implement onInit
    await getPost();

    super.onInit();
  }

  Future getPost() async {
    posts(await _firestoreService.getPosts());
  }

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
      content: content,
      writerUid: userModelRx.value!.uid,
      writerUserName: userModelRx.value!.userName,
    );
  }

  // 게시글 올리기 버튼
  Future uploadPost(String content) async {
    // 이미지들 경로 이용하여 url 생성
    List<String> imageUrlList = [];
    filePaths.forEach((element) {
      String fileName = basename(element);
      imageUrlList.add('posts/$fileName');
    });

    // 포스트 모델로 변환
    PostModel _newPost = convertFeedtoPostModel(content).copyWith(imageUrlList: imageUrlList);
    print(_newPost);
    // 포스트 모델 업로드
    await _firestoreService.uploadNewPost(_newPost);

    // 이미지 있으면 스토리지에 업로드
    await _firebaseStorageService.uploadImages(filePaths);
    images!.clear();
    filePaths = [];
  }

  Future editPost(PostModel post, String content) async {
    PostModel _newPost = convertFeedtoPostModel(content);
    await _firestoreService.editMyPost(post.postId!, _newPost);
  }

  Future deletePost(PostModel post) async {
    // PostModel _newPost = convertFeedtoPostModel(content);
    await _firestoreService.deletePost(post.postId!);
  }
}
