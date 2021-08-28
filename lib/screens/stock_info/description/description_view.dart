import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/styles/style_constants.dart';

import 'description_view_model.dart';

// GetView 테스트
class DescriptionView extends GetView<DescriptionViewModel> {
  final InvestAddressModel investAddressModel;
  DescriptionView({
    required this.investAddressModel,
  });

  @override
  // controller에서 Get.put으로 initialize
  DescriptionViewModel get controller => Get.put(DescriptionViewModel(investAddressModel));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          controller.title, // viewModel의 데이터를 바로 쓸 수 있음
          style: questTitleTextStyle,
        ),
        SizedBox(
          height: reducedPaddingWhenTextIsBelow(20.w, detailedContentTextStyle.fontSize!),
        ),
        Obx(() => Text(
              controller.corporationModel.value.description ?? "기업 소개가 없습니다",
              style: detailedContentTextStyle,
            ))
      ],
    );
  }
}