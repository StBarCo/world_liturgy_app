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

    if (collectOfWeek == null) {
      return new Text('');
    }

    return new Column(
        children: buildCalendarItemList(collectOfWeek),
    );

  }

  List<Widget> buildCalendarItemList(collect){
    List<Widget> list = [];
    switch (widget.buildType){
      case "collect":{
        list.add(new Text(collect.title));
        list.add(new Text(collect.subtitle));
//          new Text(collect.collectRubric),
//        list.add(buildItem(collect.collectPrayers[0]));

        if (collect.collectPrayers[0].type == 'versedStanzas') {
          list.add( stanzasColumn(collect.collectPrayers[0]));
        } else if (collect.collectPrayers[0].type == 'stanzas' ){
          list.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:stanzasColumn(collect.collectPrayers[0])));
        } else {
          list.add(genericItem(collect.collectPrayers[0]));
        }
      }
      break;

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
  if(day.weekID != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.weekServiceIndex].sections[day.weekSectionIndex].collects[day.weekCollectIndex];
  } else {
    return null;
  }
}
