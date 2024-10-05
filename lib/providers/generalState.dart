//// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:foodapp/screens/profile.dart';

class GeneralStateProvider extends ChangeNotifier {
  String thislocation = '';
  String flag = 'all';
  String thisQuery = "";
  String thisCategory = "";
  ProfileData? userData;
  bool? isLoading;
  int? cartItems;

  void setQuery(query) {
    thisQuery = query;
    notifyListeners();
  }

  void setCategory(cat) {
    thisQuery = cat;
    notifyListeners();
  }

  void setLocation(location) {
    thislocation = location;
    notifyListeners();
  }

  void setUserData(ProfileData data) {
    userData = data;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
  }

  void setCartItemCount(int items) {
    cartItems = items;
    notifyListeners();
  }
}
