import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'json/xml_parser.dart';
import 'globals.dart' as globals;
import 'data/database.dart';
import 'app.dart';
import 'shared_preferences.dart';


void main() async{
  globals.preferences = await SharedPreferences.getInstance();
  globals.allPrayerBooks = await loadPrayerBooks();
  globals.allSongBooks = await loadSongBooks();
  globals.db = new DatabaseClient();
  await globals.db.create();
  String _initialLanguage = await SharedPreferencesHelper.getCurrentLanguage();
  double _initialTextScaleFactor = await SharedPreferencesHelper.getTextScaleFactor();
  runApp(new MyApp(_initialLanguage, _initialTextScaleFactor));
}


