import 'package:get/instance_manager.dart';

import 'screens/subLeague/subLeague_controller.dart';
import 'services/firestore_service.dart';

class ServicesBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.put<FirestoreService>(FirestoreService());
  }
}

// class HomeRepositoryBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.put(HomeRepository());
//   }
// }

// 남들 프로필은 아니고.. 내 프로필 용
class MyProfileRepositoryBinding implements Bindings {
  @override
  void dependencies() {}
}
