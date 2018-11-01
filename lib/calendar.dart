import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/app.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:world_liturgy_app/collects.dart';

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

dayAndLinkToCalendar(day, language, context){
  if (day != null){
    return GestureDetector(
//      onPressed: null,
      onTap: () => context.ancestorStateOfType(const TypeMatcher<HomePageState>()).changeTab(2),
      child: Column(
        children: dayTitles(day, language, context)
      )
    );

//    return Text(dateToLongString(day, language));
  } else {
    return Text('Date Is Null');
  }
}

List<Widget> dayTitles(day, language, context){
  List<Widget> list = [Text(dateToLongString(day, language))];

  celebrationPriority(day).forEach((type){
    list.add(Text(type.toString()));
  });

  list.add(collectList("englishPrayerBook",day,language, context, buildType: 'titles'));

  return list;

}

List<String> celebrationPriority(Day day){
  List<String> priority = ['season'];

  if(day.holyDayID != null){
    if(day.date.weekday == 7){
      priority.add('holyDay');
    } else {
      priority.insert(0, 'holyDay');
    }
  }

  if(day.principalFeastID != null){
    priority.insert(0, 'principalFeast');
  }

  return priority;
}
