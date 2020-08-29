import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> updateSharedPreferencesValue(String name, var value) async {
    final SharedPreferences prefs = await _prefs;

    if (value is int) {
      prefs.setInt(name, value);
    } else if (value is double) {
      prefs.setDouble(name, value);
    } else if (value is bool) {
      prefs.setBool(name, value);
    } else if (value is String) {
      prefs.setString(name, value);
    }
  }

  Future<dynamic> getSharedPreferencesValue(String name, Type type) async {
    if (type == int) {
      Future<dynamic> _result = _prefs.then((SharedPreferences prefs) {
        return (prefs.getInt(name) ?? 0);
      });

      return _result;
    } else if (type == double) {
      Future<dynamic> _result = _prefs.then((SharedPreferences prefs) {
        return (prefs.getDouble(name) ?? 0.0);
      });

      return _result;
    } else if (type == bool) {
      Future<dynamic> _result = _prefs.then((SharedPreferences prefs) {
        return (prefs.getBool(name) ?? false);
      });

      return _result;
    } else if (type == String) {
      Future<dynamic> _result = _prefs.then((SharedPreferences prefs) {
        return (prefs.getString(name) ?? null);
      });

      return _result;
    }
  }

  Future<void> clearSharedPreferencesValue() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }
}
