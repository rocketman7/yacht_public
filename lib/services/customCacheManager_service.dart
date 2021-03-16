import 'package:file/src/interface/file.dart';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CustomCacheManagerService extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManagerService _instance;

  // factory CustomCacheManagerService() {
  //   if (_instance == null) {
  //     _instance = new CustomCacheManagerService._();
  //   }
  //   return _instance;
  // }

  // 아래 Duration으로 사용자기기에 cache를 며칠 보관할지, maxNrOfCacheObjects로 몇개 보관할지 지정해준다.
  // CustomCacheManagerService._()
  //     : super(key,
  //           maxAgeCacheObject: Duration(days: 1), maxNrOfCacheObjects: 30);

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

  // cache 비우기
  void emptyCacheAll() {
    _instance.emptyCache();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<FileInfo> downloadFile(String url,
      {String key, Map<String, String> authHeaders, bool force = false}) {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }

  @override
  Future<void> emptyCache() {
    // TODO: implement emptyCache
    throw UnimplementedError();
  }

  @override
  Stream<FileInfo> getFile(String url,
      {String key, Map<String, String> headers}) {
    // TODO: implement getFile
    throw UnimplementedError();
  }

  @override
  Future<FileInfo> getFileFromCache(String key, {bool ignoreMemCache = false}) {
    // TODO: implement getFileFromCache
    throw UnimplementedError();
  }

  @override
  Future<FileInfo> getFileFromMemory(String key) {
    // TODO: implement getFileFromMemory
    throw UnimplementedError();
  }

  @override
  Stream<FileResponse> getFileStream(String url,
      {String key, Map<String, String> headers, bool withProgress}) {
    // TODO: implement getFileStream
    throw UnimplementedError();
  }

  @override
  Future<File> getSingleFile(String url,
      {String key, Map<String, String> headers}) {
    // TODO: implement getSingleFile
    throw UnimplementedError();
  }

  @override
  Future<File> putFile(String url, Uint8List fileBytes,
      {String key,
      String eTag,
      Duration maxAge = const Duration(days: 30),
      String fileExtension = 'file'}) {
    // TODO: implement putFile
    throw UnimplementedError();
  }

  @override
  Future<File> putFileStream(String url, Stream<List<int>> source,
      {String key,
      String eTag,
      Duration maxAge = const Duration(days: 30),
      String fileExtension = 'file'}) {
    // TODO: implement putFileStream
    throw UnimplementedError();
  }

  @override
  Future<void> removeFile(String key) {
    // TODO: implement removeFile
    throw UnimplementedError();
  }
}
