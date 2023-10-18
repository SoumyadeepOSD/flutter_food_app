import 'package:flutter/material.dart';

class generalStateProvider extends ChangeNotifier {
  String thisnumber = '';
  String thislocation = '';
  void setNumber(number) {
    thisnumber = number;
    notifyListeners();
  }

  void setLocation(location) {
    thislocation = location;
    notifyListeners();
  }
}
