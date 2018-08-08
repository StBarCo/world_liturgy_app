import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/xml_parser.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/data/database.dart';
import 'package:world_liturgy_app/app.dart';


void main() async{
  globals.allPrayerBooks = await loadPrayerBooks();
  globals.allSongBooks = await loadSongBooks();

  globals.db = new DatabaseClient();
  await globals.db.create();
  runApp(new MyApp());
}

