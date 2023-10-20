import 'package:flutter/material.dart';

class generalStateProvider extends ChangeNotifier {
  String thisnumber = '';
  String thislocation = '';
  String flag = 'all';

  void setNumber(number) {
    thisnumber = number;
    notifyListeners();
  }

  void setLocation(location) {
    thislocation = location;
    notifyListeners();
  }

  void setAll() {
    if (flag != 'all') {
      flag = 'all';
      notifyListeners();
    }
  }

  void setBurger() {
    if (flag != 'burger') flag = 'burger';
    notifyListeners();
  }

  void setPizza() {
    if (flag != 'pizza') {
      flag = 'pizza';
      notifyListeners();
    }
  }

  void setNoodles() {
    if (flag != 'noodles') flag = 'noodles';
    notifyListeners();
  }

  void setMeat() {
    if (flag != 'meat') flag = 'meat';
    notifyListeners();
  }

  void setVeggie() {
    if (flag != 'veggie') flag = 'veggie';
    notifyListeners();
  }

  void setDesserts() {
    if (flag != 'desserts') flag = 'desserts';
    notifyListeners();
  }

  void setDrink() {
    if (flag != 'drink') {
      flag = 'drink';
      notifyListeners();
    }
  }
}
