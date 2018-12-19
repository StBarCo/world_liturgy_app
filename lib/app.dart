import 'package:flutter/material.dart';

import 'pages/service.dart';
import 'pages/calendar.dart';
import 'pages/songs.dart';
import 'globals.dart' as globals;
import 'theme.dart';
import 'dart:async';
import 'model/calendar.dart';
import 'pages/bible.dart';
import 'json/serializePrayerBook.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: globals.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'WorkSans',
      ),
      home: App(),
      showPerformanceOverlay: false,
      debugShowMaterialGrid: false,

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
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final Key keyServices = PageStorageKey('pageKeyServices');
  final Key keySongs = PageStorageKey('pageKeySongs');
  final Key keyCalendar = PageStorageKey('pageKeyCalendar');
  final Key keyBible = PageStorageKey('keyBible');

  int currentTab = 0;
  ServicePage servicePage;
  SongsPage songPage;
  CalendarPage calendarPage;
  BiblePage biblePage;
  List<Widget> pages = [];
  List<String> pageOrder;
  Widget currentPage;
  

  @override
  void initState(){
    PrayerBook  initialPB = _setInitialPrayerBook(globals.allPrayerBooks);
    Service initialService = _setInitialService(initialPB);

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

    biblePage = BiblePage(
      key: keyBible,
    );
    calendarPage = CalendarPage(
      key: keyCalendar,
    );

    pageOrder = ['services', 'songs', 'calendar'];

    pageOrder.forEach((page){
      switch(page){
        case 'services': {
          pages.add(servicePage);
        }
        break;

        case 'songs': {
          pages.add(songPage);
        }
        break;

        case 'calendar':{
          pages.add(calendarPage);
        }
        break;

        case 'biblePage':{
          pages.add(biblePage);
        }
        break;
      }
    });

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

  changeTab(newTabName){
    int newTab = pageOrder.indexOf(newTabName);
    if(currentTab != newTab){
      setState(() {        
        currentTab = newTab;
        currentPage = pages[newTab];
      });
    }
  }

  PrayerBook _setInitialPrayerBook(PrayerBooksContainer allPrayerBooks){
//    TODO: if there are default settings, use those.
    return allPrayerBooks.prayerBooks[0];

  }
  Service _setInitialService(PrayerBook initialPB){
    String serviceId ='eveningWorship';
    int returnedIndex;
    if(DateTime.now().hour < 12){
      serviceId = 'morningWorship';
    }
    returnedIndex = initialPB.getServiceIndexById(serviceId);

    if (returnedIndex != -1){
      return initialPB.services[returnedIndex];
    }

    return initialPB.services.first;
  }

  @override
  Widget build(BuildContext context) {
    return new MyInheritedWidget(
      child: new WillPopScope(
        child: new Scaffold (
          body: currentPage,
          bottomNavigationBar: _buildBottomNavBar(),
        ),
        onWillPop: () => _showExit(context),
      ),
    );
  }

  BottomNavigationBar  _buildBottomNavBar() {
    final languageState = RefreshState.of(context);
    final currentLanguage = languageState.currentLanguage;
    return BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: makeBottomNavItems(pageOrder, currentLanguage)
    );
  }

  List<BottomNavigationBarItem> makeBottomNavItems(pageList, currentLanguage){
    List<BottomNavigationBarItem> list = [];
    pageList.forEach((page){
      switch(page){
        case 'services': {
          list.add(BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.black38,),
            activeIcon: Icon(Icons.home,color: Theme.of(context).primaryColor,),
            title: Text(
              globals.translate(currentLanguage, 'prayerBook'),style: TextStyle(color: Theme.of(context).primaryColor),),
          ));
        }
        break;

        case 'songs': {
          list.add(BottomNavigationBarItem(
            icon: Icon(Icons.music_note,color: Colors.black38,),
            activeIcon: Icon(Icons.music_note,color: Theme.of(context).primaryColor,),
            title: Text(globals.translate(currentLanguage, 'songs'),style: TextStyle(color: Theme.of(context).primaryColor),),
          ));
        }
        break;

        case 'bible':{
          list.add(BottomNavigationBarItem(
            icon: Icon(Icons.book,color: Colors.black38,),
            activeIcon: Icon(Icons.book,color: Theme.of(context).primaryColor,),
            title: Text(globals.translate(currentLanguage, 'bible'),style: TextStyle(color: Theme.of(context).primaryColor),),
          ));
        }
        break;

        case 'calendar':{
          list.add(BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today,color: Colors.black38,),
            activeIcon: Icon(Icons.calendar_today,color: Theme.of(context).primaryColor,),
            title: Text(globals.translate(currentLanguage, 'calendar'),style: TextStyle(color: Theme.of(context).primaryColor),),
          ));
        }
        break;
      }
    });
    return list;
  }

}



class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  String currentLanguage = globals.allPrayerBooks.prayerBooks[0].language;
  Day currentDay;
  double textScaleFactor;

  @override void initState() {    // TODO: implement initState
    super.initState();
    setDay(DateTime.now()).then((day){
      setState(() {
        currentDay = day;
      });
    });
  }

  void onTap({String newLanguage, Day newDay, double newTextScale}) {
    setState(() {
      if(newLanguage != null) {
        currentLanguage = newLanguage;
      }
      if (newDay != null){
        currentDay = newDay;
      }
      if(newTextScale != null){
        textScaleFactor = newTextScale;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = textScaleFactor ?? MediaQuery.of(context).textScaleFactor;

    return RefreshState(
      currentDay: currentDay,
      currentLanguage: currentLanguage,
      textScaleFactor: textScaleFactor,
      onTap: onTap,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
        child: Theme(
          data: updateTheme(Theme.of(context), currentDay),
          child: HomePage(),
        ),
      )
    );
  }
}

class RefreshState extends InheritedWidget {
  RefreshState({
    Key key,
    this.currentLanguage,
    this.currentDay,
    this.textScaleFactor,
    this.onTap,
    Widget child,
  }) : super(key: key, child: child);

  final String currentLanguage;
  final Function onTap;
  final Day currentDay;
  final double textScaleFactor;

  @override
  updateShouldNotify(RefreshState oldWidget) {
    return currentLanguage != oldWidget.currentLanguage || currentDay != oldWidget.currentDay;
  }

  static RefreshState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(RefreshState);
  }
}

Widget appBarTitle(String title, context, [String shortTitle]){
  double maxLength = 25/MediaQuery.of(context).textScaleFactor;

  if(shortTitle != null && title.length >= (maxLength.floor() -1)){
    return Text(
      shortTitle,
      style: Theme.of(context).textTheme.title.copyWith(
        fontFamily: 'Signika',
        color: Theme.of(context).primaryIconTheme.color,
      ),
    );
  }

  return Text(
    title,
    style: Theme.of(context).textTheme.title.copyWith(
      fontFamily: 'Signika',
      color: Theme.of(context).primaryIconTheme.color,
    ),
  );

}

ThemeData updateTheme(ThemeData theme, Day day){
  String color = day != null ? getColorDeJour(day)?.toLowerCase() : 'green';

//  return baseTheme(theme, color);
  return baseThemeSwatch(theme, color);
}

String getColorDeJour(Day day){
  switch(celebrationPriority(day).first){
    case 'holyDay':{
      return day.holyDayColor;
    }
    break;

    case 'principalFeast':{
      return day.principalColor;
    }
    break;

    case 'season':{
      return day.seasonColor;
    }
    break;
  }
  return 'green';
}

Day getDay(context){
  return RefreshState.of(context).currentDay;
}

String getLanguage(context){
  return RefreshState.of(context).currentLanguage;
}