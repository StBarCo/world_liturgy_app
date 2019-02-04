import 'dart:async';
import 'globals.dart' as globals;

class SharedPreferencesHelper {

  static Future<double> getTextScaleFactor() async {
    return globals.preferences.getDouble('textScaleFactor');
  }

  static Future<bool> setTextScaleFactor(double value) async {
    return globals.preferences.setDouble('textScaleFactor', value);
  }

  static Future<String> getCurrentLanguage() async {
    return globals.preferences.getString('currentLanguage');
  }

  static Future<bool> setCurrentLanguage(String value) async {
    return globals.preferences.setString('currentLanguage', value);
  }

  static Future<bool> setCurrentBible(String value) async {
    return globals.preferences.setString('currentBible', value);
  }

  static Future<String> getCurrentBible() async {
    return globals.preferences.getString('currentBible');
  }

}