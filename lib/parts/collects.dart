part of 'section.dart';

/*Currently extending GeneralContent from section.dart leaves GeneralContent's
methods unusable. The only solution I found was to make collects.dart part of
section.dart.
*/
//import 'package:flutter/material.dart';
//
//import 'section.dart';
//import '../app.dart';
//import '../globals.dart' as globals;
//import '../model/calendar.dart';
//import '../pages/calendar.dart';
//import '../json/serializePrayerBook.dart';

/// CollectContent is used to render certain collect fields within a service.
/// For the section of the prayerBook with the list of all collects, see [CollectSectionContent]
class CollectContent extends GeneralContent {
  final String currentPrayerBookId;
  final String buildType;

  CollectContent(this.currentPrayerBookId, [this.buildType = 'full']);

  @override
  Widget build(BuildContext context) {
    Day day = getDay(context);
    List<Widget> list = [];
    Collect collectOfWeek = setCollectOfWeek(day, currentPrayerBookId);
    Collect collectOfPrincipalFeast =
        setCollectOfPrincipalFeast(day, currentPrayerBookId);
    Collect collectOfHolyDay = setCollectOfHolyDay(day, currentPrayerBookId);

    celebrationPriority(day).forEach((type) {
      if (type == 'principalFeast' &&
          hasContentToBuild(collectOfPrincipalFeast, buildType)) {
        list.add(_rubric(
            globals.translationMap[getLanguage(context)]['dates']['types']
                    ['principalFeast'] + ':',
            context));
        list.add(DailyPrayersContent(collectOfPrincipalFeast, buildType));
      }

      if (type == 'season' && hasContentToBuild(collectOfWeek, buildType)) {
        if (buildType == 'titles') {
          String season = globals.translationMap[getLanguage(context)]['dates']['seasons']
          [day.season];

          if(season != null && season.isNotEmpty) {
            list.add(_rubric(
                globals.translationMap[getLanguage(context)]['dates']['types']
                ['season'] + ':', context));
            list.add(_collectTitle(season, context));
          }
        } else {
          list.add(_rubric(globals.translationMap[getLanguage(context)]['dates']['types']
          ['prayerOfTheWeek'] + ':', context));
          list.add(DailyPrayersContent(collectOfWeek, buildType));
        }
      }

      if (type == 'holyDay' && hasContentToBuild(collectOfHolyDay, buildType)) {
        list.add(_rubric(globals.translationMap[getLanguage(context)]['dates']['types']
        ['holyDay'] + ':', context));
        list.add(DailyPrayersContent(collectOfHolyDay, buildType));
      }
    });
    if (buildType == 'titles') {
      return Column(
        children: list,
      );
    }
    return _sectionCard(Column(
      children: list,
    ));
  }

  Collect setCollectOfWeek(day, prayerBookId) {
    if (day != null && day.weekID != null && day.weekCollectIndex != null) {
      return globals.allPrayerBooks
          .getPrayerBook(prayerBookId)
          .services[day.weekServiceIndex]
          .sections[day.weekSectionIndex]
          .collects[day.weekCollectIndex];
    } else {
      return null;
    }
  }

  Collect setCollectOfPrincipalFeast(day, prayerBookId) {
    if (day != null &&
        day.principalFeastID != null &&
        day.principalFeastCollectIndex != null) {
      return globals.allPrayerBooks
          .getPrayerBook(prayerBookId)
          .services[day.principalFeastServiceIndex]
          .sections[day.principalFeastSectionIndex]
          .collects[day.principalFeastCollectIndex];
    } else {
      return null;
    }
  }

  Collect setCollectOfHolyDay(day, prayerBookId) {
    if (day != null &&
        day.holyDayID != null &&
        day.holyDayCollectIndex != null) {
      return globals.allPrayerBooks
          .getPrayerBook(prayerBookId)
          .services[day.holyDayServiceIndex]
          .sections[day.holyDaySectionIndex]
          .collects[day.holyDayCollectIndex];
    } else {
      return null;
    }
  }

  bool hasContentToBuild(Collect collect, buildType) {
    if (collect != null) {
      switch (buildType) {
        case "full":
          {
            return true;
          }
          break;

        case "titles":
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
