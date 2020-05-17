import 'dart:async';
import '../globals.dart' as globals;
import '../json/xml_parser.dart';
import '../json/serializeCalendar.dart';

Future<Day> getDayFromCalendar(DateTime day) async{
  if(globals.calendar == null){
    CalendarScaffold scaffold = await loadCalendar();
    globals.calendar = LitCalendar(
      scaffold,
      staticDays: getStaticDays(scaffold.holyDays),
      boundsList: [],
      exactDays: [],
      seasons: [],
    );
  }

  globals.calendar.checkThatDayIsIncluded(day);

//  printEveryWeeksId();

  return globals.calendar.createDayScaffold(day);

}

List<StaticHolyDay> getStaticDays(List<HolyDay> list){
  List<StaticHolyDay> staticDays = [];
  list.forEach((day) {
    if(day.date.special == null || day.date.type != null){
      staticDays.add(StaticHolyDay(
        day.id,
        day.color,
        day.date.month,
        day.date.day,
        optionalCelebrationSunday: day.optionalCelebrationSunday == 'true' ? true : false,
      ));
    }
  });
  return staticDays;
}

void printEveryWeeksId(){
  //  THE FOLLOWING PRINTS OUT EVERY WEEK"S ID FOR MANUAL CHECKING>
  DateTime tempDay = globals.calendar.boundsList.first.start;
  while(!tempDay.isAfter(globals.calendar.boundsList.first.end) ){
    Day d = globals.calendar.createDayScaffold(tempDay);
    if(d.season != null){
      print(d.date.year.toString() +'-'+d.date.month.toString()+'-'+d.date.day.toString() +': ' + d.weekId());
    }
    if(d.holyDays.isNotEmpty){
      d.holyDays.forEach((hd) {
        print(d.date.year.toString() +'-'+d.date.month.toString()+'-'+d.date.day.toString() +': ' + hd.id.toString());

      });
    }
    tempDay = tempDay.add(Duration(days: 1));
  }
}

DateTime easterDay (int year){
//  Accurate for method 3 (Western Easters only) from 1583 to 4099 in the Gregorian calendar.
//
//Function EasterHodges(dy, mth, ByVal y, ByVal method) As Boolean
//
//'by David Hodges, derived by refining the "Butcher's Ecclesiastical Calendar" rule
//http://www.gmarts.org/index.php?go=415#EasterHodges

  int a = year ~/ 100;
  int b = year % 100;
  int c = (3 * (a + 25)) ~/ 4;
  int d = (3 * (a + 25)) % 4;
  int e = (8 * (a + 11)) ~/ 25;
  int f = (5 * a + b) % 19;
  int g = (19 * f + c - e) % 30;
  int h = (f + 11 * g) ~/ 319;
  int j = (60 * (5 - d) + b) ~/ 4;
  int k = (60 * (5 - d) + b) % 4;
  int m = (2 * j - k - g + h) % 7;
  int n = (g - h + m + 114) ~/ 31;
  int p = (g - h + m + 114) % 31;
  int day = p + 1;
  int month = n;

  return DateTime.utc(year, month, day);
}

class LitCalendar{
  CalendarScaffold scaffold;
  List<StaticHolyDay> staticDays;
  List<ExactSeason> seasons;
  List<ExactHolyDay> exactDays;
  List<Bounds> boundsList;

  LitCalendar(this.scaffold, {this.staticDays, this.seasons, this.exactDays, this.boundsList});

  bool contains(DateTime day) {
    for (Bounds b in this.boundsList) {
      if (b.contains(day)) {
        return true;
      }
    }

    return false;
  }

  ExactSeason getSeason(DateTime date){
    return this.seasons.firstWhere((s) => s.bounds.contains(date), orElse: null);
  }

  List<ExactHolyDay> getHolyDays(DateTime date){
    List<ExactHolyDay> l = this.exactDays.where((hd) => hd.date.isAtSameMomentAs(date)).toList();
//    l.addAll(getStaticHolyDays(date));
    return l;
  }

  List<ExactHolyDay> getStaticHolyDays(DateTime date){
    List<ExactHolyDay> l = [];
    for(StaticHolyDay hd in this.staticDays.where((hd) => hd.month == date.month && hd.day == date.day)){
      l.add(ExactHolyDay(
        hd.id,
        hd.color,
        date,
        type: hd.type,
        title: hd.title,
        optionalCelebrationSunday: hd.optionalCelebrationSunday,
      ));
    }

    return l;
  }




  Day createDayScaffold(DateTime date){
//  get season
// get exact day
// find any fixed days
    return Day(
      date,
      globals.calendar.getSeason(date),
      globals.calendar.getHolyDays(date),
    );

  }

  void checkThatDayIsIncluded(day){
    if(! globals.calendar.contains(day)){
      AnchorDays anchorDays = AnchorDays(day);
      CalendarScaffold scaffold = globals.calendar.scaffold;
      globals.calendar.seasons.addAll(calculateSeasons(scaffold, anchorDays));
      globals.calendar.exactDays.addAll(getExactDays(scaffold.holyDays, anchorDays));

      globals.calendar.boundsList.add(Bounds(anchorDays.beginningOfYear, anchorDays.endOfYear));
    }
  }


  List<ExactSeason> calculateSeasons(CalendarScaffold scaffold, AnchorDays anchorDays){
    List<ExactSeason> seasons = [];

    DateTime lastDayCalculated = anchorDays.beginningOfYear;
    lastDayCalculated = lastDayCalculated.subtract(Duration(days:1));

    scaffold.structure.forEach((Season s) {
      DateTime start = lastDayCalculated;
      DateTime end;
      Duration length;

      start = getDate(s.startDate, anchorDays);
      if(start.difference(lastDayCalculated).inDays != 1){
        print('There is an error in either the end date of the season before ${s.id} ${start.year} or ${s.id}  ${start.year}s start date');
        print('${s.id}  start date = ${start.toString()}');
        print(seasons.toString());
      }

      if(s.endDate != null){
        end = getDate(s.endDate, anchorDays, );
      }

      if(s.length != null && s.lengthUnit != null){
        if(s.lengthUnit == 'days'){
//        length is inclusive of first day, so add one less.
          length = Duration(days: s.length -1);
        }

        if(end != null){
          if(!end.isAtSameMomentAs(start.add(length))){
            print(s.id  +' ${end.year} end date and length are incompatible');
          }
        }else{
          end = start.add(length);
        }
      }
      lastDayCalculated = end;

      seasons.add(ExactSeason(
        s.id,
        s.color,
        Bounds(start, end),
        length: length,
        startWeek: s.startWeek,
        endWeek: s.endWeek,
        reversedOrder: s.weekOrder == 'reversed',
      ));
    });

    return seasons;
  }

  DateTime getDate(Date dateProperties, AnchorDays anchorDays, [int year]){
    DateTime date;

    if (dateProperties.month != null ){
      if(year == null) {
        if (dateProperties.month >= anchorDays.beginningOfYear.month
            && dateProperties.day >= anchorDays.beginningOfYear.day) {
          year = anchorDays.beginningOfYear.year;
        } else {
          year = anchorDays.endOfYear.year;
        }
      }
      date = DateTime.utc(year, dateProperties.month, dateProperties.day);

    } else {
      date = anchorDays.get(dateProperties.special);
    }

    if (dateProperties.daysBefore != null){
      return date.subtract(new Duration(days: dateProperties.daysBefore));
    } else if (dateProperties.daysAfter != null){
      return date.add(new Duration(days: dateProperties.daysAfter -1));
    } else if(dateProperties.type == 'sundayClosestTo') {
      int daysToSunday = date.weekday <= 3 ? -date.weekday : 7-date.weekday;
      return date.add(new Duration(days: daysToSunday));
    } else{
      return date;
    }
  }


  List<ExactHolyDay> getExactDays(List<HolyDay> list, AnchorDays anchors){
    List<ExactHolyDay> exactDays = [];
    list.forEach((day) {
      ExactHolyDay thisExactDay;
      // if is a fixed dated between 11/25 and 12/4 there is a chance that it
//      overlaps and appears twice in the church year. check these first, then
      if(day.date.special == null && day.date.type !='sundayClosestTo' &&
          (day.date.month == 11 && day.date.day >24)
          || (day.date.month == 12 && day.date.day <5)){
        [anchors.beginningOfYear.year, anchors.endOfYear.year].forEach((year) {
          DateTime testDate = DateTime.utc(year, day.date.month, day.date.day);
          if(anchors.yearContains(testDate)){
            thisExactDay = getExactDay(day, anchors, testDate);
            exactDays.add(transferIfNeeded(thisExactDay, exactDays, seasons));
          }
        });
      } else {
        thisExactDay = getExactDay(day, anchors);
        thisExactDay = transferIfNeeded(thisExactDay, exactDays, seasons);
        exactDays.add(thisExactDay);
      }
    });
    return exactDays;
  }

  ExactHolyDay getExactDay(HolyDay day, AnchorDays anchorDays, [DateTime knownDate]){
    return ExactHolyDay(
      day.id,
      day.color,
      knownDate ?? getDate(day.date, anchorDays),
      optionalCelebrationSunday: day.optionalCelebrationSunday == 'true' ? true : false,
      type: day.type,
      overlapsAnyDay: day.overlapsAnyDay == 'true' ? true : false,
    );
  }

  ExactHolyDay transferIfNeeded(ExactHolyDay day, List<ExactHolyDay> list, List<ExactSeason> seasons ){
    DateTime originalDate = day.date;
    while( !day.overlapsAnyDay && day.type != 'principal' && (isAlreadyAHolyDay(day.date, list) || isSundayInAdventLentOrEaster(day.date)) && !day.id.contains('christmas')){
      day.dateTransferredFrom = originalDate;
      day.date = day.date.add(Duration(days: 1));
//      print(day.id + ' transferred from ' + originalDate.toString() + ' to ' + day.date.toString());
    }
    return day;
  }

  bool isAlreadyAHolyDay(DateTime day, List<ExactHolyDay> list){
    return list.where((hd) {
      return hd.date.isAtSameMomentAs(day);
    }).toList().isNotEmpty;
  }



  bool isSundayInAdventLentOrEaster(DateTime date){
    return date.weekday == 7 && ['advent', 'lent', 'easter'].contains(getSeason(date).id);
  }

}


class Bounds{
  DateTime start;
  DateTime end;

  Bounds(this.start, this.end);

  bool contains(DateTime day){
    if(day.isBefore(this.start)){
      return false;
    }

    if(day.isAfter(this.end)){
      return false;
    }

    return true;
  }

}

class Day{
  DateTime date;
  ExactSeason season;
  List<ExactHolyDay> holyDays;
  int _weekInt;

  Day(this.date, this.season, this.holyDays);

  bool isHolyDay(){
    return this.holyDays != null && this.holyDays.isNotEmpty ;
  }

  ExactHolyDay principalDay(){
    if(this.isHolyDay()) {
      return this.holyDays?.firstWhere((hd) => hd.type == 'principal',
          orElse: () => null);
    }
    return null;

  }

  List<ExactHolyDay> nonPrincipalDays(){
    if(this.isHolyDay()) {
      return this.holyDays.where((hd) => hd.type != 'principal').toList();
    }
    return null;

  }

  String weekId() {
    if (_weekInt == null) {
      int weekInt;
      if (this.season.reversedOrder) {
        weekInt = 1;
        DateTime finalHypotheticalSat = this.season.bounds.end.add(Duration(days: 6- this.season.bounds.end.weekday));
        weekInt += finalHypotheticalSat.difference(this.date).inDays ~/ 7;
        _weekInt = weekInt;
//      end weekday

      } else {
        weekInt = 0;
        DateTime start = this.season.bounds.start;

//      weekInt += start.weekday ~/ 7;

        weekInt += this.date
            .difference(start.subtract(Duration(days: start.weekday)))
            .inDays ~/ 7;

        _weekInt = weekInt;
      }
    }
    return this.season.id + _weekInt.toString();
  }
}

class AnchorDays{
  int _beginningYear;

  factory AnchorDays(DateTime day){
    int year = day.year;
    DateTime christmas = DateTime.utc(year, 12, 25);
    if(day.isBefore(christmas.subtract(Duration(days: christmas.weekday + 21)))){
      year -= 1;
    }
    return AnchorDays._internal(year);
  }

  AnchorDays._internal(this._beginningYear);

  DateTime get christmas => DateTime.utc(_beginningYear, 12, 25);
  DateTime get nextChristmas => DateTime.utc(_beginningYear + 1, 12, 25);
  DateTime get beginningOfYear => christmas.subtract(Duration(days: christmas.weekday + 21));
  DateTime get endOfYear => nextChristmas.subtract(
      new Duration(days: nextChristmas.weekday + 22));
  DateTime get easter => easterDay(_beginningYear+1);
  DateTime get ashWednesday => easter.subtract(new Duration(days: 46));
  DateTime get pentecost => easter.add(new Duration(days: 49));

  DateTime get (String string){
    switch(string){
      case 'christmas':
        return this.christmas;
        break;
      case 'easter':
        return this.easter;
        break;
      case 'ashWednesday':
        return this.ashWednesday;
        break;
      case 'pentecost':
        return this.pentecost;
        break;
      case 'beginningOfYear':
        return this.beginningOfYear;
        break;
      case 'endOfYear':
        return this.endOfYear;
        break;
    }
    return this.christmas;
  }

  bool yearContains(DateTime date){
    return !date.isBefore(this.beginningOfYear) && !date.isAfter(this.endOfYear);
  }
}

class ExactSeason{
  String id, color;
  int startWeek, endWeek;
  Duration length;
  Bounds bounds;
  bool reversedOrder;

  ExactSeason(this.id, this.color, this.bounds, {this.startWeek, this.endWeek, this.length, this.reversedOrder = false});


  bool contains(DateTime day){
    return this.bounds.contains(day);
  }

}

class ExactHolyDay{
  String id, color;
  DateTime date;
  String type, title;
  bool optionalCelebrationSunday, overlapsAnyDay;
  DateTime dateTransferredFrom;

  ExactHolyDay(this.id, this.color, this.date, {this.type, this.title, this.optionalCelebrationSunday = false, this.dateTransferredFrom, this.overlapsAnyDay});
}

class StaticHolyDay{
  String id, color;
  int month, day;
  String type, title;
  bool optionalCelebrationSunday;
  int length;
  String lengthUnit;

  StaticHolyDay(this.id, this.color, this.month, this.day, {this.type, this.title, this.optionalCelebrationSunday = false,});
}

// globals ??= createCalendar




