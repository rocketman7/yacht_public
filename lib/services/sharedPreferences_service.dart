import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SharedPreferencesService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> updateSharedPreferencesValue() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    prefs.setInt("counter", counter);
  }

  Future<int> getSharedPreferencesValue() async {
    Future<int> _result = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });

    return _result;
  }

  Future<void> updateSharedPreferencesValue2(String name, var value) async {
    final SharedPreferences prefs = await _prefs;

    if (value is int) {
      prefs.setInt(name, value);
    } else if (value is double) {
      prefs.setDouble(name, value);
    }
  }

  Future<dynamic> getSharedPreferencesValue2(String name, var value) async {
    if (value is int) {
      Future<dynamic> _result = _prefs.then((SharedPreferences prefs) {
        return (prefs.getInt(name) ?? 0);
      });

      return _result;
    } else if (value is double) {
      Future<dynamic> _result = _prefs.then((SharedPreferences prefs) {
        return (prefs.getDouble(name) ?? 0);
      });

      return _result;
    }
  }
}
