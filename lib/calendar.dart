import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializeCalendar.dart';
import 'package:world_liturgy_app/json/xml_parser.dart';
import 'dart:async';
import 'globals.dart' as globals;

class Calendar extends StatefulWidget {
  const Calendar({ Key key }) : super(key: key);

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
//    PrayerBook currentPrayerBook = allPrayerBooks.prayerBooks[prayerBookIndex];
//    Service currentService = currentPrayerBook.services[serviceIndex];

    return new Scaffold (
//      drawer: _buildDrawer(allPrayerBooks.prayerBooks, currentIndexes),
      appBar: new AppBar(
//        title: new Text(currentService.title),
        actions:  <Widget>[

        ],
      ),
      body: new ListView(
        children: _calendarTest(),
      ),
    );
  }


  List<Widget> _calendarTest(){
    return initialBuild();


  }


}


buildCalendar(year){

//    TODO: 1. build daily structure for this year and next


//    TODO: 1.b. find any other feasts/days
//    TODO: 2. Ensure Link between feasts, seasons and days
//    TODO: 3. Sqf lite
//    TODO: 3.a. Create SQF lite tables
//    TODO: 3.b. Save the dates to the calendar
//    TODO: 3. Create hash verification so that files do not have to load every time. in user preferences? or in db?
//    TODO: 4. Link Lectionary
//    TODO: 5. Create methods to clean up the Sqflite
//    TODO: test for updated files / dates that aren't in the calendar




}

//the initial build will create a daily list of seasons/feasts for this
// and next liturgical year

List<Widget> initialBuild(){
//  setCalendar();
  CalendarScaffold calendar = globals.calendarScaffold;
  List<Widget> list = [];
  Map<DateTime, dynamic> calendarMap = {};

//  Structure structure = calendar.structure;
  int beginYear = new DateTime.now().year +1;

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
    'pentecost' : easter.add(new Duration(days: 49)),
  };



  Duration oneDay = new Duration(days: 1);

  DateTime currentDay = calculatedDates['beginningOfYear'];
  calendar.structure.forEach((season){
    list.add(new Text(season.id));
    DateTime startDate = getStartOrEndDate(season.startDate, calculatedDates, currentDay.year);
    DateTime endDate = season.endDate == null ? startDate.add(new Duration(days: season.length -1)) : getStartOrEndDate(season.endDate, calculatedDates, currentDay.year);
    while (currentDay.isBefore(startDate) ){
      list.add(new Text('DAY HAS NO SEASONS ' + currentDay.toString()));
      currentDay = currentDay.add(oneDay);
    }

    while (currentDay.isAfter(startDate) ){
      list.add(new Text('DAY HAS TWO SEASONS' + currentDay.toString()));
      currentDay = currentDay.subtract(oneDay);
    }

    int week = initialWeekNumber(startDate, endDate, season.weekOrder);

    for(DateTime day = startDate; day.compareTo(endDate) < 1; day = day.add(new Duration(days:1))){
      if(day.weekday == DateTime.sunday){
        season.weekOrder == 'reversed' ? week -=1 : week += 1;
        list.add(new Text('SUNDAY'));
      }
      String weekId = season.id+week.toString();
      list.add(new Text(day.toIso8601String() + weekId));
      calendarMap[day] = {'date': day, 'season': season.id, 'weekId': weekId, 'seasonColor': season.color};
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
            'principalId': holyDay.id,
            'principalColor': holyDay.color,
            'principalOptionalCelebrationSunday': holyDay.optionalCelebrationSunday
          });
        } else {

          calendarMap[dateToAdd].addAll({
            'holyDayId': holyDay.id,
            'holyDayColor': holyDay.color,
            'holyDayType': holyDay.type,

          });
        }

        if (holyDay.optionalCelebrationSunday == 'true' && dateToAdd.weekday != DateTime.sunday ){
          dateToAdd = dateToAdd.add(new Duration(days: 7-dateToAdd.weekday));
          if (holyDay.type == 'principal') {
            calendarMap[dateToAdd].addAll({
              'principalId': holyDay.id,
              'principalColor': holyDay.color,
              'principalOptionalCelebrationSunday': holyDay
                  .optionalCelebrationSunday
            });
          } else {

            calendarMap[dateToAdd].addAll({
              'holyDayId': holyDay.id,
              'holyDayColor': holyDay.color,
              'holyDayType': holyDay.type,

            });
          }
        }
      }
    }
  });


  print(calendarMap.toString());
  return list;
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



class CalendarBuilder {

  final calendarStructure = {
    'type': 'western',
    'calendar': [
      
    ]
  };

}

final Map<int,String> easterMap = {2014: '2014-04-20', 2015: '2015-04-05', 2016: '2016-03-27', 2017: '2017-04-16', 2018: '2018-04-01', 2019: '2019-04-21', 2020: '2020-04-12', 2021: '2021-04-04', 2022: '2022-04-17', 2023: '2023-04-09', 2024: '2024-03-31', 2025: '2025-04-20', 2026: '2026-04-05', 2027: '2027-03-28', 2028: '2028-04-16', 2029: '2029-04-01', 2030: '2030-04-21', 2031: '2031-04-13', 2032: '2032-03-28', 2033: '2033-04-17', 2034: '2034-04-09', 2035: '2035-03-25', 2036: '2036-04-13', 2037: '2037-04-05', 2038: '2038-04-25', 2039: '2039-04-10', 2040: '2040-04-01', 2041: '2041-04-21', 2042: '2042-04-06', 2043: '2043-03-29', 2044: '2044-04-17', 2045: '2045-04-09', 2046: '2046-03-25', 2047: '2047-04-14', 2048: '2048-04-05', 2049: '2049-04-18', 2050: '2050-04-10', 2051: '2051-04-02', 2052: '2052-04-21', 2053: '2053-04-06', 2054: '2054-03-29', 2055: '2055-04-18', 2056: '2056-04-02', 2057: '2057-04-22', 2058: '2058-04-14', 2059: '2059-03-30', 2060: '2060-04-18', 2061: '2061-04-10', 2062: '2062-03-26', 2063: '2063-04-15', 2064: '2064-04-06', 2065: '2065-03-29', 2066: '2066-04-11', 2067: '2067-04-03', 2068: '2068-04-22', 2069: '2069-04-14', 2070: '2070-03-30', 2071: '2071-04-19', 2072: '2072-04-10', 2073: '2073-03-26', 2074: '2074-04-15', 2075: '2075-04-07', 2076: '2076-04-19', 2077: '2077-04-11', 2078: '2078-04-03', 2079: '2079-04-23', 2080: '2080-04-07', 2081: '2081-03-30', 2082: '2082-04-19', 2083: '2083-04-04', 2084: '2084-03-26', 2085: '2085-04-15', 2086: '2086-03-31', 2087: '2087-04-20', 2088: '2088-04-11', 2089: '2089-04-03', 2090: '2090-04-16', 2091: '2091-04-08', 2092: '2092-03-30', 2093: '2093-04-12', 2094: '2094-04-04', 2095: '2095-04-24', 2096: '2096-04-15', 2097: '2097-03-31', 2098: '2098-04-20', 2099: '2099-04-12', 2100: '2100-03-28'};


class Feast extends Object{
  final Map<int,String> easterMap = {2014: '2014-04-20', 2015: '2015-04-05', 2016: '2016-03-27', 2017: '2017-04-16', 2018: '2018-04-01', 2019: '2019-04-21', 2020: '2020-04-12', 2021: '2021-04-04', 2022: '2022-04-17', 2023: '2023-04-09', 2024: '2024-03-31', 2025: '2025-04-20', 2026: '2026-04-05', 2027: '2027-03-28', 2028: '2028-04-16', 2029: '2029-04-01', 2030: '2030-04-21', 2031: '2031-04-13', 2032: '2032-03-28', 2033: '2033-04-17', 2034: '2034-04-09', 2035: '2035-03-25', 2036: '2036-04-13', 2037: '2037-04-05', 2038: '2038-04-25', 2039: '2039-04-10', 2040: '2040-04-01', 2041: '2041-04-21', 2042: '2042-04-06', 2043: '2043-03-29', 2044: '2044-04-17', 2045: '2045-04-09', 2046: '2046-03-25', 2047: '2047-04-14', 2048: '2048-04-05', 2049: '2049-04-18', 2050: '2050-04-10', 2051: '2051-04-02', 2052: '2052-04-21', 2053: '2053-04-06', 2054: '2054-03-29', 2055: '2055-04-18', 2056: '2056-04-02', 2057: '2057-04-22', 2058: '2058-04-14', 2059: '2059-03-30', 2060: '2060-04-18', 2061: '2061-04-10', 2062: '2062-03-26', 2063: '2063-04-15', 2064: '2064-04-06', 2065: '2065-03-29', 2066: '2066-04-11', 2067: '2067-04-03', 2068: '2068-04-22', 2069: '2069-04-14', 2070: '2070-03-30', 2071: '2071-04-19', 2072: '2072-04-10', 2073: '2073-03-26', 2074: '2074-04-15', 2075: '2075-04-07', 2076: '2076-04-19', 2077: '2077-04-11', 2078: '2078-04-03', 2079: '2079-04-23', 2080: '2080-04-07', 2081: '2081-03-30', 2082: '2082-04-19', 2083: '2083-04-04', 2084: '2084-03-26', 2085: '2085-04-15', 2086: '2086-03-31', 2087: '2087-04-20', 2088: '2088-04-11', 2089: '2089-04-03', 2090: '2090-04-16', 2091: '2091-04-08', 2092: '2092-03-30', 2093: '2093-04-12', 2094: '2094-04-04', 2095: '2095-04-24', 2096: '2096-04-15', 2097: '2097-03-31', 2098: '2098-04-20', 2099: '2099-04-12', 2100: '2100-03-28'};


//  type is fixed or moveable
  String type;

//  for fixed feasts
  int month;
  int day;


//  for movable feasts
//  either a map or calculated dates
  Map<int, String> calculatedDates;
  int adjuster;

  Feast(
      this.type, {this.month, this.day, this.calculatedDates, this.adjuster}
      );

  Feast.christmas(){
    type = 'fixed';
    month = 12;
    day = 25;

  }

  Feast.easter(){
    type ='moveable';
    calculatedDates = easterMap;
  }

  Feast.ashWednesday(){
    type ='moveable';
    calculatedDates = easterMap;
    adjuster = -46;
  }

  Feast.ascension(){
    type ='moveable';
    calculatedDates = easterMap;
    adjuster = 40;
  }

  Feast.pentecost(){
    type ='moveable';
    calculatedDates = easterMap;
    adjuster = 50;
  }

  Feast.trinitySunday(){
    type ='moveable';
    calculatedDates = easterMap;
    adjuster = 57;
  }

  DateTime findDate(int churchYear){
    if (type == 'fixed'){
      return new DateTime(churchYear, month, day);
    } else if (calculatedDates != null) {
      if (adjuster == null) {
        return DateTime.parse(calculatedDates[churchYear]);
      } else {
        return DateTime.parse(calculatedDates[churchYear]).add(new Duration(days: adjuster));
      }
    } else {
      throw 'date is not in accepted format to find date. Must either be type:fixed have a calculatedDates map.';
    }
  }

  DateTime beginningOfYear(int year){
    if (type != 'fixed' || month != 12 || day != 25){
      throw 'adventStart must be calculated from Christmas!';
    } else{
      //     last Sunday of Advent is the date of Christmas minus the 'weekday' value
      var christmasDay = new DateTime(year, month, day);
      // and first Sunday of Advent is 21 days before last sunday
      return christmasDay.subtract(new Duration(days: christmasDay.weekday +21));
    }
  }


}

setCalendar() async {
  if(globals.calendarScaffold == null) {
    dynamic calendar = await loadCalendar();
    globals.calendarScaffold = calendar;
  }

}

