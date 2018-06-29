import 'package:flutter/material.dart';
import 'package:world_liturgy_app/service.dart';
import 'package:world_liturgy_app/json/xml_parser.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'json/serializeCalendar.dart';
//import 'dart:async';
//import 'json/serializePrayerBook.dart';
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/data/database.dart';
import 'package:sqflite/sqflite.dart';


void main() async{

  globals.allPrayerBooks = await loadPrayerBooks();

  globals.db = new DatabaseClient();
  await globals.db.create();
  runApp(new MyApp());


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'World Liturgy App',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.green,
//        primaryColor: Colors.white,
//
      ),

//      home:Calendar(),
      home: ServiceView(
          currentService: globals.allPrayerBooks.prayerBooks[0].services[0],
          currentIndexes: {"prayerBook": globals.allPrayerBooks.prayerBooks[0].id, "service": globals.allPrayerBooks.prayerBooks[0].services[0].id}
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}




