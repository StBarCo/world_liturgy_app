//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';

import 'shared_preferences.dart';
import 'pages/service.dart';
import 'pages/calendar.dart';
import 'pages/songs.dart';
import 'globals.dart' as globals;
import 'theme.dart';
import 'model/calendar.dart';
import 'pages/bible.dart';
import 'json/serializePrayerBook.dart';
import 'model/bible.dart';
import 'bibleParse/bible_reference.dart';

class MyApp extends StatelessWidget {
  MyApp();

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

class App extends StatefulWidget {


  App();

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Day currentDay;
  String currentLanguage;
  double textScaleFactor;
  List<String> initialBibleInfo;

  @override void initState() {
    super.initState();
    currentLanguage = SharedPreferencesHelper.getCurrentLanguage();
    textScaleFactor = SharedPreferencesHelper.getTextScaleFactor();
    initialBibleInfo = SharedPreferencesHelper.getCurrentBible();
    initializeCurrentLanguage();
    super.initState();

    getDayFromCalendar(DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day )).then((day) {
      setState(() {
        currentDay = day;
      });
//      print("success");
    }).catchError((error, stackTrace) {
      print("outer: $error");
    });


  }

  /// If textScaleFactor is null, then sets it based on device default.
  initializeTextScaleFactor() {
    if(textScaleFactor == null){
      double _initValue = MediaQuery.of(context).textScaleFactor;
      textScaleFactor = _initValue;
      SharedPreferencesHelper.setTextScaleFactor(_initValue);
    }
  }

  initializeCurrentLanguage() {
    if(currentLanguage == null){
      String _initValue = globals.allPrayerBooks.prayerBooks.first.language;
      currentLanguage = _initValue;
      SharedPreferencesHelper.setCurrentLanguage(_initValue);
    }
  }



  void updateValue({String newLanguage, Day newDay, double newTextScale}) {
    setState(() {
      if(newLanguage != null) {
        currentLanguage = newLanguage;
        SharedPreferencesHelper.setCurrentLanguage(newLanguage);
      }
      if (newDay != null){
        currentDay = newDay;
      }
      if(newTextScale != null){
        textScaleFactor = newTextScale;
        SharedPreferencesHelper.setTextScaleFactor(newTextScale);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeTextScaleFactor();


    return RefreshState(
        currentDay: currentDay,
        currentLanguage: currentLanguage,
        textScaleFactor: textScaleFactor,

        updateValue: updateValue,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
          child: Theme(
            data: updateTheme(Theme.of(context), currentDay),
            child: HomePage(currentLanguage, initialBibleInfo: initialBibleInfo),
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
    this.updateValue,
    Widget child,
  }) : super(key: key, child: child);

  final String currentLanguage;
  final Function updateValue;
  final Day currentDay;
  final double textScaleFactor;

  @override
  updateShouldNotify(RefreshState oldWidget) {
    return currentLanguage != oldWidget.currentLanguage || currentDay != oldWidget.currentDay;
  }

  static RefreshState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshState>();
  }
}

class HomePage extends StatefulWidget{
  final String initialLanguage;
  final List<String> initialBibleInfo;


  HomePage(this.initialLanguage, {this.initialBibleInfo, Key key}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final Key keyServices = PageStorageKey('pageKeyServices');
  final Key keySongs = PageStorageKey('pageKeySongs');
  final Key keyCalendar = PageStorageKey('pageKeyCalendar');
  final Key keyBible = PageStorageKey('pageKeyBible');

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
    PrayerBook  initialPB = _setInitialPrayerBook(globals.allPrayerBooks, widget.initialLanguage);
    Service initialService = _setInitialService(initialPB);
    Bible initialBible = initializeCurrentBible();
    BibleRef initialBibleReference = _setInitialBibleReference();

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
      bible: initialBible,
      ref: initialBibleReference,
      key: keyBible,
    );
    calendarPage = CalendarPage(
      key: keyCalendar,
    );

    pageOrder = ['services', 'songs', 'bible', 'calendar',];

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

        case 'bible':{
          pages.add(biblePage);
        }
        break;
      }
    });

    super.initState();

    currentPage = servicePage;
  }


  Future<bool> _exitApp(BuildContext context) {
    final currentLanguage = getLanguage(context);

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

  PrayerBook _setInitialPrayerBook(PrayerBooksContainer allPrayerBooks, [String language]){
    if(language != null) {
      return allPrayerBooks.getPrayerBook(language: language);
    } else {
      return allPrayerBooks.prayerBooks.first;
    }
  }
  Service _setInitialService(PrayerBook initialPB){
    String serviceId ='eveningWorship';
    int returnedIndex;
    if(DateTime.now().hour < 15){
      serviceId = 'morningWorship';
    }
    returnedIndex = initialPB.getServiceIndexById(serviceId);

    if (returnedIndex != -1){
      return initialPB.services[returnedIndex];
    }

    return initialPB.services.first;
  }

  Bible initializeCurrentBible(){
    if(widget.initialBibleInfo == null){
      SharedPreferencesHelper.setCurrentBible([globals.bibles.first.abbreviation, 'MAT', '1']);
      return globals.bibles.first;
    } else {
      return globals.bibles.firstWhere((Bible bible) => bible.abbreviation == widget.initialBibleInfo[0]);
    }
  }

  BibleRef _setInitialBibleReference(){
    List<String> info = SharedPreferencesHelper.getCurrentBible();
    return BibleRef(info[1], int.parse(info[2]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: new Scaffold (
        body: currentPage,
        bottomNavigationBar: _buildBottomNavBar(),
      ),
      onWillPop: () => _showExit(context),
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


Text appBarTitle(String title, context, [String shortTitle]){
  double maxLength = 25/MediaQuery.of(context).textScaleFactor;

  if(shortTitle != null && title.length >= (maxLength.floor() -1)){
    return Text(
      shortTitle,
      style: Theme.of(context).textTheme.headline6.copyWith(
        fontFamily: 'Signika',
        color: Theme.of(context).primaryIconTheme.color,
      ),
    );
  }

  return Text(
    title,
    style: Theme.of(context).textTheme.headline6.copyWith(
      fontFamily: 'Signika',
      color: Theme.of(context).primaryIconTheme.color,
    ),
  );

}

ThemeData updateTheme(ThemeData theme, Day day){
  String color = day != null ? getColorDeJour(day)?.toLowerCase() : 'white';

//  return baseTheme(theme, color);
  return baseThemeSwatch(theme, color);
}

String getColorDeJour(Day day){
  String c;

//  if it is a principal day -- make color

//  else if day is not a sunday in advent, lent or easter then the holy day color is ok

//  else season color or green.

  if(day.isHolyDay()) {
    c =  day.principalDay()?.color;

//    if no principal day
    if(c == null && !(day.date.weekday == 7 && ['advent', 'lent', 'easter'].contains(day.season.id))) {
      c= day.nonPrincipalDays()?.first?.color;
    }
  }
  c ??= day.season?.color ?? 'green';
  return c;
}

//DayOBSOLETE getDay(context){
//  return RefreshState.of(context).currentDay;
//}

Day getDay(context){
  return RefreshState.of(context).currentDay;
}


String getLanguage(context){
  return RefreshState.of(context).currentLanguage;
}