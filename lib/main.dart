import 'package:flutter/material.dart';
import 'service.dart';
import 'data/xml_parser.dart';
import 'globals.dart' as globals;
//import 'dart:async';
//import 'json/serializePrayerBook.dart';


void main() async {
  final allPrayerBooks = await loadXml();
  globals.allPrayerBooks = allPrayerBooks;
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
      home: ServiceView(currentService: globals.allPrayerBooks.prayerBooks[0].services[0], currentIndexes: {"prayerBook": globals.allPrayerBooks.prayerBooks[0].id, "service": globals.allPrayerBooks.prayerBooks[0].services[0].id}),
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
