import 'package:flutter/material.dart';

import 'json/serializePrayerBook.dart';
import 'globals.dart' as globals;
import 'model/calendar.dart';
import 'pages/section.dart';
import 'app.dart';
import 'calendar.dart';

class CollectContent extends GeneralContent {
  final int currentPrayerBookIndex;
  final String buildType;

  CollectContent(this.currentPrayerBookIndex, [this.buildType = 'full']);

  Widget build(BuildContext context){
    Day day = getDay(context);
    List<Widget> list = [];
    Collect collectOfWeek = setCollectOfWeek(day, currentPrayerBookIndex);
    Collect collectOfPrincipalFeast = setCollectOfPrincipalFeast(
        day, currentPrayerBookIndex);
    Collect collectOfHolyDay = setCollectOfHolyDay(day, currentPrayerBookIndex);

    celebrationPriority(day).forEach((type) {
      if (type == 'principalFeast' &&
          hasContentToBuild(collectOfPrincipalFeast, buildType)) {
        list.add(DailyPrayersContent(collectOfPrincipalFeast, buildType));
      }

      if (type == 'season' && hasContentToBuild(collectOfWeek, buildType)) {
        list.add(DailyPrayersContent(collectOfWeek, buildType));
      }

      if (type == 'holyDay' && hasContentToBuild(collectOfHolyDay, buildType)) {
        list.add(DailyPrayersContent(collectOfHolyDay, buildType));
      }
    });

    return Column(
      children: list,
    );
  }


  Collect setCollectOfWeek(day, prayerBookId) {
    if (day != null && day.weekID != null && day.weekCollectIndex != null) {
      return globals.allPrayerBooks
          .getPrayerBook(prayerBookId)
          .services[day.weekServiceIndex].sections[day.weekSectionIndex]
          .collects[day.weekCollectIndex];
    } else {
      return null;
    }
  }

  Collect setCollectOfPrincipalFeast(day, prayerBookId) {
    if (day != null && day.principalFeastID != null &&
        day.principalFeastCollectIndex != null) {
      return globals.allPrayerBooks
          .getPrayerBook(prayerBookId)
          .services[day.principalFeastServiceIndex].sections[day
          .principalFeastSectionIndex].collects[day.principalFeastCollectIndex];
    } else {
      return null;
    }
  }

  Collect setCollectOfHolyDay(day, prayerBookId) {
    if (day != null && day.holyDayID != null &&
        day.holyDayCollectIndex != null) {
      return globals.allPrayerBooks
          .getPrayerBook(prayerBookId)
          .services[day.holyDayServiceIndex].sections[day.holyDaySectionIndex]
          .collects[day.holyDayCollectIndex];
    } else {
      return null;
    }
  }

  bool hasContentToBuild(Collect collect, buildType) {
    if (collect != null) {
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
    }

    return false;

  }

}
