import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../locator.dart';
import '../../services/firestore_service.dart';
import '../../models/notification_model.dart';

class NotificationViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  late final List<NotificationModel> notificationList;
  bool isNotificationListLoaded = false;

  @override
  void onInit() async {
    notificationList = await _firestoreService.getNotificationList();

    isNotificationListLoaded = true;

    update(['notificationList']);

    super.onInit();
  }

  Timestamp lastNotificationTime() {
    // return notificationList.length == 0 ? Timestamp.fromDate(DateTime(2000)): notificationList[0].notificationTime;
    // 이미 view 코드에서 getbuilder 통해 notificationList가 null 이 아님은 보장이 된다. (홈뷰 참고)
    return notificationList[0].notificationTime;
  }

  Timestamp lastNotificationTimeForNavigate() {
    // 아래 같은 코드 짜 준 이유는 잉크웰 온탭에서 겟투해줄 때 겟빌더(퓨처빌더느낌) 없이 간략하게 해주기위해. 즉 혹시 늦게 로딩되더라도 유저모델 업데이트 되는 정도로만 막을 수 있음
    return notificationList.length == 0
        ? Timestamp.fromDate(DateTime(2000))
        : notificationList[0].notificationTime;
  }

  Future lastNotificationCheckTimeUpdate() async {
    await _firestoreService.stampLastNotificationCheck();
  }
}
