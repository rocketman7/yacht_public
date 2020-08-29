import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesService {
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  Future<void> clearSharedPreferencesAll() async {
    final SharedPreferences preferences = await _preferences;
    preferences.clear();
  }

  Future<dynamic> getSharedPreferences(String key) async {
    final SharedPreferences preferences = await _preferences;

    return preferences.get(key);
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
