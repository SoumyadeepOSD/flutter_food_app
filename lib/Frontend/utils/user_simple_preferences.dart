import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyLocation = 'location';
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

// *Set location data*
  static Future setLocation(String location) async =>
      await _preferences!.setString(_keyLocation, location);

// *Get location data*
  static String? getLocation() => _preferences!.getString(_keyLocation);
}
