import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesService {
  Future<void> clearSharedPreferencesAll();
  Future<dynamic> getSharedPreferencesValue(String key, Type type);
  Future<void> setSharedPreferencesValue(String key, dynamic value);
}

class SharedPreferencesServiceLocal extends SharedPreferencesService {
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  @override
  Future<void> clearSharedPreferencesAll() async {
    final SharedPreferences preferences = await _preferences;
    preferences.clear();
  }

  @override
  Future getSharedPreferencesValue(String key, Type type) async {
    final SharedPreferences preferences = await _preferences;

    var temp = preferences.get(key);

    if (temp != null) {
      return temp;
    } else {
      switch (type) {
        case bool:
          return false;
        case int:
          return 0;
        case double:
          return 0.0;
        case String:
          return '';
      }
    }
  }

  @override
  Future<void> setSharedPreferencesValue(String key, value) async {
    final SharedPreferences preferences = await _preferences;

    if (value is int) {
      preferences.setInt(key, value);
    } else if (value is double) {
      preferences.setDouble(key, value);
    } else if (value is bool) {
      preferences.setBool(key, value);
    } else if (value is String) {
      preferences.setString(key, value);
    }
  }
}
