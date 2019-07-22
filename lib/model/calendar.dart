import 'dart:async';

import '../globals.dart' as globals;
import '../json/xml_parser.dart';
import '../json/serializeCalendar.dart';

class Day {
  Day();

  DateTime date;
  String season;
  String weekID;
  String seasonColor;
  String principalFeastID;
  String principalColor;
  String principalOptionalCelebrationSunday;
  String holyDayID;
  String holyDayColor;
  String holyDayType;
  int weekServiceIndex;
  int weekSectionIndex;
  int weekCollectIndex;
  int principalFeastServiceIndex;
  int principalFeastSectionIndex;
  int principalFeastCollectIndex;
  int holyDayServiceIndex;
  int holyDaySectionIndex;
  int holyDayCollectIndex;

  static final columns = ["date", "season", "weekId", "seasonColor", "principalFeastID", "principalColor", "principalOptionalCelebrationSunday", "holyDayId", "holyDayColor", "holyDayType", 'weekServiceIndex', 'weekSectionIndex', 'weekCollectIndex', 'principalFeastServiceIndex', 'principalFeastSectionIndex', 'principalFeastCollectIndex', 'holyDayServiceIndex', 'holyDaySectionIndex', 'holyDayCollectIndex' ];

  Map toMap() {
    Map map = {
    "date": constructDaysSince(date),
    "season": season,
    "weekId": weekID,
    "seasonColor": seasonColor,
    "principalFeastID": principalFeastID,
    "principalColor": principalColor,
    "principalOptionalCelebrationSunday": principalOptionalCelebrationSunday,
    "holyDayId": holyDayID,
    "holyDayColor": holyDayColor,
    "holyDayType": holyDayType,
    };

    return map;
  }

  static fromMap(Map map) {
    Day day = new Day();
    day.date = decodeDaysSince(map["date"]);
    day.season = map["season"];
    day.weekID = map["weekID"];
    day.seasonColor = map["seasonColor"];
    day.principalFeastID = map["principalFeastID"];
    day.principalColor = map["principalColor"];
    day.principalOptionalCelebrationSunday = map["principalOptionalCelebrationSunday"];
    day.holyDayID = map["holyDayID"];
    day.holyDayColor = map["holyDayColor"];
    day.holyDayType = map["holyDayType"];
    day.weekServiceIndex = map['weekServiceIndex'];
    day.weekSectionIndex = map['weekSectionIndex'];
    day.weekCollectIndex = map['weekCollectIndex'];
    day.principalFeastServiceIndex = map['principalFeastServiceIndex'];
    day.principalFeastSectionIndex = map['principalFeastSectionIndex'];
    day.principalFeastCollectIndex = map['principalFeastCollectIndex'];
    day.holyDayServiceIndex = map['holyDayServiceIndex'];
    day.holyDaySectionIndex = map['holyDaySectionIndex'];
    day.holyDayCollectIndex = map['holyDayCollectIndex'];

    return day;
  }


}

class Prayer{
  Prayer();

  String id;
//  int prayerBookIndex;
  int serviceIndex;
  int sectionIndex;
  int collectIndex;

  static final columns = ["id", "serviceIndex", "sectionIndex", "collectIndex" ];

  Map toMap() {
    Map map = {
      "id": id,
//      "prayerBookIndex": prayerBookIndex,
      "serviceIndex": serviceIndex,
      "sectionIndex": sectionIndex,
      "collectIndex": collectIndex,
    };

    return map;
  }

  static fromMap(Map map) {
    Prayer collect = new Prayer();
    collect.id = map["id"];
//    collect.prayerBookIndex = map["prayerBookIndex"];
    collect.serviceIndex = map["serviceIndex"];
    collect.sectionIndex = map["sectionIndex"];
    collect.collectIndex = map["collectIndex"];
    return collect;
  }



}

int constructDaysSince(DateTime date){
  return date.difference(new DateTime(1970,1,1)).inDays;
}


DateTime decodeDaysSince(days){
  return DateTime(1970,1,1).add(new Duration(days: days ));
}


Future<List> calculateCalendarsForDatabase()  async{
  CalendarScaffold calendar = await loadCalendar();
  Map collectIndexes = calculateSeasonsAndFeastsIndexForDatabase();

  List listAsMap = [];
  int firstYear = DateTime.now().year -1;
  for (int year = firstYear; year <= firstYear+3; year++ ) {
    listAsMap.addAll(createMapOfYear(calendar, year, collectIndexes));
  }

//  List<Day> days = [];
//  listAsMap.forEach((DateTime date, dynamic day) => days.add(Day.fromMap(v)) );

//  return createMapOfYear(calendar, 2017, collectIndexes);
  return listAsMap;

}

Map calculateSeasonsAndFeastsIndexForDatabase(){
  List collects = [];
  Map collectsVerify = {};

  globals.allPrayerBooks.prayerBooks.asMap().forEach((prayerBookIndex, prayerBook) {

    int serviceIndex = prayerBook.getServiceIndexById("collects");
    if (serviceIndex != -1){
      prayerBook.services[serviceIndex].sections.asMap().forEach((sectionIndex,
          section) {
        if (section.collects != null) {
          section.collects.asMap().forEach((collectIndex, collect) {
            if(collectsVerify[collect.id] == null){
              collectsVerify[collect.id] = {
                "id": collect.id,
//              "prayerBookIndex": prayerBookIndex,
                "serviceIndex": serviceIndex,
                "sectionIndex": sectionIndex,
                "collectIndex": collectIndex
                };
            }
            if(indexVerified(collectsVerify[collect.id], serviceIndex, sectionIndex, collectIndex) ){
              collects.add({
                "id": collect.id,
//              "prayerBookIndex": prayerBookIndex,
                "serviceIndex": serviceIndex,
                "sectionIndex": sectionIndex,
                "collectIndex": collectIndex
              });
            } else {
              print("Collect Indexes do not match!!");
              print("Previous");
              print(collectsVerify[collect.id].toString());
              print("Current Service:" + serviceIndex.toString() + " Section:" + sectionIndex.toString() + " Collect:" + collectIndex.toString());
            }


          });
        }
      });
    }
  });
//  return collects;
  return collectsVerify;

}

bool indexVerified(previous, serviceIndex, sectionIndex, collectIndex){
  return previous['serviceIndex'] == serviceIndex
      && previous['sectionIndex'] == sectionIndex
      && previous['collectIndex'] == collectIndex;

}

Day dayFromMap(DateTime dateString, dynamic day) {
  return Day.fromMap(day);
}

List createMapOfYear(CalendarScaffold calendar , int beginYear, collectIndexes) {
//  setCalendar();

  Map<DateTime, dynamic> calendarMap = {};

//  Structure structure = calendar.structure;

    DateTime christmas = new DateTime(beginYear, 12, 25);
    DateTime nextChristmas = new DateTime(beginYear+1, 12, 25);
    DateTime easter = DateTime.parse(easterMap[beginYear + 1]);

    Map<String, DateTime> calculatedDates = {
      'christmas': christmas,
      'beginningOfYear': christmas.subtract(
          new Duration(days: christmas.weekday + 21)),
      'endOfYear': nextChristmas.subtract(
          new Duration(days: nextChristmas.weekday + 22)),
      'easter': easter,
      'ashWednesday': easter.subtract(new Duration(days: 46)),
      'pentecost' : easter.add(new Duration(days: 50)),
    };

    Duration oneDay = new Duration(days: 1);

    DateTime currentDay = calculatedDates['beginningOfYear'];
    calendar.structure.forEach((season){
      DateTime startDate = getStartOrEndDate(season.startDate, calculatedDates, currentDay.year);
      DateTime endDate = season.endDate == null ? startDate.add(new Duration(days: season.length -1)) : getStartOrEndDate(season.endDate, calculatedDates, currentDay.year);
      while (currentDay.isBefore(startDate) ){
        currentDay = currentDay.add(oneDay);
      }

      while (currentDay.isAfter(startDate) ){
        currentDay = currentDay.subtract(oneDay);
      }

      int week = initialWeekNumber(startDate, endDate, season.weekOrder);

      for(DateTime day = startDate; day.compareTo(endDate) < 1; day = day.add(new Duration(days:1))){
        if(day.weekday == DateTime.sunday){
          season.weekOrder == 'reversed' ? week -=1 : week += 1;
        }
        String weekID = season.id+week.toString();
        calendarMap[day] = {
          'date': constructDaysSince(day),
          'season': season.id,
          'weekID': weekID,
          'seasonColor': season.color,
        };
        String indexID;
        if (collectIndexes[weekID] != null) {
          indexID = weekID;
        }else {
          indexID = weekID.substring(0, weekID.length - 1);
          if(collectIndexes[indexID] ==null){
            List keys = collectIndexes.keys.toList();
            if(keys.indexOf(indexID+1.toString()) != -1){
              String prevCollectTitle = keys[keys.indexOf(indexID+1.toString())-1];
              indexID = prevCollectTitle;
            }
          }
        }
        if (collectIndexes[indexID] != null){
          calendarMap[day].addAll({
            'weekServiceIndex': collectIndexes[indexID]['serviceIndex'],
            'weekSectionIndex': collectIndexes[indexID]['sectionIndex'],
            'weekCollectIndex': collectIndexes[indexID]['collectIndex'],
          });


        }
      }

      currentDay = endDate.add(oneDay);
    });

    calendar.holyDays.forEach((holyDay){
      DateTime day = getStartOrEndDate(holyDay.date, calculatedDates, beginYear+1);
      while (day.compareTo(calculatedDates['endOfYear']) > 0){
        day = new DateTime(day.year -1, day.month, day.day);
      }
      while (day.compareTo(calculatedDates['beginningOfYear']) < 0){
        day = new DateTime(day.year +1, day.month, day.day);
      }

      DateTime lastDay = holyDay.length != null ? day.add(new Duration(days: holyDay.length -1)) : day;

      for (DateTime dateToAdd = day; dateToAdd.compareTo(lastDay) < 1; dateToAdd = dateToAdd.add(new Duration(days:1))) {
        if (calendarMap.containsKey(dateToAdd)){
          if (holyDay.type == 'principal') {
            calendarMap[dateToAdd].addAll({
              'principalFeastID': holyDay.id,
              'principalColor': holyDay.color,
              'principalOptionalCelebrationSunday': holyDay.optionalCelebrationSunday,
            });
            if ( collectIndexes[holyDay.id] != null){
              calendarMap[dateToAdd].addAll({
                'principalFeastServiceIndex': collectIndexes[holyDay.id]['serviceIndex'],
                'principalFeastSectionIndex': collectIndexes[holyDay.id]['sectionIndex'],
                'principalFeastCollectIndex': collectIndexes[holyDay.id]['collectIndex']
              });

            }
          } else {

            calendarMap[dateToAdd].addAll({
              'holyDayID': holyDay.id,
              'holyDayColor': holyDay.color,
              'holyDayType': holyDay.type,
              'principalOptionalCelebrationSunday': holyDay.optionalCelebrationSunday,


            });

            if ( collectIndexes[holyDay.id] != null){
              calendarMap[dateToAdd].addAll({
                'holyDayServiceIndex': collectIndexes[holyDay.id]['serviceIndex'],
                'holyDaySectionIndex': collectIndexes[holyDay.id]['sectionIndex'],
                'holyDayCollectIndex': collectIndexes[holyDay.id]['collectIndex']
              });

            }
          }

          if (holyDay.optionalCelebrationSunday == 'true' && dateToAdd.weekday != DateTime.sunday ){
            dateToAdd = dateToAdd.add(new Duration(days: 7-dateToAdd.weekday));
            if (holyDay.type == 'principal') {
              calendarMap[dateToAdd].addAll({
                'principalFeastID': holyDay.id,
                'principalColor': holyDay.color,
                'principalOptionalCelebrationSunday': holyDay
                    .optionalCelebrationSunday,
              });
              if ( collectIndexes[holyDay.id] != null) {
                calendarMap[dateToAdd].addAll({
                  'principalFeastServiceIndex': collectIndexes[holyDay
                      .id]['serviceIndex'],
                  'principalFeastSectionIndex': collectIndexes[holyDay
                      .id]['sectionIndex'],
                  'principalFeastCollectIndex': collectIndexes[holyDay
                      .id]['collectIndex']
                });
              }
            } else {

              calendarMap[dateToAdd].addAll({
                'holyDayID': holyDay.id,
                'holyDayColor': holyDay.color,
                'holyDayType': holyDay.type,
                'holyDayServiceIndex': collectIndexes[holyDay.id]['serviceIndex'],
                'holyDaySectionIndex': collectIndexes[holyDay.id]['sectionIndex'],
                'holyDayCollectIndex': collectIndexes[holyDay.id]['collectIndex']
              });

              if ( collectIndexes[holyDay.id] != null){
                calendarMap[dateToAdd].addAll({
                  'holyDayServiceIndex': collectIndexes[holyDay.id]['serviceIndex'],
                  'holyDaySectionIndex': collectIndexes[holyDay.id]['sectionIndex'],
                  'holyDayCollectIndex': collectIndexes[holyDay.id]['collectIndex']
                });

              }
            }
          }
        }
      }
    });

    List days = [];
    calendarMap.forEach((key, value) {
      days.add(value);
    });


    return days;
//  scaffold.christmasCycle
  }

  int initialWeekNumber(startDay,endDay, weekOrder){
    if (weekOrder == 'reversed'){
      int length = endDay.difference(startDay).inDays;
//    if endDay is not a sunday, find length to last sunday
      if (endDay.weekday != DateTime.sunday){
        length -= endDay.weekday;
      }
      return 2 + length ~/ 7;

    } else {
      return 0;
    }

  }


  DateTime getStartOrEndDate(date, calculatedDates, year){
    if (date.month != null){
      return new DateTime(year, date.month, date.day);
    } else {
      var specialDate = calculatedDates[date.special];
      if (date.daysBefore != null){
        return specialDate.subtract(new Duration(days: date.daysBefore));
      } else if (date.daysAfter != null){
        return specialDate.add(new Duration(days: date.daysAfter));
      } else if(date.type == 'sundayClosestTo') {
        int daysToSunday = specialDate.weekday <= 3 ? -specialDate.weekday : 7-specialDate.weekday;
        return specialDate.add(new Duration(days: daysToSunday));
      } else{
        return specialDate;
      }
    }
  }

//the church year is numbered based on the year of the first Sunday in Advent. E.g. church year 2017 went from Nov. 2017 until Nov 2018.


  final Map<int,String> easterMap = {2014: '2014-04-20', 2015: '2015-04-05', 2016: '2016-03-27', 2017: '2017-04-16', 2018: '2018-04-01', 2019: '2019-04-21', 2020: '2020-04-12', 2021: '2021-04-04', 2022: '2022-04-17', 2023: '2023-04-09', 2024: '2024-03-31', 2025: '2025-04-20', 2026: '2026-04-05', 2027: '2027-03-28', 2028: '2028-04-16', 2029: '2029-04-01', 2030: '2030-04-21', 2031: '2031-04-13', 2032: '2032-03-28', 2033: '2033-04-17', 2034: '2034-04-09', 2035: '2035-03-25', 2036: '2036-04-13', 2037: '2037-04-05', 2038: '2038-04-25', 2039: '2039-04-10', 2040: '2040-04-01', 2041: '2041-04-21', 2042: '2042-04-06', 2043: '2043-03-29', 2044: '2044-04-17', 2045: '2045-04-09', 2046: '2046-03-25', 2047: '2047-04-14', 2048: '2048-04-05', 2049: '2049-04-18', 2050: '2050-04-10', 2051: '2051-04-02', 2052: '2052-04-21', 2053: '2053-04-06', 2054: '2054-03-29', 2055: '2055-04-18', 2056: '2056-04-02', 2057: '2057-04-22', 2058: '2058-04-14', 2059: '2059-03-30', 2060: '2060-04-18', 2061: '2061-04-10', 2062: '2062-03-26', 2063: '2063-04-15', 2064: '2064-04-06', 2065: '2065-03-29', 2066: '2066-04-11', 2067: '2067-04-03', 2068: '2068-04-22', 2069: '2069-04-14', 2070: '2070-03-30', 2071: '2071-04-19', 2072: '2072-04-10', 2073: '2073-03-26', 2074: '2074-04-15', 2075: '2075-04-07', 2076: '2076-04-19', 2077: '2077-04-11', 2078: '2078-04-03', 2079: '2079-04-23', 2080: '2080-04-07', 2081: '2081-03-30', 2082: '2082-04-19', 2083: '2083-04-04', 2084: '2084-03-26', 2085: '2085-04-15', 2086: '2086-03-31', 2087: '2087-04-20', 2088: '2088-04-11', 2089: '2089-04-03', 2090: '2090-04-16', 2091: '2091-04-08', 2092: '2092-03-30', 2093: '2093-04-12', 2094: '2094-04-04', 2095: '2095-04-24', 2096: '2096-04-15', 2097: '2097-03-31', 2098: '2098-04-20', 2099: '2099-04-12', 2100: '2100-03-28'};



