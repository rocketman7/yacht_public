import 'package:cached_network_image/cached_network_image.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../services/storage_service.dart';
import '../services/customCacheManager_service.dart';

class MypageAvatarSelectViewModel extends FutureViewModel {
  // Services Setting
  final StorageService storageService = locator<StorageService>();
  final CustomCacheManagerService customCacheManagerService =
      locator<CustomCacheManagerService>();

  // 변수 Setting
  List<String> avatarImageAddress = [];
  int avatarNum;
  List<String> avatarImageURL = [];

  // 생성자에서 Storage에서 cache 이미지화할 것들을 저장해준다.
  // *나중에 앱의 어느 부분에서 cache 이미지를 쓸지 구체화되면 DB에서 관리하도록 코드수정 필요
  MypageAvatarSelectViewModel() {
    avatarImageAddress.add('avatarImage/avatar001.png');
    avatarImageAddress.add('avatarImage/avatar002.png');
    avatarImageAddress.add('avatarImage/avatar003.png');
    avatarImageAddress.add('avatarImage/avatar004.png');
    avatarImageAddress.add('avatarImage/avatar005.png');
    avatarImageAddress.add('avatarImage/avatar006.png');
    avatarImageAddress.add('avatarImage/avatar007.png');
    avatarImageAddress.add('avatarImage/avatar008.png');
    avatarImageAddress.add('avatarImage/avatar009.png');
    avatarImageAddress.add('avatarImage/avatar010.png');
    avatarImageAddress.add('avatarImage/avatar011.png');
    avatarImageAddress.add('avatarImage/avatar012.png');
    avatarImageAddress.add('avatarImage/avatar013.png');
    avatarImageAddress.add('avatarImage/avatar014.png');
    avatarImageAddress.add('avatarImage/avatar015.png');
    avatarImageAddress.add('avatarImage/avatar016.png');
    avatarImageAddress.add('avatarImage/avatar017.png');
    avatarImageAddress.add('avatarImage/avatar018.png');

    avatarNum = avatarImageAddress.length;
  }

  // method
  Future loadAvatarImageURL() async {
    for (int i = 0; i < avatarNum; i++) {
      avatarImageURL
          .add(await storageService.downloadImageURL(avatarImageAddress[i]));
    }

    return null;
  }

  String getAvatarImageURL(int index) {
    return avatarImageURL[index];
  }

  Widget paintChachedNetworkImage(int index, {double width, double height}) {
    return CachedNetworkImage(
      imageUrl: getAvatarImageURL(index),
      width: width == null ? 100 : width,
      height: height == null ? 100 : height,
      cacheManager: customCacheManagerService,
    );
  }

  void emptyCacheAll() {
    customCacheManagerService.emptyCacheAll();
  }

  @override
  Future futureToRun() => loadAvatarImageURL();
}
