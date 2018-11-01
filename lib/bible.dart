import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/model/calendar.dart';
import 'package:world_liturgy_app/app.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:world_liturgy_app/collects.dart';

class BiblePage extends StatefulWidget{
  BiblePage({Key key}) : super(key:key);

  @override
  _BiblePageState createState() {
    return new _BiblePageState();
  }
}

class _BiblePageState extends State<BiblePage> {
  String currentLanguage;
  Day currentDay;

  _BiblePageState();

  @override
  Widget build(BuildContext context) {
    final refreshState = RefreshState.of(context);
    currentLanguage = refreshState.currentLanguage;
    currentDay = refreshState.currentDay;


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bible'),
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text("The Bible Will Go Here Boys and Girls"),



          ],
        ),
      ),

    );
  }
}
