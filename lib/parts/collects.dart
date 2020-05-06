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
    Collect collectOfPrincipalFeast ;

    if(day.isHolyDay()){
      if(day.principalDay() != null){
        Collect c = setCollect(day.principalDay().id, currentPrayerBookId);
        collectOfPrincipalFeast = c;
        if (hasContentToBuild(c, buildType)) {
          list.add(_rubric(
              globals.translationMap[getLanguage(context)]['dates']['types']
              ['principalFeast'] + ':',
              context));
          list.add(DailyPrayersContent(c, buildType));
        }
      }
    }
    if(day.season != null){
      Collect c = setCollect(day.weekId(), currentPrayerBookId);
      if (hasContentToBuild(c, buildType)) {
        if (buildType == 'titles') {
          String season = globals.translationMap[getLanguage(context)]['dates']['seasons'][day.season.id];

          if(season != null && season.isNotEmpty) {
            list.add(_rubric(
                globals.translationMap[getLanguage(context)]['dates']['types']
                ['season'] + ':', context));
            list.add(_collectTitle(season, context));
//            print(day.weekId());
          }
        } else if( c != collectOfPrincipalFeast){
          list.add(_rubric(globals.translationMap[getLanguage(context)]['dates']['types']
          ['prayerOfTheWeek'] + ':', context));
          list.add(DailyPrayersContent(c, buildType));
        }
      }
    }

    if(day.nonPrincipalDays() != null) {
      day.nonPrincipalDays().forEach((hd) {
        Collect c = setCollect(hd.id, currentPrayerBookId);
        if (hasContentToBuild(c, buildType)) {
          list.add(_rubric(
              globals.translationMap[getLanguage(context)]['dates']['types']
              ['holyDay'] + ':', context));
//          if today is a sunday in lent advent or easter then we no not observe red letter days.
          if((day.date.weekday == 7 && ['advent', 'lent','easter'].contains(day.season.id))){
            list.add(_rubric(
                globals.translationMap[getLanguage(context)]['dates']['notObserved'], context));
          }
          list.add(DailyPrayersContent(c, buildType));
        }
      });
    }

    if (buildType == 'titles') {
      return Column(
        children: list,
      );
    }
    return _sectionCard(Column(
      children: list,
    ));
  }

  Collect setCollect(String collectId, String prayerBookId) {

      return globals.allPrayerBooks.getPrayerBook(id: prayerBookId).getCollectAndInfo(collectId);



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
