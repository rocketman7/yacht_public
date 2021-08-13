import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/screens/community/feed_widget.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'community_view_model.dart';

class CommunityView extends StatelessWidget {
  // CommunityViewModel communityViewModel = Get.put(CommunityViewModel());
  final GlobalKey<FormState> _contentFormKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  final CommunityViewModel _communityViewModel = Get.find<CommunityViewModel>();
  @override
  Widget build(BuildContext context) {
    print("commuity view building");
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.bottomSheet(
              WritingNewPost(
                contentFormKey: _contentFormKey,
                contentController: _contentController,
                communityViewModel: _communityViewModel,
              ),
              isScrollControlled: true,
              ignoreSafeArea: false, // add this
              enterBottomSheetDuration: Duration(seconds: 3));
        },
        child: Container(
          height: 54,
          width: 54,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(0xFFDCE9F4)),
          child: Center(child: Text("글쓰기")),
        ),
      ),
      appBar: primaryAppBar("커뮤니티"),
      body: SingleChildScrollView(
        child: Padding(
          padding: primaryHorizontalPadding,
          child: Column(
            children: [
              // 전문글만, 팔로워만 고르기
              Container(
                color: Colors.blueGrey,
                height: 32.w,
              ),
              FutureBuilder<List<PostModel>>(
                  future: _communityViewModel.getPost(),
                  builder: (BuildContext context, snapshot) {
                    print("Future Builder run ");
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      if (snapshot.data!.length == 0) {
                        return Container(
                          child: Text("게시글이 없습니다"),
                        );
                      }
                      // print(snapshot.data);
                      // 임시로 0 index만. 위젯 블럭 제작 이후에는 Lazy List로
                      List<PostModel> post = snapshot.data!;
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: post.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                FeedWidget(
                                    communityViewModel: _communityViewModel,
                                    post: post[index]),
                                SizedBox(
                                  height: 12.w,
                                )
                              ],
                            );
                          });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class WritingNewPost extends StatelessWidget {
  const WritingNewPost({
    Key? key,
    required GlobalKey<FormState> contentFormKey,
    required TextEditingController contentController,
    required CommunityViewModel communityViewModel,
  })  : _contentFormKey = contentFormKey,
        _contentController = contentController,
        _communityViewModel = communityViewModel,
        super(key: key);

  final GlobalKey<FormState> _contentFormKey;
  final TextEditingController _contentController;
  final CommunityViewModel _communityViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: primaryBackgroundColor,
          height: MediaQuery.of(context).padding.top,
        ),
        Container(
          height: 60,
          color: primaryBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text("취소")),
              Text(
                "글쓰기",
                style: homeHeaderAfterName,
              ),
              Text("    ")
            ],
          ),
        ),
        Container(
          height: 52.w,
          width: double.infinity,
          decoration: BoxDecoration(
              color: primaryBackgroundColor,
              border: Border(
                bottom: BorderSide(
                    color: Colors.black.withOpacity(.05), width: 1.w),
                top: BorderSide(
                    color: Colors.black.withOpacity(.05), width: 1.w),
              )),
          child: Center(child: Text("피드", style: questTitleTextStyle)),
        ),
        Form(
          key: _contentFormKey,
          child: Expanded(
            child: Container(
                color: primaryBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        controller: _contentController,
                        validator: (value) {
                          if (value!.length < 4) {
                            return '4자 이상 글을 올려주세요.';
                          } else {
                            return null;
                          }
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(14.w),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: '글을 입력해주세요.',
                            hintStyle: feedContent),
                      ),
                    ),
                    // 업로드한 이미지 미리보기하는 부분
                    Obx(() {
                      if (_communityViewModel.images!.length == 0) {
                        return Container();
                      } else {
                        print(_communityViewModel.images![0]);
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(
                                color: Colors.black.withOpacity(.05),
                                width: 1.w),
                          )),
                          height: 100.w,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _communityViewModel.images!.length,
                              itemBuilder: (_, index) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 14.w,
                                    ),
                                    Stack(children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.w),
                                        child: Image.file(
                                          File(_communityViewModel
                                              .images![index].path),
                                          height: 100.w,
                                          width: 100.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 10.w,
                                        right: 10.w,
                                        child: InkWell(
                                          onTap: () => _communityViewModel
                                              .images!
                                              .removeAt(index),
                                          child: Container(
                                              height: 20.w,
                                              width: 20.w,
                                              // color: Colors.red,
                                              child: Text(
                                                "X",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                    ]),
                                  ],
                                );
                              }),
                        );
                      }
                    }),
                    Container(
                      height: 40.w,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryBackgroundColor,
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.black.withOpacity(.05),
                                width: 1.w),
                            top: BorderSide(
                                color: Colors.black.withOpacity(.05),
                                width: 1.w),
                          )),
                      // color: Colors.yellow,
                      child: GestureDetector(
                        onTap: () async {
                          await _communityViewModel.getImageFromDevice();
                          print(
                              'image length: ${_communityViewModel.images!.length}');
                        },
                        child: Padding(
                          padding: primaryHorizontalPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/upload_photo.svg',
                                height: 18.w,
                                width: 18.w,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (_contentFormKey.currentState!
                                      .validate()) {
                                    print("OKAY");
                                    await _communityViewModel.uploadPost(
                                        _contentController.value.text);

                                    Get.back();
                                  }

                                  // PostModel newPost =
                                },
                                child: Text(
                                  "올리기",
                                  style: homeModuleTitleTextStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
