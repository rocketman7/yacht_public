import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  //busy, not busy handle
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
