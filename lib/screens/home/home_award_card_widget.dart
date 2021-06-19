import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/award/award_view_model.dart';

class HomeAwardCardWidget extends StatelessWidget {
  const HomeAwardCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 아래처럼 여기에 선언해주고 실제 view에서 find로 가져오는 방법도 있음
    // 이렇게 해줘야할 듯. 특히 pageview 인덱스들도 확정해야하기 때문에?
    final AwardViewModel awardViewModel = Get.put(AwardViewModel());

    return Row(
      children: [
        Spacer(),
        Column(
          children: [
            ElevatedButton(
              child: Text('${awardViewModel.awardModels[0].awardTitle}'),
              onPressed: () {
                Get.toNamed('award');
              },
            ),
            Text('${awardViewModel.awardModels[0].totalAwardValue}'),
          ],
        ),
        Spacer(),
        Column(
          children: [
            ElevatedButton(
              child: Text('${awardViewModel.awardModels[1].awardTitle}'),
              onPressed: () {
                Get.toNamed('award');
              },
            ),
            Text('${awardViewModel.awardModels[1].totalAwardValue}'),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
