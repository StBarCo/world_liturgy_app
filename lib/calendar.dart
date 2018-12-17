import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

import 'globals.dart' as globals;
import 'model/calendar.dart';
import 'app.dart';
import 'collects.dart';
import 'json/serializePrayerBook.dart';

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
        title: new Text('Lectionary'),
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
            Column(
              children: dayTitles(globals.allPrayerBooks.getPrayerBookIdFromLanguage(currentLanguage), context),
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

dayAndLinkToCalendar(currentIndexes, context){
  if (getDay(context) != null){
    return GestureDetector(
//      onPressed: null,
      onTap: () => context.ancestorStateOfType(const TypeMatcher<HomePageState>()).changeTab('calendar'),
      child: Column(
        children: dayTitles(currentIndexes["prayerBook"], context)
      )
    );

//    return Text(dateToLongString(day, language));
  } else {
//    return Text('Date Is Null');
  }
}

List<Widget> dayTitles(prayerBookId, context){
  List<Widget> list = [Text(dateToLongString(getDay(context), getLanguage(context)), style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).primaryColorDark))];

  list.add(collectList(prayerBookId, context, buildType: 'titles'));

  return list;
}



List<String> celebrationPriority(Day day){
  List<String> priority = [];
  if(day.principalFeastID != null){
    priority.add('principalFeast');
  }
  if(day.holyDayID != null){
    if(day.date.weekday == 7){
      priority.add('holyDay');
    } else {
      priority.add('holyDay');
    }
  }
  priority.add('season');



  return priority;
}

List<String> getDailyReadings(String lectionaryType, String readingType, context){
  Day day = getDay(context);
  List<String> readings = [];

  if(readingType.toLowerCase() == 'ot'){
    readings.add('Ez 15:1-8');
  } else if(readingType.toLowerCase() == 'nt'){
    readings.add('Eph 2:1-10');
  }else if(readingType.toLowerCase() == 'psalm'){
    readings.add('Ps 119:89-104');
  }else if(readingType.toLowerCase() == 'gospel'){
    readings.add('John 8:31-59');
  }else if(readingType.toLowerCase() == 'otornt'){
    readings.add('Ez 15:1-8');
    readings.add('Eph 2:1-10');
    readings.add('John 8:31-59');
  }

  return readings;
}