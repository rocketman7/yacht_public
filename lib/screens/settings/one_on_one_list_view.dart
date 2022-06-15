import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/style_constants.dart';

import '../../styles/size_config.dart';
import '../../styles/yacht_design_system.dart';
import 'one_on_one_list_view_model.dart';
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

class OneOnOneListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar(
          '나의 1:1 문의내역',
        ),
        body: GetBuilder<OneOnOneListViewModel>(
            init: OneOnOneListViewModel(),
            builder: (controller) {
              if (controller.isLoaded)
                return ListView(
                  children: [
                    SizedBox(
                      height: 14.w,
                    ),
                    Column(
                      children: controller.oneOnOneListList
                          .toList()
                          .asMap()
                          .map((i, element) => MapEntry(
                                i,
                                Padding(
                                  padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.w),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => OneOnOneListDetailView(
                                            index: i,
                                          ));
                                    },
                                    child: sectionBox(
                                        child: Container(
                                      padding: primaryAllPadding,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                controller.oneOnOneListList[i].answer != '' ? '답변 완료' : '답변 대기중',
                                                style: feedWriterName.copyWith(color: yachtRed),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                height: 12.w,
                                                width: 8.w,
                                                child: Image.asset('assets/icons/right_arrow_grey.png'),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                correctHeight(10.w, feedWriterName.fontSize, feedWriterName.fontSize),
                                          ),
                                          Text(
                                            '${controller.oneOnOneListList[i].content}',
                                            style: feedWriterName,
                                            maxLines: 3,
                                          ),
                                          Text(
                                            controller.oneOnOneListList[i].answer != ''
                                                ? '${controller.oneOnOneListList[i].answer}'.replaceAll('\\n', '\n')
                                                : '아직 답변이 등록되지 않았습니다.\n조금만 더 기다려주시면 친절히 답변드릴게요!',
                                            style: feedContent,
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                ),
                              ))
                          .values
                          .toList(),
                    ),
                  ],
                );
              else
                return Container();
            }));
  }
}

class OneOnOneListDetailView extends StatelessWidget {
  final int index;

  OneOnOneListDetailView({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar(
          '나의 1:1 문의내역',
        ),
        body: GetBuilder<OneOnOneListViewModel>(builder: (controller) {
          if (controller.isLoaded)
            return ListView(
              children: [
                SizedBox(
                  height: 14.w,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.w),
                  child: InkWell(
                    onTap: () {},
                    child: sectionBox(
                        child: Container(
                      padding: primaryAllPadding,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.oneOnOneListList[index].answer != '' ? '답변 완료' : '답변 대기중',
                            style: feedWriterName.copyWith(color: yachtRed),
                          ),
                          SizedBox(
                            height: correctHeight(10.w, feedWriterName.fontSize, feedWriterName.fontSize),
                          ),
                          Text(
                            '${controller.oneOnOneListList[index].content}',
                            style: feedWriterName,
                          ),
                          SizedBox(
                            height: correctHeight(10.w, feedWriterName.fontSize, 0.w),
                          ),
                          Container(height: 1.w, width: double.infinity, color: yachtLightGrey),
                          SizedBox(
                            height: correctHeight(10.w, 0.w, feedWriterName.fontSize),
                          ),
                          Text(
                            controller.oneOnOneListList[index].answer != ''
                                ? '${controller.oneOnOneListList[index].answer}'.replaceAll('\\n', '\n')
                                : '아직 답변이 등록되지 않았습니다.\n조금만 더 기다려주시면 친절히 답변드릴게요!',
                            style: feedContent,
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            );
          else
            return Container();
        }));
  }
}
