import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/app.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class CalendarPage extends StatefulWidget{
  CalendarPage({Key key}) : super(key:key);

  @override
  _CalendarPageState createState() {
    return new _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  String currentLanguage;
  Day currentDay;

  _CalendarPageState();

  void handleNewDate(date) {
    setDay(date).then((day) {
      RefreshState.of(context).onTap(
          newDay: day
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final refreshState = RefreshState.of(context);
    currentLanguage = refreshState.currentLanguage;
    currentDay = refreshState.currentDay;


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Calendar'),
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Calendar(
              initialCalendarDateOverride: currentDay.date,
              onDateSelected: (date) => handleNewDate(date),
              isExpandable: true,
            ),



          ],
        ),
      ),

    );
  }
}

setDay(DateTime day) {
  return globals.db.fetchDay(constructDaysSince(day));
}

dateToLongString(date, language){
  Map map = globals.translationMap[language]['dates'];
  List format = map['format'];
  String longDate ='';

  format.forEach((e){
    switch(e){
      case 'weekday': {longDate += map[e][date.date.weekday].toString();}
      break;

      case 'day': {longDate += date.date.day.toString(); }
      break;

      case 'month': {longDate += map[e][date.date.month].toString();}
      break;

      case 'year': {longDate += date.date.year.toString(); }
      break;

      default: {longDate += e.toString();}
    }
  });
  return longDate;
}

dateAndLinkToCalendar(day, language, context){
//  return FutureBuilder(
//    future: day,
//    builder: (context, snapshot){
//      if(snapshot.hasData){
//        return Text(dateToLongString(day, language));
//      }else {
//      return Text('Date Not Yet Loaded');
//      }
//
//    },
//  );
      if (day != null){
      return Text(dateToLongString(day, language));
    } else {
      return Text('Date Is Null');
    }
}

//class DateAndLinkToCalendar() extends StatefulWidget {
//  const DateAndLinkToCalendar({
//    Key key,
//    this.day,
//  }) : super(key: key);
//
//  final String day;
//
//  @override
//  _DateAndLinkToCalendarState createState() => new _DateAndLinkToCalendarState();
//}
//
//class _DateAndLinkToCalendarState extends State<DateAndLinkToCalendar> {
//  Day day;
//  String language;
//
//  _DateAndLinkToCalendarState() {
//    checkForCurrentDay();
//    day = globals.currentDay;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final languageState = RefreshState.of(context);
//    language = languageState.currentLanguage;
//
//    if (day != null){
//      return Text(dateToLongString(day, language));
//    } else {
//      return Text('');
//    }
//
//  }
//
//}
