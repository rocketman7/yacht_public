import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/screens/community/feed_widget.dart';
import 'package:yachtOne/screens/community/notice_widget.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'community_view_model.dart';

class CommunityView extends GetView<CommunityViewModel> {
  // CommunityViewModel communityViewModel = Get.put(CommunityViewModel());
  // ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final CommunityViewModel _communityViewModel = Get.put(CommunityViewModel());
  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1200));
    await _communityViewModel.reloadPost();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   // monitor network fetch
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   print('loading');

  //   _refreshController.loadComplete();
  // }
  RxString footer = "start".obs;
  @override
  Widget build(BuildContext context) {
    // _scrollController = ScrollController(initialScrollOffset: 0);
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   print(_scrollController);

    //   _scrollController.addListener(() {
    //     // offset obs 값에 scroll controller offset 넣어주기
    //     // _scrollController.offset < 0 ? offset(0) : offset(_scrollController.offset);
    //     print(_scrollController.offset);
    //   });
    // });

    print("commuity view building");
    return Scaffold(
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Get.bottomSheet(
      //       WritingNewPost(
      //         // contentFormKey: _contentFormKey,
      //         // contentController: _contentController,
      //         communityViewModel: _communityViewModel,
      //       ),
      //       isScrollControlled: true,
      //       ignoreSafeArea: false, // add this
      //     );
      //   },
      //   child: Container(
      //     decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      //       BoxShadow(
      //         color: yachtShadow,
      //         blurRadius: 8.w,
      //         spreadRadius: 1.w,
      //       )
      //     ]),
      //     height: 54,
      //     width: 54,
      //     child: Image.asset('assets/icons/writing.png'),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: primaryAppBar("커뮤니티"),
      body: Stack(clipBehavior: Clip.none, children: [
        Padding(
          padding: primaryHorizontalPadding,
          child: RefreshConfiguration(
            enableScrollWhenRefreshCompleted: true,
            child: SmartRefresher(
              header: CustomHeader(
                  builder: (_, status) {
                    return Container(
                      height: 20,
                      color: Colors.blue,
                      child: Center(child: Text(footer.value)),
                    );
                  },
                  height: 100,
                  onModeChange: (mode) {
                    if (mode == RefreshStatus.idle) {
                      footer("idle");
                    } else if (mode == RefreshStatus.canRefresh) {
                      footer("canRefresh");
                    } else if (mode == RefreshStatus.refreshing) {
                      footer("refreshing");
                    } else if (mode == RefreshStatus.completed) {
                      footer("completed");
                    }
                  }),
              // physics: AlwaysScrollableScrollPhysics(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              // onLoading: _onLoading,
              child: ListView(
                clipBehavior: Clip.none,
                controller: _communityViewModel.scrollController,
                // physics: ScrollPhysics(),

                children: [
                  // 전문글만, 팔로워만 고르기
                  // Container(
                  //   height: 48.w,
                  //   // color: Colors.blueGrey,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Center(
                  //             child: Text(
                  //           "프로 모아보기",
                  //           style: subheadingStyle.copyWith(color: primaryButtonBackground),
                  //         )),
                  //       ),
                  //       Container(height: 32.w, width: 1.w, color: yachtLineColor),
                  //       Expanded(
                  //           child: Center(
                  //               child: Text(
                  //         "팔로워 모아보기",
                  //         style: subheadingStyle.copyWith(color: primaryButtonBackground),
                  //       )))
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 14.w),

                  Obx(
                    () => (_communityViewModel.posts.length == 0)
                        ? Container(
                            child: Text("게시글이 없습니다"),
                          )

                        // print(snapshot.data);
                        // 임시로 0 index만. 위젯 블럭 제작 이후에는 Lazy List로
                        :
                        // PaginateFirestore(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     onLoaded: (paginationLoaded) {
                        //       print(paginationLoaded);
                        //       print('newpageloaded');
                        //     },
                        //     shrinkWrap: true,
                        //     itemsPerPage: 4,
                        //     query: FirebaseFirestore.instance
                        //         .collection('posts')
                        //         .orderBy('writtenDateTime', descending: true),
                        //     itemBuilderType: PaginateBuilderType.listView,
                        //     itemBuilder: (index, context, DocumentSnapshot snapshot) {
                        //       final data = snapshot.data() as Map<String, dynamic>;
                        //       final postData = PostModel.fromMap(data);
                        //       // return Container(
                        //       //   height: 200,
                        //       //   color: index % 2 == 0 ? Colors.red : Colors.blue,
                        //       //   child: Text(postData.content),
                        //       // );
                        //       return Column(
                        //         children: [
                        //           FeedWidget(communityViewModel: _communityViewModel, post: postData),
                        //           SizedBox(
                        //             height: 12.w,
                        //           )
                        //         ],
                        //       );
                        //     },
                        //   )
                        ListView.builder(
                            // clipBehavior: Clip.none,
                            // controller: _scrollController,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _communityViewModel.posts.length,
                            itemBuilder: (_, index) {
                              return Column(
                                children: [
                                  _communityViewModel.posts[index].isNotice
                                      ? NoticeWidget(
                                          communityViewModel: _communityViewModel,
                                          post: _communityViewModel.posts[index])
                                      : FeedWidget(
                                          communityViewModel: _communityViewModel,
                                          post: _communityViewModel.posts[index]),
                                  SizedBox(
                                    height: 12.w,
                                  )
                                ],
                              );
                            }),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: SizeConfig.safeAreaBottom + 74.w,
          right: 14.w,
          child: InkWell(
            onTap: () {
              Get.bottomSheet(
                WritingNewPost(
                  // contentFormKey: _contentFormKey,
                  // contentController: _contentController,
                  communityViewModel: _communityViewModel,
                ),
                isScrollControlled: true,
                ignoreSafeArea: false, // add this
              );
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: yachtShadow,
                  offset: Offset(1.w, 1.w),
                  blurRadius: 3.w,
                  spreadRadius: 1.w,
                )
              ]),
              height: 54,
              width: 54,
              child: Image.asset(
                'assets/icons/writing.png',
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class WritingNewPost extends StatelessWidget {
  WritingNewPost({
    Key? key,
    required CommunityViewModel communityViewModel,
  })  : _communityViewModel = communityViewModel,
        super(key: key);

  final GlobalKey<FormState> _contentFormKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final CommunityViewModel _communityViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              color: primaryBackgroundColor,
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              height: 60.w,
              padding: primaryHorizontalPadding,
              color: primaryBackgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset('assets/icons/exit.png', width: 14.w, height: 14.w, color: yachtBlack)),
                    ),
                  ),
                  Text(
                    "글쓰기",
                    style: appBarTitle,
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () async {
                            if (_contentFormKey.currentState!.validate()) {
                              print("OKAY");
                              print(_contentController.value.text);
                              await _communityViewModel.uploadPost(_contentController.value.text);
                              await _communityViewModel.reloadPost();
                              Get.back();
                              yachtSnackBar("성공적으로 업로드 되었어요.");
                            }
                          },
                          child: simpleTextContainerButton("올리기")),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 52.w,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: primaryBackgroundColor,
                  border: Border(
                    bottom: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                    top: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                  )),
              child: Center(child: Text("피드", style: sectionTitle)),
            ),
            Form(
              key: _contentFormKey,
              child: Expanded(
                child: Container(
                    color: white,
                    child: Column(
                      children: [
                        Expanded(
                          child: TextFormField(
                            // autofocus: true,
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
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                hintText: '투자에 관한 생각을 자유롭게 나눠주세요.',
                                hintStyle: feedContent.copyWith(color: feedContent.color!.withOpacity(.5))),
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
                                top: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                              )),
                              height: 128.w,
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
                                            borderRadius: BorderRadius.circular(8.w),
                                            child: Image.file(
                                              File(_communityViewModel.images![index].path),
                                              height: 100.w,
                                              width: 100.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 10.w,
                                            right: 10.w,
                                            child: InkWell(
                                                onTap: () => _communityViewModel.images!.removeAt(index),
                                                child: Container(
                                                  height: 20.w,
                                                  width: 20.w,
                                                  // color: Colors.red,
                                                  child: Image.asset('assets/icons/deletePhoto.png'),
                                                )),
                                          ),
                                        ]),
                                      ],
                                    );
                                  }),
                            );
                          }
                        }),
                        Container(
                          height: 50.w,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: primaryBackgroundColor,
                              border: Border(
                                bottom: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                                top: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                              )),
                          // color: Colors.yellow,
                          child: GestureDetector(
                            onTap: () async {
                              await _communityViewModel.getImageFromDevice();
                              print('image length: ${_communityViewModel.images!.length}');
                            },
                            child: Padding(
                              padding: primaryHorizontalPadding,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/upload_photo.svg',
                                    color: yachtBlack,
                                    height: 26.w,
                                    width: 26.w,
                                  ),
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
        ),
      ),
    );
  }
}
