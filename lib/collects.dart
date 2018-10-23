import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
//import 'dart:async';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/service.dart';
//import 'package:world_liturgy_app/app.dart';
//import 'package:world_liturgy_app/calendar.dart';

Widget collectList(
  currentPrayerBookIndex,
  Day day,
  String language,
  BuildContext context,
  {buildType = 'full'}
){
  List<Widget> list = [];
  Collect collectOfWeek = setCollectOfWeek(day, currentPrayerBookIndex);
  Collect collectOfPrincipalFeast = setCollectOfPrincipalFeast(day, currentPrayerBookIndex);
  Collect  collectOfHolyDay = setCollectOfHolyDay(day, currentPrayerBookIndex);

  if(collectOfPrincipalFeast != null && hasContentToBuild(collectOfPrincipalFeast, buildType) ) {
    list.add(buildDailyPrayers(collectOfPrincipalFeast,
        language,
        buildType));
  }

  if(collectOfWeek != null && day.date.weekday == 7 && hasContentToBuild(collectOfWeek, buildType)) {
    list.add(buildDailyPrayers(collectOfWeek,
        language,
        buildType));
  }

  if(collectOfHolyDay != null && hasContentToBuild(collectOfHolyDay, buildType)) {
    list.add(buildDailyPrayers(collectOfHolyDay,
        language,
        buildType));
  }

  if(collectOfWeek != null && day.date.weekday != 7 && hasContentToBuild(collectOfWeek, buildType)) {
    list.add(buildDailyPrayers(collectOfWeek,
        language,
        buildType));
  }

  return Column(
    children: list,
  );
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
