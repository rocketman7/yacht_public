import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';

import '../../styles/size_config.dart';
import '../../styles/yacht_design_system.dart';
import 'admin_mode_view_model.dart';

class AdminModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar('관리모드'),
      body: ListView(
        children: [
          SizedBox(
            height: 12.w,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.to(() => AdminModeOneOnOneView());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.w,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w),
                  child: Text('1:1문의'),
                ),
                SizedBox(
                  height: 8.w,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Container(height: 1.w, color: yachtLightGrey),
          )
        ],
      ),
    );
  }
}

class AdminModeOneOnOneView extends StatelessWidget {
  final AdminModeOneOnOneViewModel _adminModeOneOnOneViewModel =
      Get.put(AdminModeOneOnOneViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar('관리모드(1:1문의)'),
      body: GetBuilder<AdminModeOneOnOneViewModel>(builder: (controller) {
        return controller.isAllOneOnOneLoaded
            ? Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 14.w,
                        ),
                        controller.isAdLoaded
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 14.w, right: 14.w, bottom: 14.w),
                                child: Container(
                                  width: double.infinity,
                                  padding: primaryAllPadding,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(12.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: yachtShadow,
                                          blurRadius: 8.w,
                                          spreadRadius: 1.w,
                                        )
                                      ]),
                                  child: AdWidget(
                                      ad: _adminModeOneOnOneViewModel.ad),
                                  height: 110.w,
                                  alignment: Alignment.center,
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(left: 14.w),
                          child: Text(
                            '답변 후 화면 나갔다 와야 리스트 반영',
                            style: TextStyle(color: yachtRed),
                          ),
                        ),
                        SizedBox(
                          height: 14.w,
                        ),
                        Column(
                          children: controller.visualOneOnOneAdminModels
                              .toList()
                              .asMap()
                              .map((i, element) => MapEntry(
                                    i,
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 14.w,
                                          right: 14.w,
                                          bottom: 14.w),
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.to(() =>
                                                AdminModeOneOnOneDetailView(
                                                  oneOnOneAdminModel: controller
                                                      .visualOneOnOneAdminModels[i],
                                                ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: primaryAllPadding,
                                            decoration: BoxDecoration(
                                                color: white,
                                                borderRadius:
                                                    BorderRadius.circular(12.w),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: yachtShadow,
                                                    blurRadius: 8.w,
                                                    spreadRadius: 1.w,
                                                  )
                                                ]),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '문의일자: ${timeStampToStringWithHourMinute(controller.visualOneOnOneAdminModels[i].dateTime)}'),
                                                Text(
                                                    controller.visualOneOnOneAdminModels[i]
                                                                .answer !=
                                                            ''
                                                        ? '답변상태: 답변 완료'
                                                        : '답변상태: 답변 전',
                                                    style: TextStyle(
                                                      color: controller
                                                                  .visualOneOnOneAdminModels[
                                                                      i]
                                                                  .answer !=
                                                              ''
                                                          ? yachtBlack
                                                          : yachtRed,
                                                    )),
                                                SizedBox(
                                                  height: 8.w,
                                                ),
                                                Text(
                                                    '${controller.visualOneOnOneAdminModels[i].userName} 님의 문의',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                Text(
                                                    '${controller.visualOneOnOneAdminModels[i].content}',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                SizedBox(
                                                  height: 8.w,
                                                ),
                                                Text(
                                                  '문의 내용은 최대 2줄만 표시. 박스를 클릭하여 답변',
                                                  style: TextStyle(
                                                      color: yachtGrey),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ))
                              .values
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.safeAreaTop + 60.w,
                    right: 14.w,
                    child: GetBuilder<AdminModeOneOnOneViewModel>(
                        builder: (controller) {
                      return ElevatedButton(
                        onPressed: () {
                          _adminModeOneOnOneViewModel
                              .switchVisualAnswerDoneOneOnOnes();
                        },
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return yachtViolet;
                          } else {
                            return yachtViolet;
                          }
                        })),
                        child: Text(_adminModeOneOnOneViewModel
                                .visualAnswerDoneOneOnOnes
                            ? '전체 문의 보기'
                            : '답변 필요 문의만 보기'),
                      );
                    }),
                  ),
                ],
              )
            : Container();
      }),
    );
  }
}

class AdminModeOneOnOneDetailView extends StatelessWidget {
  final OneOnOneAdminModel oneOnOneAdminModel;

  AdminModeOneOnOneDetailView({required this.oneOnOneAdminModel});

  @override
  Widget build(BuildContext context) {
    final AdminModeOneOnOneDetailViewModel adminModelOneOnOneDetailViewModel =
        Get.put(AdminModeOneOnOneDetailViewModel(
            oneOnOneAdminModel: oneOnOneAdminModel));

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar('관리모드(1:1문의)'),
      resizeToAvoidBottomInset: false,
      body: Container(
          child: Column(
        children: [
          SizedBox(
            height: SizeConfig.safeAreaTop + 60.w + 8.w,
          ),
          Stack(
            children: [
              Container(
                height:
                    (SizeConfig.screenHeight - SizeConfig.safeAreaTop - 60.w) /
                            2 -
                        8.w,
                child: Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w),
                  child: Container(
                    width: SizeConfig.screenWidth - 28.w,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12.w),
                        boxShadow: [
                          BoxShadow(
                            color: yachtShadow,
                            blurRadius: 8.w,
                            spreadRadius: 1.w,
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Scrollbar(
                        thickness: 4.w,
                        radius: Radius.circular(4.0),
                        child: TextFormField(
                          controller: adminModelOneOnOneDetailViewModel
                              .contentController,
                          textAlignVertical: TextAlignVertical.bottom,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1000,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(0.w),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: adminModelOneOnOneDetailViewModel
                                        .oneOnOneAdminModel.answer !=
                                    ''
                                ? '${adminModelOneOnOneDetailViewModel.oneOnOneAdminModel.answer}'
                                : '문의 답변을 적어주세요.',
                            hintStyle: TextStyle(color: yachtGrey),
                          ),
                          onChanged: (value) {
                            adminModelOneOnOneDetailViewModel.content(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() => adminModelOneOnOneDetailViewModel.questionVisible.value
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: 14.w, right: 14.w, bottom: 14.w),
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            height: (SizeConfig.screenHeight -
                                        SizeConfig.safeAreaTop -
                                        60.w) /
                                    2 -
                                8.w,
                            padding: primaryAllPadding,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: yachtShadow,
                                    blurRadius: 8.w,
                                    spreadRadius: 1.w,
                                  )
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '문의일자: ${timeStampToStringWithHourMinute(adminModelOneOnOneDetailViewModel.oneOnOneAdminModel.dateTime)}'),
                                Text(
                                    adminModelOneOnOneDetailViewModel
                                                .oneOnOneAdminModel.answer !=
                                            ''
                                        ? '답변상태: 답변 완료'
                                        : '답변상태: 답변 전',
                                    style: TextStyle(
                                      color: adminModelOneOnOneDetailViewModel
                                                  .oneOnOneAdminModel.answer !=
                                              ''
                                          ? yachtBlack
                                          : yachtRed,
                                    )),
                                SizedBox(
                                  height: 8.w,
                                ),
                                Text(
                                    '${adminModelOneOnOneDetailViewModel.oneOnOneAdminModel.userName} 님의 문의',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    )),
                                Text(
                                    '${adminModelOneOnOneDetailViewModel.oneOnOneAdminModel.category}'),
                                SizedBox(
                                  height: 8.w,
                                ),
                                Expanded(
                                  child: Container(
                                    // color: Colors.grey,
                                    child: MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView(
                                        children: [
                                          Text(
                                              '${adminModelOneOnOneDetailViewModel.oneOnOneAdminModel.content}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.w,
                                ),
                              ],
                            ),
                          )),
                    )
                  : Container()),
              Positioned(
                  right: 14.w,
                  child: ElevatedButton(
                    onPressed: () {
                      adminModelOneOnOneDetailViewModel.questionVisible(
                          !adminModelOneOnOneDetailViewModel
                              .questionVisible.value);
                    },
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return yachtViolet;
                      } else {
                        return yachtViolet;
                      }
                    })),
                    child: Obx(() => Text(
                        adminModelOneOnOneDetailViewModel.questionVisible.value
                            ? '문의 닫기'
                            : '문의 보기')),
                  )),
              Positioned(
                  top: 40.w,
                  right: 14.w,
                  child: Obx(() =>
                      !adminModelOneOnOneDetailViewModel.questionVisible.value
                          ? ElevatedButton(
                              onPressed: () async {
                                oneOnOneAnswerDialog(
                                    context, adminModelOneOnOneDetailViewModel);
                              },
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return yachtViolet;
                                } else {
                                  return yachtViolet;
                                }
                              })),
                              child: Text('답변 확정'),
                            )
                          : Container())),
            ],
          ),
        ],
      )),
    );
  }
}

oneOnOneAnswerDialog(BuildContext context,
    AdminModeOneOnOneDetailViewModel adminModeOneOnOneDetailViewModel) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 167.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 16.w,
                        width: 16.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 14.w,
                        ),
                        Text('알림',
                            style:
                                yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 14.w,
                              ),
                              SizedBox(
                                  height: 16.w,
                                  width: 16.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 30.w,
                            width: 14.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(32.5.w, yachtBadgesDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Center(
                  child: Text(
                    '1:1 문의 답변을 보내시겠습니까?',
                    textAlign: TextAlign.center,
                    style: yachtBadgesDescriptionDialogTitle,
                  ),
                ),
                SizedBox(
                  height: correctHeight(
                      24.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        Navigator.of(context).pop();
                        Get.back();
                        oneOnOneAnswerSuccessDialog(context);
                        adminModeOneOnOneDetailViewModel.answerToQuestion(
                            adminModeOneOnOneDetailViewModel
                                .contentController.text);
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '보내기',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: buttonNormal,
                        ),
                        child: Center(
                          child: Text(
                            '취소',
                            style: yachtDeliveryDialogButtonText.copyWith(
                                color: yachtViolet),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}

oneOnOneAnswerSuccessDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 192.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 16.w,
                        width: 16.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 14.w,
                        ),
                        Text('알림',
                            style:
                                yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 14.w,
                              ),
                              SizedBox(
                                  height: 16.w,
                                  width: 16.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 30.w,
                            width: 14.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(32.5.w, yachtBadgesDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Center(
                  child: Text(
                    '1:1 문의 답변을 성공적으로 보냈습니다.\n답변 완료 리스트에서 더블체크 부탁!',
                    textAlign: TextAlign.center,
                    style: yachtBadgesDescriptionDialogTitle,
                  ),
                ),
                SizedBox(
                  height: correctHeight(
                      24.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 309.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}
