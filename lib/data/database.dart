import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:synchronized/synchronized.dart';
import 'package:world_liturgy_app/globals.dart' as globals;

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


    _db = await openDatabase(dbPath, version: 1,
        onCreate: this._onCreate);
  }

  Future _onCreate(Database _db, int version) async {
    await _db.transaction((txn) async {
      await txn.execute('''
              CREATE TABLE calendar (
                date int PRIMARY KEY, 
                season TEXT NOT NULL,
                weekId TEXT NOT NULL,
                seasonColor TEXT NOT NULL,
                principalFeastId TEXT,
                principalColor TEXT,
                principalOptionalCelebrationSunday TEXT,
                holyDayId TEXT,
                holyDayColor TEXT,
                holyDayType TEXT
              )''');

      await txn.execute('''
              CREATE TABLE seasonsAndFeasts (
                id TEXT NOT NULL,
                prayerBookIndex INTEGER NOT NULL,
                serviceIndex INTEGER NOT NULL,
                sectionIndex INTEGER NOT NULL,
                collectIndex INTEGER NOT NULL
              )''');

      var batch = txn.batch();

      List days = await calculateCalendarsForDatabase();

      days.forEach((day) => batch.insert('calendar', day));



      List collects = calculateSeasonsAndFeastsIndexForDatabase();

      collects.forEach((collect) => batch.insert('seasonsAndFeasts', collect));

      await batch.commit(noResult: true);

//      TODO: Iterate through Collects and Add Indexes to DB.

    });

    var count = Sqflite
        .firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM seasonsAndFeasts"));
//    assert(count == 2);


  }

  Future insertDay(Day day) async {
    dynamic newDay =  await _db.insert("calendar", day.toMap());

    return newDay;
  }

  Future insertSeasonOrFeast(SeasonOrFeast collect) async {
    dynamic newCollect =  await _db.insert("calendar", collect.toMap());

    return newCollect;
  }

  Future fetchDay(int date) async {
    dynamic results = await _db.query("calendar", columns: Day.columns, where: "date = ?", whereArgs: [date]);
//    List<Map> list = await _db.rawQuery('SELECT * FROM calendar');
    if (results == null){
      return null;
    } else {
      Day activeDay = Day.fromMap(results[0]);

      return activeDay;
    }
  }

  Future fetchSeasonOrFeast(String id, int prayerBookIndex) async {
    dynamic results = await _db.query("seasonsAndFeasts", columns: SeasonOrFeast.columns, where: "id = ? AND prayerBookIndex = ?", whereArgs: [id, prayerBookIndex]);

    SeasonOrFeast seasonOrFeast = SeasonOrFeast.fromMap(results[0]);

    return seasonOrFeast;
  }


}