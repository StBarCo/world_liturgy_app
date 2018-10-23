import 'package:flutter/material.dart';
import 'package:world_liturgy_app/service.dart';
import 'package:world_liturgy_app/calendar.dart';
import 'package:world_liturgy_app/songs.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/colors.dart';
import 'dart:async';
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:marquee/marquee.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'World Liturgy App',
      theme: baseTheme,
      home: App(),
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
  /// Default language name
  String currentLanguage = 'en_ke';

  /// Getter (number of items)
  String get getLanguage => currentLanguage;

  /// Helper method to add an Item
//  void changeLanguage(String newLanguage){
//    if(currentLanguage != newLanguage) {
//      setState(() {
//        currentLanguage = newLanguage;
//      });
//    }
//  }

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
  final Key keyCalendar = PageStorageKey('pageKeyCalendar');
//  final Key keyBible = PageStorageKey('keyBible');

  int currentTab = 0;
  double textScaleFactor = 1.0;
  ServicePage servicePage;
  SongsPage songPage;
  CalendarPage calendarPage;
//  BiblePage biblePage;
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

    calendarPage = CalendarPage(
      key: keyCalendar,
    );

//    biblePage = BiblePage(
//      key: keyBible,
//    );

    pages = [servicePage,songPage, calendarPage];
    super.initState();

    currentPage = servicePage;
  }


  Future<bool> _exitApp(BuildContext context) {
    final languageState = RefreshState.of(context);
    final currentLanguage = languageState.currentLanguage;

    return showDialog(
      context: context,


      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    ) ??
        false;

  }

  _showExit(BuildContext context) {
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
    return new MyInheritedWidget(
      child: new WillPopScope(
        child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: textScaleFactor,
            ),
            child: new Scaffold (
              body: currentPage,
              bottomNavigationBar: _buildBottomNavBar(),
            ),
        ),
        onWillPop: () => _showExit(context),
      ),
    );
  }

  BottomNavigationBar  _buildBottomNavBar() {
    final languageState = RefreshState.of(context);
    final currentLanguage = languageState.currentLanguage;
    return BottomNavigationBar(
        fixedColor: kSecondaryLight,

        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        //        as of flutter 5.1 when navbar has >3 items type becomes shifting and text color is white
        type: BottomNavigationBarType.fixed,

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
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text(globals.translate(currentLanguage, 'lectionary')),
          ),
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
  Day currentDay;

  @override void initState() {    // TODO: implement initState
    super.initState();
    setDay(DateTime.now()).then((day){
      setState(() {
        currentDay = day;
      });
    });
  }

  void onTap({String newLanguage, Day newDay}) {
    setState(() {
      if(newLanguage != null) {
        currentLanguage = newLanguage;
      }
      if (newDay != null){
        currentDay = newDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshState(
      currentDay: currentDay,
      currentLanguage: currentLanguage,
      onTap: onTap,
      child: HomePage(),
    );
  }
}

class RefreshState extends InheritedWidget {
  RefreshState({
    Key key,
    this.currentLanguage,
    this.currentDay,
    this.onTap,
    Widget child,
  }) : super(key: key, child: child);

  final String currentLanguage;
  final Function onTap;
  final Day currentDay;

  @override
  bool updateShouldNotify(RefreshState oldWidget) {
    return currentLanguage != oldWidget.currentLanguage || currentDay != oldWidget.currentDay;
  }

  static RefreshState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(RefreshState);
  }
}

Widget appBarTitle(title, context){
  Widget titleText = Text(
      title,//    FORMATTING WILL GO HERE
  );

  if(title.length > 20){
    return Marquee(
      child: Center(
        child: titleText,
      ),
      blankSpace: 20.0,
      velocity: 5.0,
    );
  } else {
    return titleText;
  }
}


