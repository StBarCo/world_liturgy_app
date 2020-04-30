import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

import '../globals.dart' as globals;
import '../model/calendar.dart';
import '../app.dart';
import '../parts/section.dart';
//import '../parts/collects.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  String currentLanguage;
  Day currentDay;

  _CalendarPageState();

  void handleNewDate(date) {
    setDay(date).then((day) {
      RefreshState.of(context).updateValue(newDay: day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final refreshState = RefreshState.of(context);
    currentLanguage = refreshState.currentLanguage;
    currentDay = refreshState.currentDay;

    return Scaffold(
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        title: appBarTitle(globals.translate(getLanguage(context), 'calendar'), context),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Calendar(
              initialCalendarDateOverride: currentDay.date,
              onDateSelected: (date) => handleNewDate(date),
//              isExpandable: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: dayTitles(
                    globals.allPrayerBooks
                        .getPrayerBookIdFromLanguage(currentLanguage),
                    context),
              ),
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

dateToLongString(date, language) {
  Map map = globals.translationMap[language]['dates'];
  List format = map['format'];
  String longDate = '';

  format.forEach((e) {
    switch (e) {
      case 'weekday':
        {
          longDate += map[e][date.date.weekday].toString();
        }
        break;

      case 'day':
        {
          longDate += date.date.day.toString();
        }
        break;

      case 'month':
        {
          longDate += map[e][date.date.month].toString();
        }
        break;

      case 'year':
        {
          longDate += date.date.year.toString();
        }
        break;

      default:
        {
          longDate += e.toString();
        }
    }
  });
  return longDate;
}

dayAndLinkToCalendar(currentIndexes, context) {
  if (getDay(context) != null) {
    return Card(
        margin: EdgeInsets.only(bottom: 8.0),
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: GestureDetector(
              onTap: () => context
                  .ancestorStateOfType(HomePageState())
                  .changeTab('calendar'),
              child: Column(
                  children: dayTitles(currentIndexes["prayerBook"], context))),
        ));

//    return Text(dateToLongString(day, language));
  } else {
//    return Text('Date Is Null');
  }
}

List<Widget> dayTitles(prayerBookId, context) {
  return [
    Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(dateToLongString(getDay(context), getLanguage(context)),
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).primaryColorDark), textAlign: TextAlign.center,),
    ),
    CollectContent(prayerBookId, 'titles')
  ];
}

List<String> celebrationPriority(Day day) {
  List<String> priority = [];
  if (day.principalFeastID != null) {
    priority.add('principalFeast');
  }
  if (day.holyDayID != null) {
    if (day.date.weekday == 7) {
      priority.add('holyDay');
    } else {
      priority.add('holyDay');
    }
  }
  priority.add('season');

  return priority;
}

List<String> getDailyReadings(
    String lectionaryType, String readingType, context) {
//  Day day = getDay(context);
  List<String> readings = [];

  if (readingType.toLowerCase() == 'ot') {
    readings.add('Ez 15:1-8');
  } else if (readingType.toLowerCase() == 'nt') {
    readings.add('Eph 2:1-10');
  } else if (readingType.toLowerCase() == 'psalm') {
    readings.add('Ps 119:89-104');
  } else if (readingType.toLowerCase() == 'gospel') {
    readings.add('John 8:31-59');
  } else if (readingType.toLowerCase() == 'otornt') {
    readings.add('Ez 15:1-8');
    readings.add('Eph 2:1-10');
    readings.add('John 8:31-59');
  }

  return readings;
}
