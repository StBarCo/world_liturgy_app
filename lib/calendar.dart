

final Map<int,String> easterMap = {2014: '2014-04-20', 2015: '2015-04-05', 2016: '2016-03-27', 2017: '2017-04-16', 2018: '2018-04-01', 2019: '2019-04-21', 2020: '2020-04-12', 2021: '2021-04-04', 2022: '2022-04-17', 2023: '2023-04-09', 2024: '2024-03-31', 2025: '2025-04-20', 2026: '2026-04-05', 2027: '2027-03-28', 2028: '2028-04-16', 2029: '2029-04-01', 2030: '2030-04-21', 2031: '2031-04-13', 2032: '2032-03-28', 2033: '2033-04-17', 2034: '2034-04-09', 2035: '2035-03-25', 2036: '2036-04-13', 2037: '2037-04-05', 2038: '2038-04-25', 2039: '2039-04-10', 2040: '2040-04-01', 2041: '2041-04-21', 2042: '2042-04-06', 2043: '2043-03-29', 2044: '2044-04-17', 2045: '2045-04-09', 2046: '2046-03-25', 2047: '2047-04-14', 2048: '2048-04-05', 2049: '2049-04-18', 2050: '2050-04-10', 2051: '2051-04-02', 2052: '2052-04-21', 2053: '2053-04-06', 2054: '2054-03-29', 2055: '2055-04-18', 2056: '2056-04-02', 2057: '2057-04-22', 2058: '2058-04-14', 2059: '2059-03-30', 2060: '2060-04-18', 2061: '2061-04-10', 2062: '2062-03-26', 2063: '2063-04-15', 2064: '2064-04-06', 2065: '2065-03-29', 2066: '2066-04-11', 2067: '2067-04-03', 2068: '2068-04-22', 2069: '2069-04-14', 2070: '2070-03-30', 2071: '2071-04-19', 2072: '2072-04-10', 2073: '2073-03-26', 2074: '2074-04-15', 2075: '2075-04-07', 2076: '2076-04-19', 2077: '2077-04-11', 2078: '2078-04-03', 2079: '2079-04-23', 2080: '2080-04-07', 2081: '2081-03-30', 2082: '2082-04-19', 2083: '2083-04-04', 2084: '2084-03-26', 2085: '2085-04-15', 2086: '2086-03-31', 2087: '2087-04-20', 2088: '2088-04-11', 2089: '2089-04-03', 2090: '2090-04-16', 2091: '2091-04-08', 2092: '2092-03-30', 2093: '2093-04-12', 2094: '2094-04-04', 2095: '2095-04-24', 2096: '2096-04-15', 2097: '2097-03-31', 2098: '2098-04-20', 2099: '2099-04-12', 2100: '2100-03-28'
};


class Calendar {

  final calendarStructure = {
    'type': 'western',
    'calendar': [
      
    ]
  };

}

class Feast extends Object{

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

  DateTime findDate(int year){
    if (type == 'fixed'){
      return new DateTime(year, month, day);
    } else if (calculatedDates != null) {
      if (adjuster == null) {
        return DateTime.parse(calculatedDates[year]);
      } else {
        return DateTime.parse(calculatedDates[year]).add(new Duration(days: adjuster));
      }
    } else {
      throw 'date is not in accepted format to find date. Must either be type:fixed have a calculatedDates map.';
    }
  }

  DateTime findAdventStart(int year){
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


//iterator to print:
//for (int year = 2018; year < 2031; year++){
//print('Advent:');
//print(new Feast.christmas().findAdventStart(year-1));
//print('Christmas:');
//print(new Feast.christmas().findDate(year-1));
//print('Ash Wednesday:');
//print(new Feast.ashWednesday().findDate(year));
//print('Easter:');
//print(new Feast.easter().findDate(year));
//print('Ascension:');
//print(new Feast.ascension().findDate(year));
//print('Pentecost:');
//print(new Feast.pentecost().findDate(year));
//print('Trinity Sunday:');
//print(new Feast.trinitySunday().findDate(year));
//}
//}