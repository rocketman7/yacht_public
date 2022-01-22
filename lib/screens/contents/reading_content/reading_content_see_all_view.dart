import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/loading_container.dart';

import '../../../locator.dart';

class ReadingContentSeeAll extends GetView<ReadingContentViewModel> {
  ReadingContentSeeAll({Key? key}) : super(key: key);

  ReadingContentViewModel controller = Get.put<ReadingContentViewModel>(ReadingContentViewModel());
  RxDouble offset = 0.0.obs;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.scrollController.addListener(() {
        // offset obs 값에 scroll controller offset 넣어주기
        controller.scrollController.offset < 0 ? offset(0) : offset(controller.scrollController.offset);
        // print(_scrollController.offset);
      });
    });
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          Obx(
            () => SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: YachtPrimaryAppBarDelegate(
                  offset: offset.value,
                  tabTitle: "요트 매거진",
                  buttonPosition: "left",
                  buttonWidget: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // _mixpanelService.mixpanel.track('Setting');
                      // Get.to(() => SettingView());
                      Get.back();
                    },
                    child: Row(
                      children: [BackButton()],
                    ),
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
              ),
              physics: ClampingScrollPhysics(),
              itemCount: controller.readingContents.length,
              shrinkWrap: true,
              // primary: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 12.w,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _mixpanelService.mixpanel.track('Yacht Magazine', properties: {
                      'Magazine Title': controller.readingContents[index].title,
                      'Magazine Category': controller.readingContents[index].category,
                      'Magazine Content Url': controller.readingContents[index].contentUrl,
                      'Magazine Thumbnail Url': controller.readingContents[index].thumbnailUrl,
                      'Magazine Update DateTime':
                          controller.readingContents[index].updateDateTime.toDate().toIso8601String(),
                    });
                    Get.to(() => ReadingContentWebView(readingContent: controller.readingContents[index]));
                    // await controller.launchUrl(controller.readingContents[index].contentUrl);
                  },
                  child: Container(
                      child: CachedNetworkImage(
                    imageUrl:
                        "https://storage.googleapis.com/ggook-5fb08.appspot.com/${controller.readingContents[index].thumbnailUrl}",
                    // width: 270.w,
                    // height: 240.w,
                    filterQuality: FilterQuality.high,
                    progressIndicatorBuilder: (_, __, DownloadProgress progress) {
                      // progress.totalSize
                      // if (progress == null) return child;
                      return LayoutBuilder(builder: (context, constraints) {
                        return LoadingContainer(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          radius: 10.w,
                        );
                      });
                    },
                  )),
                );
              },
            )
          ])),
          SliverToBoxAdapter(
            child: SizedBox(
              height: ScreenUtil().bottomBarHeight + 14.w,
            ),
          )
        ],
      ),
    );
  }
}
