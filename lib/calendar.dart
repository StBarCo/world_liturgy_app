import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
//import 'dart:async';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/service.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem({
    Key key,
    this.buildType,
    this.currentPrayerBookIndex,
  }) : super(key: key);

  final String buildType;
  final String currentPrayerBookIndex;


  @override
  _CalendarItemState createState() => new _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  Collect collectOfWeek;
  Collect collectOfPrincipalFeast;
  Collect collectOfHolyDay;
  Day day;

  _CalendarItemState() {
    checkForCurrentDay();
    day = globals.currentDay;
  }


  @override
  Widget build(BuildContext context) {
    collectOfWeek = setCollectOfWeek(day, widget.currentPrayerBookIndex);
    collectOfPrincipalFeast = setCollectOfPrincipalFeast(day, widget.currentPrayerBookIndex);
    collectOfHolyDay = setCollectOfHolyDay(day, widget.currentPrayerBookIndex);

    if (collectOfWeek == null) {
      return new Text('');
    }

    return new Column(
        children: buildCalendarItemList(context),
    );

  }

  List<Widget> buildCalendarItemList(context){
    List<Widget> list = [];

    if(collectOfPrincipalFeast != null && hasContentToBuild(collectOfPrincipalFeast, widget.buildType) ) {
      list.add(buildDailyPrayers(collectOfPrincipalFeast,
          getLanguageFromIndex(widget.currentPrayerBookIndex),
          widget.buildType));
    }

    if(collectOfWeek != null && day.date.weekday == 7 && hasContentToBuild(collectOfWeek, widget.buildType)) {
      list.add(buildDailyPrayers(collectOfWeek,
          getLanguageFromIndex(widget.currentPrayerBookIndex),
          widget.buildType));
    }

    if(collectOfHolyDay != null && hasContentToBuild(collectOfHolyDay, widget.buildType)) {
      list.add(buildDailyPrayers(collectOfHolyDay,
          getLanguageFromIndex(widget.currentPrayerBookIndex),
          widget.buildType));
    }

    if(collectOfWeek != null && day.date.weekday != 7 && hasContentToBuild(collectOfWeek, widget.buildType)) {
      list.add(buildDailyPrayers(collectOfWeek,
          getLanguageFromIndex(widget.currentPrayerBookIndex),
          widget.buildType));
    }

    return list;
  }

}

setInitialDay() async{
  var today = DateTime.now();
  Day day = await globals.db.fetchDay(constructDaysSince(today));
  globals.currentDay = day;
}

checkForCurrentDay() {
  if (globals.currentDay == null){
    setInitialDay();
  }
}

Collect setCollectOfWeek(day, prayerBookId){
  if(day != null && day.weekID != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.weekServiceIndex].sections[day.weekSectionIndex].collects[day.weekCollectIndex];
  } else {
    return null;
  }
}

Collect setCollectOfPrincipalFeast(day, prayerBookId){
  if(day != null && day.principalFeastID != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.principalFeastServiceIndex].sections[day.principalFeastSectionIndex].collects[day.principalFeastCollectIndex];
  } else {
    return null;
  }
}

Collect setCollectOfHolyDay(day, prayerBookId){
  if(day != null && day.holyDayID != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.holyDayServiceIndex].sections[day.holyDaySectionIndex].collects[day.holyDayCollectIndex];
  } else {
    return null;
  }
}

bool hasContentToBuild(Collect collect, buildType){
  switch (buildType){
    case "full" :{
      return true;
    }
    break;

    case 'collect': {
      return collect.collectPrayers !=null;
    }
    break;

    case 'postCommunion':{
      return collect.postCommunionPrayers != null;
    }
    break;
  }
  return false;


}
