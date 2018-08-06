import 'package:flutter/material.dart';
import 'package:world_liturgy_app/service.dart';
import 'package:world_liturgy_app/calendar.dart';
import 'package:world_liturgy_app/songs.dart';
import 'package:world_liturgy_app/json/xml_parser.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/data/database.dart';
import 'dart:async';


void main() async{

  globals.allPrayerBooks = await loadPrayerBooks();
  globals.allSongBooks = await loadSongBooks();

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
      home: HomePage(
//          currentService: globals.allPrayerBooks.prayerBooks[0].services[0],

          ),
    );
  }
}


class HomePage extends StatefulWidget{

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Key keyServices = PageStorageKey('pageKeyServices');
  final Key keySongs = PageStorageKey('pageKeySongs');

  int currentTab = 0;

  ServicePage servicePage;
  SongsPage songPage;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState(){
    servicePage = ServicePage(
        initialCurrentIndexes: {
          "prayerBook": globals.allPrayerBooks.prayerBooks[0].id,
          "service": globals.allPrayerBooks.prayerBooks[0].services[0].id
        },
        key: keyServices,
    );
    songPage = SongsPage(
      key: keySongs,
    );

    pages = [servicePage,songPage];
    super.initState();

    currentPage = servicePage;
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
      context: context,

      child: new AlertDialog(
        title: new Text('Do you want to exit this application?'),
        content: new Text('We hate to see you leave...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<bool> _showExit(BuildContext context) {
    if (currentTab != 0) {
      setState((){
        currentTab = 0;
        currentPage = pages[0];
      });
    } else
      return _exitApp(context);
  }


//    if (currentTab != 0){

//    } else {
//      false;
//    }
//  }


  @override
  Widget build(BuildContext context) {
    checkForCurrentDay();

    return new WillPopScope(
      onWillPop: () => _showExit(context),
      child:  new Scaffold (

      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index){
          setState((){
            currentTab = index;
            currentPage = pages[index];
          });
        },

//        as of flutter 5.1 when navbar has >3 items type becomes shifting and text color is white
//        type: BottomNavigationBarType.fixed,

          items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Prayer Book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text('Songs'),
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.book),
//            title: Text('Bible'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.calendar_today),
//            title: Text('Lectionary'),
//          ),
        ]
      ),
    )
    );
  }
}







