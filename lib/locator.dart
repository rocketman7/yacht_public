import 'package:get_it/get_it.dart';
import 'package:yachtOne/services/amplitude_service.dart';

import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/navigation_service.dart';
import 'services/dialog_service.dart';
import 'services/push_notification_service.dart';
import 'services/storage_service.dart';
import 'services/sharedPreferences_service.dart';
import 'services/customCacheManager_service.dart';
import 'services/accountVerification_service.dart';
import 'services/stateManage_service.dart';

GetIt locator = GetIt.instance;

// 앞서 만든 서비스들을 setupLocator에 설정하고 main.dart에 injection 한다
// main에서 직접 연결되는 클래스에서는 바로 사용가능한데, 개별 클래스에서는 locator와 service를 import해야 하는듯?
void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton<StorageService>(() => StorageServiceFirebase());
  locator.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesServiceLocal());
  locator.registerLazySingleton(() => CustomCacheManagerService());
  locator.registerLazySingleton<AccountVerificationService>(
      () => AccoutVerificationServiceMydata());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton<StateManageService>(
      () => StateManageServiceFirebase());
  locator.registerLazySingleton(() => AmplitudeService());
}
