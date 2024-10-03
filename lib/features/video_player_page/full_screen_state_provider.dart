import 'package:flutter/material.dart';

class FullScreenState with ChangeNotifier {
  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  void setFullScreen(bool value) {
    _isFullScreen = value;
    notifyListeners();
  }
}
