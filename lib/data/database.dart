import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseClient {
  Database _db;
  final _lock = new Lock();


  Future<Database> getDb() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'database.db');
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");


    _db = await openDatabase(dbPath, version: 9,
        onCreate: this._onCreate,
        onUpgrade: onDatabaseDowngradeDelete,
        onDowngrade: onDatabaseDowngradeDelete,
        );

//    set current day into globals

  }

  Future _onCreate(Database _db, int version) async {
    try {
      await _db.transaction((txn) async {
        await txn.execute('''
                CREATE TABLE days (
                  date INTEGER PRIMARY KEY, 
                  season TEXT NOT NULL,
                  weekID TEXT NOT NULL,
                  seasonColor TEXT NOT NULL,
                  principalFeastID TEXT,
                  principalColor TEXT,
                  principalOptionalCelebrationSunday TEXT,
                  holyDayID TEXT,
                  holyDayColor TEXT,
                  holyDayType TEXT,
                  weekServiceIndex INTEGER,
                  weekSectionIndex INTEGER,
                  weekCollectIndex INTEGER,
                  principalFeastServiceIndex INTEGER,
                  principalFeastSectionIndex INTEGER,
                  principalFeastCollectIndex INTEGER,
                  holyDayServiceIndex INTEGER,
                  holyDaySectionIndex INTEGER,
                  holyDayCollectIndex INTEGER
                )''');

        await txn.execute('''
                CREATE TABLE prayers (
                  id TEXT NOT NULL,
                  prayerBookIndex INTEGER NOT NULL,
                  serviceIndex INTEGER NOT NULL,
                  sectionIndex INTEGER NOT NULL,
                  collectIndex INTEGER NOT NULL
                )''');

        var batch = txn.batch();

        List days = await calculateCalendarsForDatabase();

        days.forEach((day) => batch.insert('days', day));


//
//        List collects = calculateSeasonsAndFeastsIndexForDatabase();
//
//        collects.forEach((collect) => batch.insert('prayers', collect));

        await batch.commit(noResult: true);

//      TODO: Iterate through collects and compare prayerbooks index numbers
//      TODO: Iterate through list of days and check that all ids have matching collects -- print in console any differences
//        TODO: on database create print calendar into the log.
//      TODO: remove prayerbook index from seasons and feasts and make id primary key
//      TODO: make seasonsandFeast primary key a foreign key for the calendar table.

      });
    } catch (e, s) {
      print(s);
    }

//    var count = Sqflite
//        .firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM seasonsAndFeasts"));
//    assert(count == 2);


  }

  Future insertDay(Day day) async {
    dynamic newDay =  await _db.insert("days", day.toMap());

    return newDay;
  }

  Future insertSeasonOrFeast(Prayer collect) async {
    dynamic newCollect =  await _db.insert("prayers", collect.toMap());

    return newCollect;
  }

  Future fetchDay(int date) async {
    dynamic results = await _db.query("days", columns: Day.columns, where: "date = ?", whereArgs: [date]);
//    List<Map> list = await _db.rawQuery('SELECT * FROM calendar');
//    dynamic results = await _db.rawQuery(
//      '''SELECT
//            date,
//            season,
//            weekID,
//            seasonColor,
//            principalFeastID,
//            principalColor,
//            principalOptionalCelebrationSunday,
//            holyDayID,
//            holyDayColor,
//            holyDayType,
//            weekServiceIndex,
//            weekSectionIndex,
//            weekCollectIndex,
//            principalFeastServiceIndex,
//            principalFeastSectionIndex,
//            principalFeastCollectIndex,
//            holyDayServiceIndex,
//            holyDaySectionIndex,
//            holyDayCollectIndex
//
//        FROM days days
//
//        LEFT JOIN prayers weekIndex ON days.weekID=weekIndex.id
//        LEFT JOIN prayers feastIndex ON feastIndex.id = days.holyDayID
//        LEFT JOIN prayers holyDayIndex ON holyDayIndex.id = days.principalFeastID
//
//        WHERE date = ?
//      ''', [date]);


    if (results.length == 0){
      return null;
    } else {
      Day activeDay = Day.fromMap(results[0]);

      return activeDay;
    }
  }

  Future fetchSeasonOrFeast(String id, int prayerBookIndex) async {
    dynamic results = await _db.query("prayers", columns: Prayer.columns, where: "id = ? AND prayerBookIndex = ?", whereArgs: [id, prayerBookIndex]);

    Prayer seasonOrFeast = Prayer.fromMap(results[0]);

    return seasonOrFeast;
  }


}