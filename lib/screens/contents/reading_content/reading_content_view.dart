import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReadingContentView extends GetView {
  final HomeViewModel homeViewModel;
  ReadingContentView({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  // TODO: implement controller
  get controller => Get.put(ReadingContentViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
            // color: Colors.red,
            child: Text("읽을 거리", style: sectionTitle),
          ),
          SizedBox(
            height: heightSectionTitleAndBox,
          ),
          SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                if (controller.readingContents.length > 0) {
                  return Row(
                    children: List.generate(
                        controller.readingContents.length,
                        (index) => Row(
                              children: [
                                index == 0
                                    ? SizedBox(
                                        width: primaryPaddingSize,
                                      )
                                    : Container(),
                                InkWell(
                                  onTap: () async {
                                    await controller.launchUrl(controller
                                        .readingContents[index].contentUrl);
                                  },
                                  child: Container(
                                      child: FutureBuilder<String>(
                                          future: controller
                                              .getImageUrlFromStorage(controller
                                                  .readingContents[0]
                                                  .thumbnailUrl),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              String imageUrl = snapshot.data!;
                                              return CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                width: 270.w,
                                                height: 240.w,
                                              );
                                            } else {
                                              return Container(
                                                width: 270.w,
                                                height: 240.w,
                                              );
                                            }
                                          })),
                                ),
                                SizedBox(
                                  width: primaryPaddingSize,
                                )
                              ],
                            )),
                  );
                } else {
                  return Container(
                    width: 270.w,
                    height: 240.w,
                  );
                }
              }))
        ]);
  }
}
