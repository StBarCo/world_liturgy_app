import 'package:flutter/material.dart';

import 'json/xml_parser.dart';
import 'globals.dart' as globals;
import 'data/database.dart';
import 'app.dart';


void main() async{
  globals.allPrayerBooks = await loadPrayerBooks();
  globals.allSongBooks = await loadSongBooks();

  globals.db = new DatabaseClient();
  await globals.db.create();
  runApp(new MyApp());
}

