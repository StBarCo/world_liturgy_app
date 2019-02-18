import 'package:flutter/material.dart';
import 'styles.dart';

Padding refrain(List<String> stanzas) {
  List<Widget> list = [];

//  list.add(new Text('Refrain' + ':', style: headerStyle()));
//      .merge(referenceAndSubtitleStyle),));

  for (var stanza in stanzas) {
    list.add(Text(stanza, style: refrainTextStyle()));
  }

  return new Padding(
    padding: EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    ),
  );
}

Widget verseRow(List<String> verse, [int vNumber]) {
  String verseHeader = '';
  if(vNumber != null){
    verseHeader = vNumber.toString() + '.';
  }
  return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 30.0,
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              verseHeader,
              style: headerStyle(),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: makeVerse(verse),
          ),
        ],
      )
  );
}

Widget makeVerse(List<String> verse) {
  List<Widget> list = [];
  for (String stanza in verse) {
    list.add(Text(stanza, style: generalTextStyle()),);
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: list,
  );
}