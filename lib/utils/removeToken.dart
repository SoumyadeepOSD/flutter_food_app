import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.remove("token");
  !result ? debugPrint("Failed to save token") : debugPrint("token removed");
}
