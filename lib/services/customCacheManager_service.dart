import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CustomCacheManagerService extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManagerService _instance;

  factory CustomCacheManagerService() {
    if (_instance == null) {
      _instance = new CustomCacheManagerService._();
    }
    return _instance;
  }

  // 아래 Duration으로 사용자기기에 cache를 며칠 보관할지, maxNrOfCacheObjects로 몇개 보관할지 지정해준다.
  CustomCacheManagerService._()
      : super(key,
            maxAgeCacheObject: Duration(days: 1), maxNrOfCacheObjects: 30);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

  // cache 비우기
  void emptyCacheAll() {
    _instance.emptyCache();
  }
}
