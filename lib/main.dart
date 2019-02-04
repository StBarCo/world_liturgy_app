import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'json/xml_parser.dart';
import 'globals.dart' as globals;
import 'data/database.dart';
import 'app.dart';
import 'shared_preferences.dart';
//import 'bibleParse/bible_format.dart';
import 'bibleParse/formats/usx.dart';
import 'model/bible.dart';


void main() async{
  globals.preferences = await SharedPreferences.getInstance();
  globals.allPrayerBooks = await loadPrayerBooks();
  globals.allSongBooks = await loadSongBooks();
  globals.bibles = _initializeBibles();
  globals.db = new DatabaseClient();
  await globals.db.create();
  String _initialLanguage = await SharedPreferencesHelper.getCurrentLanguage();
  double _initialTextScaleFactor = await SharedPreferencesHelper.getTextScaleFactor();
  String _initialBible = await SharedPreferencesHelper.getCurrentBible();
  runApp(new MyApp(_initialLanguage, _initialTextScaleFactor, _initialBible));
}

List<Bible> _initializeBibles(){
  return [
    Bible(
      abbreviation: 'WEB',
      title:'World English Bible',
      language: 'en_ke',
      bibleFormat: USXBible(
        path: 'assets/bibles/WEB',
        publicationID: 'p4'
      )
    )
  ];
}






