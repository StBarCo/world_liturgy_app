import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/prayer_book_settings.dart';

import 'json/xml_parser.dart';
import 'globals.dart' as globals;
import 'app.dart';
import 'shared_preferences.dart';
import 'data/bible_settings.dart';
import 'data/song_settings.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  globals.preferences = await SharedPreferences.getInstance();

  globals.allPrayerBooks = await loadPrayerBooks();
  globals.allSongBooks = initializeSongBooks();
  globals.bibles = initializeBibles();


  SharedPreferencesHelper.createFavoritesIfEmpty(initialFavoriteServices);
  runApp(MyApp());
}










