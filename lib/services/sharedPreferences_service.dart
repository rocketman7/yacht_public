import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesService {
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  Future<void> clearSharedPreferencesAll() async {
    final SharedPreferences preferences = await _preferences;
    preferences.clear();
  }

  Future<dynamic> getSharedPreferences(String key, Type type) async {
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
    // return preferences.get(key);
  }

  Future<void> setSharedPreferences(String key, var value) async {
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
