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
}
