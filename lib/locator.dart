import 'package:get_it/get_it.dart';
import 'package:yachtOne/services/firestore_service.dart';

import 'services/auth_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => AuthService());
}
