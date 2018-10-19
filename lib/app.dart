import 'package:flutter/material.dart';
import 'package:world_liturgy_app/service.dart';
import 'package:world_liturgy_app/calendar.dart';
import 'package:world_liturgy_app/songs.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'dart:async';




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
        fontFamily: 'WorkSans',
//        primaryColor: Colors.white,
//
      ),

//      home:Calendar(),
      home: App(
//          currentService: globals.allPrayerBooks.prayerBooks[0].services[0],

          ),
    );
  }
}


class _MyInherited extends InheritedWidget {
  _MyInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final MyInheritedWidgetState data;

  @override
  bool updateShouldNotify(_MyInherited oldWidget) {
    return true;
  }
}

class MyInheritedWidget extends StatefulWidget {
  MyInheritedWidget({
    Key key,
    this.child,
  }): super(key: key);

  final Widget child;

  @override
  MyInheritedWidgetState createState() => new MyInheritedWidgetState();

  static MyInheritedWidgetState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }
}

class MyInheritedWidgetState extends State<MyInheritedWidget>{
  /// List of Items
  String currentLanguage = 'en_ke';

  /// Getter (number of items)
  String get getLanguage => currentLanguage;

  /// Helper method to add an Item
  void changeLanguage(String newLanguage){
    if(currentLanguage != newLanguage) {
      setState(() {
        currentLanguage = newLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return new _MyInherited(
      data: this,
      child: widget.child,
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
    var  initialPB = globals.allPrayerBooks.prayerBooks[0];
    var initialService = initialPB.services[0];

    servicePage = ServicePage(
        initialCurrentIndexes: {
          "prayerBook": initialPB.id,
          "service": initialService.id
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
    final languageState = LanguageState.of(context);
    final currentLanguage = languageState.currentLanguage;

    return showDialog(
      context: context,

      child: new AlertDialog(
        title: new Text(globals.translate(currentLanguage, 'exitMessage')),
//        content: new Text('We hate to see you leave...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(globals.translate(currentLanguage, 'no')),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(globals.translate(currentLanguage, 'yes')),
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
//      false;
    } else
      return _exitApp(context);
  }

  @override
  Widget build(BuildContext context) {
    checkForCurrentDay();
    return new MyInheritedWidget(
      child: new WillPopScope(
        child:  new Scaffold (
          body: currentPage,
          bottomNavigationBar: _buildBottomNavBar(),
        ),
        onWillPop: () => _showExit(context),
      ),
    );
  }

  BottomNavigationBar  _buildBottomNavBar() {
    final languageState = LanguageState.of(context);
    final currentLanguage = languageState.currentLanguage;
    return BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },

        //        as of flutter 5.1 when navbar has >3 items type becomes shifting and text color is white
        //        type: BottomNavigationBarType.fixed,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
                globals.translate(currentLanguage, 'prayerBook')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text(globals.translate(currentLanguage, 'songs')),
          ),
          //          BottomNavigationBarItem(
          //            icon: Icon(Icons.book),
          //            title: Text(globals.translate(globals.currentLanguage, 'bible')),
          //          ),
          //          BottomNavigationBarItem(
          //            icon: Icon(Icons.calendar_today),
          //            title: Text(globals.translate(globals.currentLanguage, 'lectionary')),
          //          ),
        ]
    );

  }
}



class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  String currentLanguage = globals.allPrayerBooks.prayerBooks[0].language;

  void onTap(String newLanguage) {
    setState(() {
      currentLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LanguageState(
      currentLanguage: currentLanguage,
      onTap: onTap,
      child: HomePage(),
    );
  }
}

class LanguageState extends InheritedWidget {
  LanguageState({
    Key key,
    this.currentLanguage,
    this.onTap,
    Widget child,
  }) : super(key: key, child: child);

  final String currentLanguage;
  final Function onTap;

  @override
  bool updateShouldNotify(LanguageState oldWidget) {
    return currentLanguage != oldWidget.currentLanguage;
  }

  static LanguageState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(LanguageState);
  }
}




