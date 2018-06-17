import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializeCalendar.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'package:world_liturgy_app/json/xml_parser.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/service.dart';

class DailyCollect extends StatefulWidget {
  const DailyCollect({ Key key }) : super(key: key);

  @override
  _DailyCollectState createState() => new _DailyCollectState();
}

class _DailyCollectState extends State<DailyCollect> {
  Collect collect;

  _DailyCollectState() {
    globals.db.fetchSeasonOrFeast('pentecost8', 0).then((collectIndexes) => setState(() {
      collect = globals.allPrayerBooks
          .prayerBooks[collectIndexes.prayerBookIndex]
          .services[collectIndexes.serviceIndex]
          .sections[collectIndexes.sectionIndex]
          .collects[collectIndexes.collectIndex];
    }));
  }


  @override
  Widget build(BuildContext context) {

    return new Text(collect == null ? '' : collect.collectPrayers[0].text);

  }

}
