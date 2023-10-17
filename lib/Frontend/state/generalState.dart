import 'package:flutter/material.dart';

class generalStateProvider extends ChangeNotifier {
  String thisnumber = '';
  void setNumber(number) {
    thisnumber = number;
    notifyListeners();
  }
}
