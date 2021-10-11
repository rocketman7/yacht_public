import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/style_constants.dart';

import '../../styles/size_config.dart';
import '../../styles/yacht_design_system.dart';
import 'one_on_one_view_model.dart';

TextStyle categoryTextStyle = TextStyle(
  fontSize: 14.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtDarkPurple,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle contentTextStyle = TextStyle(
  fontSize: 16.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

class OneOnOneView extends StatelessWidget {
  final OneOnOneViewModel oneOnOneViewModel = Get.put(OneOnOneViewModel());

  @override
  Widget build(BuildContext context) {
    double textColumnHeight =
        correctHeight(10.w, 0.w, categoryTextStyle.fontSize) * 2 +
            textSizeGet('가감랄뤽', categoryTextStyle).height;
    double mainWindowHeight = min(
        SizeConfig.screenHeight -
            SizeConfig.safeAreaBottom -
            SizeConfig.safeAreaTop -
            60.w -
            24.w -
            textColumnHeight -
            20.w -
            8.w -
            50.w -
            8.w,
        200.w);

    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text('1:1 문의하기', style: appBarTitle),
        ),
        body: ListView(
          children: [
            Container(
              height: SizeConfig.screenHeight -
                  SizeConfig.safeAreaBottom -
                  SizeConfig.safeAreaTop -
                  60.w, // AppBar's toolbarHeight
              width: SizeConfig.screenWidth,
              color: Colors.white,
              child: Stack(
                children: [
                  //문의내용부분
                  Column(
                    children: [
                      SizedBox(
                        height: 24.w + textColumnHeight + 20.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14.w, right: 14.w),
                        child: Container(
                          width: 347.w,
                          height: mainWindowHeight,
                          decoration: primaryBoxDecoration.copyWith(boxShadow: [
                            BoxShadow(
                              color: Color(0xFFCEC4DA).withOpacity(0.3),
                              blurRadius: 8.w,
                              spreadRadius: 1.w,
                              offset: Offset(0, 0),
                            )
                          ], color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.all(14.w),
                            child: Scrollbar(
                              thickness: 4.w,
                              radius: Radius.circular(4.0),
                              child: TextFormField(
                                controller: oneOnOneViewModel.contentController,
                                textAlignVertical: TextAlignVertical.bottom,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1000,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0.w),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: '문의 내용을 적어주세요.',
                                  hintStyle: contentTextStyle.copyWith(
                                      color: yachtGrey),
                                ),
                                onChanged: (value) {
                                  oneOnOneViewModel.content(value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.w,
                      ),
                      Obx(() => Padding(
                            padding: EdgeInsets.only(left: 14.w, right: 14.w),
                            child: GestureDetector(
                              onTap: () {
                                if (oneOnOneViewModel.content.value != '') {
                                  oneOnOneUpdateDialog(context);
                                }
                              },
                              child: Container(
                                height: 50.w,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70.0),
                                    color: oneOnOneViewModel.content.value != ''
                                        ? yachtViolet
                                        : buttonDisabled),
                                child: Center(
                                  child: Text(
                                    '문의 보내기',
                                    style:
                                        profileChangeButtonTextStyle.copyWith(
                                            color: oneOnOneViewModel
                                                        .content.value !=
                                                    ''
                                                ? primaryButtonText
                                                : yachtGrey),
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  //카테고리부분
                  Column(
                    children: [
                      SizedBox(
                        height: 24.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14.w, right: 14.w),
                        child: Obx(() => !oneOnOneViewModel
                                .isCategorySelect.value
                            ? GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  oneOnOneViewModel.categorySelectMethod();
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: buttonNormal,
                                      ),
                                      width: 347.w,
                                      height: textColumnHeight,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: correctHeight(10.w, 0.w,
                                              categoryTextStyle.fontSize),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 6.w),
                                          child: Text(
                                            category[oneOnOneViewModel
                                                .selectedCategoryIndex.value],
                                            style: categoryTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      left: SizeConfig.screenWidth -
                                          14.w -
                                          13.w -
                                          14.w -
                                          14.w,
                                      top: 14.w,
                                      child: SizedBox(
                                          height: 7.w,
                                          width: 14.w,
                                          child: Image.asset(
                                              'assets/icons/oneonedown.png')),
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: buttonNormal,
                                    ),
                                    width: 347.w,
                                    height: textColumnHeight *
                                        (category.length + 1),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          oneOnOneViewModel
                                              .categorySelectMethod();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: correctHeight(10.w, 0.w,
                                                  categoryTextStyle.fontSize),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 6.w),
                                              child: Text(
                                                '문의 종류 선택',
                                                style:
                                                    categoryTextStyle.copyWith(
                                                        color: categoryTextStyle
                                                            .color!
                                                            .withOpacity(0.5)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: correctHeight(
                                                  9.w,
                                                  categoryTextStyle.fontSize,
                                                  0.w),
                                            ),
                                            Container(
                                                width: 347.w,
                                                height: 1.w,
                                                color: yachtLine),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: category
                                            .asMap()
                                            .map((i, element) => MapEntry(
                                                  i,
                                                  GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      oneOnOneViewModel
                                                          .categoryIndexSelectMethod(
                                                              i);
                                                      oneOnOneViewModel
                                                          .categorySelectMethod();
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: correctHeight(
                                                              10.w,
                                                              0.w,
                                                              categoryTextStyle
                                                                  .fontSize),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6.w),
                                                          child: Text(
                                                            category[i],
                                                            style:
                                                                categoryTextStyle,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: correctHeight(
                                                              9.w,
                                                              categoryTextStyle
                                                                  .fontSize,
                                                              0.w),
                                                        ),
                                                        (category.length - 1 !=
                                                                i)
                                                            ? Container(
                                                                width: 347.w,
                                                                height: 1.w,
                                                                color:
                                                                    yachtLine)
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                            .values
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    left: SizeConfig.screenWidth -
                                        14.w -
                                        13.w -
                                        14.w -
                                        14.w,
                                    top: 14.w,
                                    child: SizedBox(
                                        height: 7.w,
                                        width: 14.w,
                                        child: Image.asset(
                                            'assets/icons/oneoneup.png')),
                                  ),
                                ],
                              )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// 문의 보내시겠습니까?
oneOnOneUpdateDialog(BuildContext context) {
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
                    '1:1 문의를 보내시겠습니까?',
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
                        oneOnOneSuccessDialog(context);
                        await Get.find<OneOnOneViewModel>().oneOnOneUpdate(
                            category[Get.find<OneOnOneViewModel>()
                                .selectedCategoryIndex
                                .value],
                            Get.find<OneOnOneViewModel>().content.value);
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

// 문의 잘 보내졌습니다.
oneOnOneSuccessDialog(BuildContext context) {
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
                    '1:1 문의를 성공적으로 보냈어요.\n답변이 오면 알려드릴게요!',
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
