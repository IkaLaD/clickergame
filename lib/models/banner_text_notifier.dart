import 'package:flutter/material.dart';

class BannerTextNotifier extends ValueNotifier<String> {
  BannerTextNotifier(String value) : super(value);

  void updateText(String newText) {
    value = newText;
    notifyListeners();
  }
}