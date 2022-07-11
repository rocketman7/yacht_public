import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/feed_widget.dart';
import 'package:yachtOne/screens/community/notice_widget.dart';
import 'package:yachtOne/services/adManager_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import '../../locator.dart';
import 'community_view_model.dart';
import 'new_feed_widget.dart';

class CommunityView extends GetView<CommunityViewModel> {
  // CommunityViewModel communityViewModel = Get.put(CommunityViewModel());
  // CommunityViewModel communityViewModel = Get.find<CommunityViewModel>();
  // ScrollController _scrollController = ScrollController();

  final CommunityViewModel _communityViewModel = Get.put(CommunityViewModel());
  ScrollController scrollController = ScrollController();
  // void _onLoading() async {
  //   // monitor network fetch
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   print('loading');

  //   _refreshController.loadComplete();
  // }
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
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   scrollController.addListener(() {
    //     // print(scrollController.offset);
    //     print('max: ${scrollController.position.maxScrollExtent}');
    //     print('current: ${scrollController.offset}');
    //     if (scrollController.offset >
    //         scrollController.position.maxScrollExtent - (_communityViewModel.screenHeight * .5)) {
    //       // print('maxextnt: ${scrollController.position.maxScrollExtent}');
    //       // print(scrollController.offset);
    //       print('almost end');
    //     }
    //   });
    // });

    print("commuity view building");
    return Stack(clipBehavior: Clip.none, children: [
      RefreshConfiguration(
        enableScrollWhenRefreshCompleted: true,
        headerTriggerDistance: 80.w,
        child: SmartRefresher(
          enablePullDown: true,
          header: YachtCustomHeader(),
          controller: _communityViewModel.refreshController,
          onRefresh: _communityViewModel.onRefresh,
          child: CustomScrollView(
            // clipBehavior: Clip.none,
            controller: _communityViewModel.scrollController,
            // physics: ScrollPhysics(),
            slivers: [
              Obx(
                () => SliverPersistentHeader(
                  floating: false,
                  pinned: true,
                  // 홈 뷰 앱바 구현
                  delegate: YachtPrimaryAppBarDelegate(
                      offset: _communityViewModel.offset.value,
                      tabTitle: "커뮤니티",
                      buttonWidget: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Get.bottomSheet(
                            WritingNewPost(
                              // contentFormKey: _contentFormKey,
                              // contentController: _contentController,
                              communityViewModel: _communityViewModel,
                            ),
                            backgroundColor: yachtBlack,
                            isScrollControlled: true,
                            ignoreSafeArea: false, // add this
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            4.w,
                          ),
                          decoration: BoxDecoration(
                              color: yachtViolet,
                              borderRadius: BorderRadius.circular(
                                10.w,
                              )),
                          child: SvgPicture.asset(
                            'assets/icons/writing_plus_violet.svg',
                            height: 28.w,
                            width: 28.w,
                          ),
                        ),
                      ),
                      buttonPosition: 'right-center'),
                ),
              ),
              Obx(
                () => SliverList(
                    // delegate: SliverChildListDelegate([
                    //   SizedBox(height: 30.w),
                    //   Obx(
                    //     ()=>
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Obx(
                      () => Column(
                        children: [
                          index == 0
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                    _communityViewModel.recentNotice.length > 0
                                        ? Column(
                                            children: [
                                              NoticeWidget(
                                                  communityViewModel: _communityViewModel,
                                                  post: _communityViewModel.recentNotice[0]),
                                              SizedBox(
                                                height: 12.w,
                                              )
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                          // ((index == 1) && Platform.isAndroid) ? CommunityAd() : SizedBox.shrink(),

                          // FeedWidget(communityViewModel: _communityViewModel,
                          //     post: _communityViewModel.posts[index]),
                          NewFeedWidget(
                            communityViewModel: _communityViewModel,
                            post: _communityViewModel.posts[index],
                          ),
                          Divider(
                            color: yachtMidGrey,
                            height: 14.w,
                            thickness: .3,
                          ),
                          // SizedBox(
                          //   height: 14.w,
                          // )
                        ],
                      ),
                    );
                  },
                  childCount: _communityViewModel.posts.length,
                )),
                // () => ListView.builder(
                //     padding: EdgeInsets.zero,
                //     // clipBehavior: Clip.none,
                //     // controller: _scrollController,
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: _communityViewModel.posts.length,
                //     itemBuilder: (_, index) {
                //       return Column(
                //         children: [
                //           index == 0
                //               ? Column(
                //                   children: [
                //                     // SizedBox(
                //                     //   height: 20.w,
                //                     // ),
                //                     _communityViewModel.recentNotice.length > 0
                //                         ? Column(
                //                             children: [
                //                               NoticeWidget(
                //                                   communityViewModel: _communityViewModel,
                //                                   post: _communityViewModel.recentNotice[0]),
                //                               SizedBox(
                //                                 height: 12.w,
                //                               )
                //                             ],
                //                           )
                //                         : Container(),
                //                   ],
                //                 )
                //               : Container(),
                //           // ((index == 1) && Platform.isAndroid) ? CommunityAd() : SizedBox.shrink(),
                //           // FeedWidget(communityViewModel: _communityViewModel,
                //           //     post: _communityViewModel.posts[index]),
                //           NewFeedWidget(
                //             communityViewModel: _communityViewModel,
                //             post: _communityViewModel.posts[index],
                //           ),
                //           Divider(),
                //           SizedBox(
                //             height: 14.w,
                //           )
                //         ],
                //       );
                //     }),
                //   ),
                // ]),
              ),
            ],
          ),
        ),
      ),
      // Positioned(
      //   bottom: SizeConfig.safeAreaBottom + 74.w,
      //   right: 14.w,
      //   child: InkWell(
      //     onTap: () {
      //       Get.bottomSheet(
      //         WritingNewPost(
      //           // contentFormKey: _contentFormKey,
      //           // contentController: _contentController,
      //           communityViewModel: _communityViewModel,
      //         ),
      //         isScrollControlled: true,
      //         ignoreSafeArea: false, // add this
      //       );
      //     },
      //     child: Container(
      //       decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
      //         BoxShadow(
      //           color: yachtShadow,
      //           offset: Offset(1.w, 1.w),
      //           blurRadius: 3.w,
      //           spreadRadius: 1.w,
      //         )
      //       ]),
      //       height: 54,
      //       width: 54,
      //       child: Image.asset(
      //         'assets/icons/writing.png',
      //       ),
      //     ),
      //   ),
      // ),
    ]);
  }

  // Widget communityAd() {
  //   RxBool isAdLoaded = false.obs;
  //   NativeAd ad = NativeAd(
  //     adUnitId: AdManager.nativeAdUnitId,
  //     factoryId: 'listTile',
  //     request: AdRequest(),
  //     listener: NativeAdListener(
  //       onAdLoaded: (_) {
  //         // setState(() {
  //         isAdLoaded(true);
  //         // });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         // Releases an ad resource when it fails to load
  //         ad.dispose();

  //         print('Ad load failed (code=${error.code} message=${error.message})');
  //       },
  //     ),
  //   );

  //   ad.load();
  //   return StatefulBuilder(builder: (context, setState) {
  //     return Obx(
  //       () => isAdLoaded.value
  //           ? Column(
  //               children: [
  //                 // SizedBox(
  //                 //   height: 20.w,
  //                 // ),
  //                 Container(
  //                   padding: moduleBoxPadding(feedDateTime.fontSize!),
  //                   decoration: primaryBoxDecoration.copyWith(
  //                     boxShadow: [primaryBoxShadow],
  //                     color: primaryBoxDecoration.color,
  //                   ),
  //                   height: Platform.isAndroid ? 80.w : 110.w,
  //                   child: AdWidget(
  //                     ad: ad,
  //                   ),
  //                 ),

  //                 SizedBox(
  //                   height: 12.w,
  //                 ),
  //               ],
  //             )
  //           : Container(),
  //     );
  //   });
  // }
}

class CommunityAd extends StatelessWidget {
  CommunityAd({Key? key}) : super(key: key);
  RxBool isAdLoaded = false.obs;

  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    NativeAd ad = NativeAd(
      adUnitId: AdManager.nativeAdUnitId,
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          // setState(() {
          isAdLoaded(true);
          // });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    ad.load();
    return StatefulBuilder(builder: (context, setState) {
      return Obx(
        () => isAdLoaded.value
            ? Column(
                children: [
                  // SizedBox(
                  //   height: 12.w,
                  // ),
                  Container(
                    padding: moduleBoxPadding(feedDateTime.fontSize!),
                    // decoration: primaryBoxDecoration.copyWith(
                    //   boxShadow: [primaryBoxShadow],
                    //   color: primaryBoxDecoration.color,
                    // ),
                    height: Platform.isAndroid ? 80.w : 110.w,
                    child: AdWidget(
                      ad: ad,
                    ),
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                ],
              )
            : Container(),
      );
    });
  }
}

// class CommunityAd extends StatefulWidget {
//   @override
//   State<CommunityAd> createState() => _CommunityAdState();
// }

// class _CommunityAdState extends State<CommunityAd> {
//   final controller = NativeAdController();
//   RxBool isAdLoaded = false.obs;
//   @override
//   void initState() {
//     super.initState();
//     controller.load();
//     controller.onEvent.listen((event) {
//       if (event.keys.first == NativeAdEvent.loaded) {
//         isAdLoaded(true);
//         printAdDetails(controller);
//       }
//       // setState(() {});
//     });
//   }

//   void printAdDetails(NativeAdController controller) async {
//     /// Just for showcasing the ability to access
//     /// NativeAd's details via its controller.
//     // print("------- NATIVE AD DETAILS: -------");
//     // print(controller.headline);
//     // print(controller.body);
//     // print(controller.price);
//     // print(controller.store);
//     // print(controller.callToAction);
//     // print(controller.advertiser);
//     // print(controller.iconUri);
//     // print(controller.imagesUri);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   AdLayoutBuilder get myCustomLayoutBuilder =>
//       (ratingBar, media, icon, headline, advertiser, body, price, store, attribution, button) {
//         return AdLinearLayout(
//           orientation: HORIZONTAL,
//           children: [
//             AdLinearLayout(
//               padding: EdgeInsets.only(right: 14.w),
//               width: WRAP_CONTENT,
//               orientation: VERTICAL,
//               children: [attribution, icon],
//             ),
//             AdLinearLayout(
//               width: WRAP_CONTENT,
//               height: WRAP_CONTENT,
//               orientation: VERTICAL,
//               gravity: LayoutGravity.left,
//               children: [
//                 headline,
//                 AdLinearLayout(
//                   width: MATCH_PARENT,
//                   orientation: HORIZONTAL,
//                   gravity: LayoutGravity.left,
//                   children: [
//                     AdExpanded(
//                       flex: 1,
//                       child: AdLinearLayout(
//                         width: WRAP_CONTENT,
//                         orientation: VERTICAL,
//                         gravity: LayoutGravity.left,
//                         children: [
//                           advertiser,
//                           body,
//                         ],
//                       ),
//                     ),
//                     AdExpanded(flex: 7, child: button)
//                     // AdLinearLayout(
//                     //   height: MATCH_PARENT,
//                     //   width: MATCH_PARENT,
//                     //   orientation: VERTICAL,
//                     //   gravity: LayoutGravity.center_vertical,
//                     //   children: [button],
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         );

//         // AdLinearLayout(
//         //   decoration: AdDecoration(backgroundColor: Colors.white),
//         //   width: MATCH_PARENT,
//         //   height: MATCH_PARENT,
//         //   gravity: LayoutGravity.top,
//         //   // padding: EdgeInsets.all(8.0),
//         //   children: [
//         //     attribution,
//         //     AdLinearLayout(
//         //       margin: EdgeInsets.only(top: 6.0),
//         //       orientation: HORIZONTAL,
//         //       children: [
//         //         icon,
//         //         AdExpanded(
//         //           flex: 2,
//         //           child: AdLinearLayout(
//         //             width: WRAP_CONTENT,
//         //             // height: WRAP_CONTENT,
//         //             gravity: LayoutGravity.top,
//         //             margin: EdgeInsets.symmetric(horizontal: 4),
//         //             children: [
//         //               headline,
//         //               advertiser,
//         //               body,
//         //             ],
//         //           ),
//         //         ),
//         //         AdExpanded(flex: 5, child: button),
//         //       ],
//         //     ),
//         //   ],
//         // );
//       };

// // native_admob_flutter
//   @override
//   Widget build(BuildContext context) {
//     // controller.load();
//     return Obx(() => isAdLoaded.value
//         ? Column(
//             children: [
//               Container(
//                 padding: moduleBoxPadding(0),
//                 decoration: primaryBoxDecoration.copyWith(
//                   boxShadow: [primaryBoxShadow],
//                   color: primaryBoxDecoration.color,
//                 ),
//                 child: NativeAd(
//                   controller: controller,
//                   // buildLayout: smallAdTemplateLayoutBuilder,
//                   buildLayout: myCustomLayoutBuilder,
//                   height: 90.w,

//                   attribution: AdTextView(
//                       width: WRAP_CONTENT,
//                       height: 18.w,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 6.w,
//                         // vertical: 1.w,
//                       ),
//                       decoration: AdDecoration(
//                         backgroundColor: yachtViolet,
//                         borderRadius: AdBorderRadius.all(10.w),
//                       ),
//                       style: TextStyle(
//                         // fontFamily: krFont,
//                         // fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                         fontSize: 9.w,
//                       )),
//                   body: AdTextView(
//                     style: TextStyle(
//                       fontSize: 12.w,
//                       // fontWeight: FontWeight.bold,
//                       color: yachtBlack,
//                     ),
//                     maxLines: 1,
//                   ),
//                   headline: AdTextView(
//                     style: TextStyle(
//                       fontSize: 14.w,
//                       // fontWeight: FontWeight.bold,
//                       color: yachtBlack,
//                     ),
//                     maxLines: 1,
//                   ),
//                   button: AdButtonView(
//                       width: MATCH_PARENT,
//                       height: 30.w,
//                       // padding: EdgeInsets.symmetric(
//                       //   horizontal: 10.w,
//                       //   vertical: 1.w,
//                       // ),
//                       decoration: AdDecoration(
//                         backgroundColor: yachtViolet,
//                       ),
//                       textStyle: TextStyle(
//                         color: white,
//                       )),
//                   // body: AdTextView(
//                   //   height: 1.0,
//                   //   maxLines: 3,
//                   // ),
//                 ),
//               ),
//               SizedBox(height: 12.w),
//             ],
//           )
//         : Container());
//   }
// }

class WritingNewPost extends StatelessWidget {
  WritingNewPost({
    Key? key,
    required CommunityViewModel communityViewModel,
  })  : _communityViewModel = communityViewModel,
        super(key: key);

  final GlobalKey<FormState> _contentFormKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final CommunityViewModel _communityViewModel;
  final MixpanelService _mixpanelService = locator<MixpanelService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          width: 30.w,
                          height: 30.w,
                          child: Image.asset(
                            'assets/icons/exit.png',
                            width: 14.w,
                            height: 14.w,
                            color: white,
                          ),
                        )),
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
                    child: Obx(
                      () => InkWell(
                        onTap: () async {
                          if (_contentFormKey.currentState!.validate() &&
                              !_communityViewModel.isUploadingNewPost.value) {
                            _mixpanelService.mixpanel.track('Post Upload', properties: {
                              'New Post Writer Uid': userModelRx.value!.uid,
                              'New Post Writer User Name': userModelRx.value!.userName,
                            });
                            HapticFeedback.lightImpact();
                            _communityViewModel.isUploadingNewPost(true);
                            await _communityViewModel.uploadPost(_contentController.value.text);
                            // print("just before reload");
                            await _communityViewModel.reloadPost();
                            _communityViewModel.isUploadingNewPost(false);
                            Get.back();
                            yachtSnackBar("성공적으로 업로드 되었어요.");
                          }
                        },
                        child: _communityViewModel.isUploadingNewPost.value
                            ? simpleTextContainerButton("올리기",
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.4.w,
                                  color: yachtViolet,
                                ))
                            : basicActionButtion(
                                "올리기",
                                buttonColor: yachtViolet,
                              ),
                      ),
                    ),
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
                  color: yachtBlack,
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
                          style: TextStyle(color: white),
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
                          // print(_communityViewModel.images![0]);
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
                                              onTap: () {
                                                _communityViewModel.images!.removeAt(index);
                                              },
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
                              // print('image length: ${_communityViewModel.images!.length}');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 14.w,
                                ),
                                Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration:
                                        BoxDecoration(color: yachtGrey, borderRadius: BorderRadius.circular(10.w)),
                                    child: SvgPicture.asset(
                                      'assets/icons/upload_photo.svg',
                                      color: white,
                                      height: 20.w,
                                      width: 20.w,
                                    )),
                              ],
                            )),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
