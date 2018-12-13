import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
//import 'dart:async';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/service.dart';
import 'package:world_liturgy_app/app.dart';
import 'package:world_liturgy_app/calendar.dart';

Widget collectList(
  currentPrayerBookIndex,
  BuildContext context,
  {buildType = 'full'}
){
  Day day = getDay(context);
  List<Widget> list = [];
  Collect collectOfWeek = setCollectOfWeek(day, currentPrayerBookIndex);
  Collect collectOfPrincipalFeast = setCollectOfPrincipalFeast(day, currentPrayerBookIndex);
  Collect  collectOfHolyDay = setCollectOfHolyDay(day, currentPrayerBookIndex);

  celebrationPriority(day).forEach((type){
    if(type == 'principalFeast' && hasContentToBuild(collectOfPrincipalFeast, buildType) ) {
      list.add(buildDailyPrayers(collectOfPrincipalFeast, buildType, context));
    }

    if(type == 'season' && hasContentToBuild(collectOfWeek, buildType)) {
      list.add(buildDailyPrayers(collectOfWeek, buildType, context));
    }

    if(type == 'holyDay' && hasContentToBuild(collectOfHolyDay, buildType)) {
      list.add(buildDailyPrayers(collectOfHolyDay, buildType, context));
    }
  });

  return Column(
    children: list,
  );
}


Collect setCollectOfWeek(day, prayerBookId){
  if(day != null && day.weekID != null && day.weekCollectIndex != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.weekServiceIndex].sections[day.weekSectionIndex].collects[day.weekCollectIndex];
  } else {
    return null;
  }
}

Collect setCollectOfPrincipalFeast(day, prayerBookId){
  if(day != null && day.principalFeastID != null && day.principalFeastCollectIndex != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.principalFeastServiceIndex].sections[day.principalFeastSectionIndex].collects[day.principalFeastCollectIndex];
  } else {
    return null;
  }
}

Collect setCollectOfHolyDay(day, prayerBookId){
  if(day != null && day.holyDayID != null && day.holyDayCollectIndex != null){
    return globals.allPrayerBooks.getPrayerBook(prayerBookId).services[day.holyDayServiceIndex].sections[day.holyDaySectionIndex].collects[day.holyDayCollectIndex];
  } else {
    return null;
  }
}

bool hasContentToBuild(Collect collect, buildType){
  if(collect != null) {
    switch (buildType) {
      case "full" :
        {
          return true;
        }
        break;

      case "titles" :
        {
          return true;
        }
        break;

      case 'collect':
        {
          return collect.collectPrayers != null;
        }
        break;

      case 'postCommunion':
        {
          return collect.postCommunionPrayers != null;
        }
        break;
    }
  } else {
    return false;
  }
}

