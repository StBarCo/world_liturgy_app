import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_liturgy_app/data/prayer_book_settings.dart';

import 'json/xml_parser.dart';
import 'globals.dart' as globals;
import 'data/database.dart';
import 'app.dart';
import 'shared_preferences.dart';
import 'data/bible_settings.dart';
import 'data/song_settings.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  globals.preferences = await SharedPreferences.getInstance();
  globals.allPrayerBooks = await loadPrayerBooks();
//  globals.allSongBooks = await loadSongBooks();
  globals.allSongBooks = initializeSongBooks();
  globals.bibles = initializeBibles();
  globals.db = new DatabaseClient();
  await globals.db.create();
  String _initialLanguage = await SharedPreferencesHelper.getCurrentLanguage();
  double _initialTextScaleFactor = await SharedPreferencesHelper.getTextScaleFactor();
  String _initialBible = await SharedPreferencesHelper.getCurrentBible();
  SharedPreferencesHelper.createFavoritesIfEmpty(initialFavoriteServices);
  runApp(new MyApp(_initialLanguage, _initialTextScaleFactor, _initialBible));
}










