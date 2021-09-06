import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_controller.dart';

class ProfileChangeView extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar('프로필 수정'),
        body: ListView(children: [
          SizedBox(
            height: 20.w,
          ),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.bottomSheet(
                  ProfileAvatarChangeBottomSheetWidget(),
                  isScrollControlled: true,
                  enterBottomSheetDuration: Duration(milliseconds: 80),
                  exitBottomSheetDuration: Duration(milliseconds: 80),
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() => Container(
                        height: 110.w,
                        width: 110.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFC4C4C4)),
                        child: FutureBuilder<String>(
                          future: profileController.getImageUrlFromStorage(
                              'avatars/${userModelRx.value!.avatarImage}.png'),
                          builder: (_, snapshot) {
                            return snapshot.hasData
                                ? CachedNetworkImage(
                                    imageUrl: snapshot.data!,
                                  )
                                : Container(
                                    color: Colors.white,
                                  );
                          },
                        ),
                      )),
                  Container(
                    height: 36.w,
                    width: 36.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: buttonBackgroundPurple),
                    child: Center(
                      child: SizedBox(
                        height: 22.w,
                        width: 20.36.w,
                        child: Image.asset('assets/buttons/exclude_stroke.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1.w,
                  width: double.infinity,
                  color: yachtLineColor,
                ),
                SizedBox(
                  height: correctHeight(
                      20.w, 0.w, profileChangeTitleTextStyle.fontSize),
                ),
                Text('닉네임', style: profileChangeTitleTextStyle),
                SizedBox(
                  height: correctHeight(
                      8.w,
                      profileChangeTitleTextStyle.fontSize,
                      profileChangeContentTextStyle.fontSize),
                ),
                TextFormField(
                  controller: profileController.nameChangeController,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.w),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '${userModelRx.value!.userName}',
                    hintStyle: profileChangeContentTextStyle.copyWith(
                        color: yachtGrey),
                  ),
                ),
                SizedBox(
                  height: correctHeight(
                      20.w, profileChangeContentTextStyle.fontSize, 0.w),
                ),
                Container(
                  height: 1.w,
                  width: double.infinity,
                  color: yachtLineColor,
                ),
                SizedBox(
                  height: correctHeight(
                      20.w, 0.w, profileChangeTitleTextStyle.fontSize),
                ),
                Text('소개글', style: profileChangeTitleTextStyle),
                SizedBox(
                  height: correctHeight(
                      8.w,
                      profileChangeTitleTextStyle.fontSize,
                      profileChangeContentTextStyle.fontSize),
                ),
                TextFormField(
                  controller: profileController.introChangeController,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.w),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText:
                        '${userModelRx.value!.intro}'.replaceAll('\\n', '\n'),
                    hintStyle: profileChangeContentTextStyle.copyWith(
                        color: yachtGrey),
                  ),
                ),
                SizedBox(
                  height: correctHeight(
                      20.w, profileChangeContentTextStyle.fontSize, 0.w),
                ),
                Container(
                  height: 1.w,
                  width: double.infinity,
                  color: yachtLineColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          Row(
            children: [
              SizedBox(
                width: 14.w,
              ),
              Flexible(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    profileController.updateUserNameOrIntroMethod(
                        profileController.nameChangeController.text,
                        profileController.introChangeController.text);
                    Get.rawSnackbar(
                      messageText: Center(
                        child: Text(
                          "변경한 내용이 저장되었어요.",
                          style: snackBarStyle,
                        ),
                      ),
                      backgroundColor: white.withOpacity(.5),
                      barBlur: 8,
                      duration: const Duration(seconds: 1, milliseconds: 100),
                    );
                  },
                  child: Container(
                    height: 50.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70.0),
                        color: buttonBackgroundPurple),
                    child: Center(
                      child: Text(
                        '저장하기',
                        style: profileChangeButtonTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
            ],
          )
        ]));
  }
}

class ProfileAvatarChangeBottomSheetWidget extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 435.w + 8.w + 50.w + SizeConfig.safeAreaBottom,
      color: Colors.transparent,
      child: Container(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 14.w, right: 14.w),
                child: Container(
                  height: 435.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(
                        height: correctHeight(
                            24.w, 0.w, profileAvatarChangeTextStyle.fontSize),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 14.w,
                          ),
                          SizedBox(
                            height: 15.w,
                            width: 15.w,
                          ),
                          Spacer(),
                          Text(
                            '프로필 아바타 선택하기',
                            style: profileAvatarChangeTextStyle,
                          ),
                          Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Get.back();
                            },
                            child: SizedBox(
                              height: 15.w,
                              width: 15.w,
                              child: Image.asset('assets/buttons/close.png'),
                            ),
                          ),
                          SizedBox(
                            width: 14.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: correctHeight(20.w - 9.w,
                            profileAvatarChangeTextStyle.fontSize, 0.w),
                      ),
                      Container(
                        height: 351.w,
                        child: FutureBuilder<List<String>>(
                          future: profileController.getAvatarImagesURLs(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              profileController.avatarImagesURLs =
                                  snapshot.data!;

                              for (int i = 0; i < snapshot.data!.length; i++) {
                                if (snapshot.data![i] ==
                                    profileController.user.avatarImage)
                                  profileController.avatarIndex(i);
                              }
                              return AvatarImages(
                                avatarImagesURLs: snapshot.data!,
                              );
                            } else {
                              return Container(
                                color: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.w,
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 8.w,
            ),
            Padding(
                padding: EdgeInsets.only(left: 14.w, right: 14.w),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    profileController.updateAvatarImageMethod(
                        '${profileController.avatarImagesURLs[profileController.avatarIndex.value]}');
                    Get.back();
                    // Get.snackbar('', '');
                  },
                  child: Container(
                    height: 50.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70.0),
                        color: buttonBackgroundPurple),
                    child: Center(
                      child: Text(
                        '저장하기',
                        style: profileChangeButtonTextStyle,
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: SizeConfig.safeAreaBottom,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class AvatarImages extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();
  final List<String> avatarImagesURLs;

  AvatarImages({required this.avatarImagesURLs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (avatarImagesURLs.length - 1) ~/ 4 + 1, // 한 줄에 네 개씩 들어가므로~
      itemBuilder: (_, i) {
        return Row(
          children: [
            SizedBox(
              width: 5.5.w,
            ),
            Row(
              children: List.generate(4, (j) {
                if (i * 4 + j < avatarImagesURLs.length) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      profileController.avatarIndex(i * 4 + j);
                    },
                    child: Container(
                      height: 68.w + 26.w,
                      width: 68.w + 16.w,
                      // color: Colors.black,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 9.w,
                            left: 8.w,
                            child: Container(
                              height: 68.w,
                              width: 68.w,
                              child: FutureBuilder<String>(
                                future: profileController.getImageUrlFromStorage(
                                    'avatars/${avatarImagesURLs[i * 4 + j]}.png'),
                                builder: (_, snapshot) {
                                  return snapshot.hasData
                                      ? Image.network(
                                          '${snapshot.data!}',
                                        )
                                      : Container(
                                          color: Colors.white,
                                        );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                              top: -8.w + 9.w,
                              child: Obx(
                                () => Container(
                                    width: 68.w + 16.w,
                                    height: 68.w + 16.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 4.w,
                                            color: (i * 4 + j ==
                                                    profileController
                                                        .avatarIndex.value)
                                                ? yachtViolet
                                                : Colors.transparent))),
                              )),
                        ],
                      ),
                    ),
                  );
                } else
                  return Container();
              }),
            ),
            SizedBox(
              width: 5.5.w,
            ),
          ],
        );
      },
    );
  }
}