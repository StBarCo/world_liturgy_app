import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'dart:async';

import 'serializePrayerBook.dart';
import 'serializeCalendar.dart';
import 'serializeSongBook.dart';

Future<String> _loadXmlAsset(fileName) async {
//  if no prayerbook file, load sample file
  final basePath = 'assets/wlp_format/docs/';
  final extension = '.xml';
  final sample = 'Sample';

  try {
    return await rootBundle.loadString(basePath + fileName + extension);
  } catch(_) {
    return await rootBundle.loadString(basePath + fileName + sample + extension);
  }

}

Future<String> _loadAndParseXmltoJson(fileName) async {
  String rawXml = await _loadXmlAsset(fileName);

//Regex that removes line breaks between elements -- this allows the
//  annoying parser to correctly parse the data.
  rawXml = rawXml.replaceAll(new RegExp(r">\n( +)?<"), '><');
//  var parsedXml = xml.parse(rawXml);
  final Xml2Json myTransformer = new Xml2Json();
  myTransformer.parse(rawXml);
  final jsonString =  myTransformer.toGData();

  return jsonString;
}

Future<PrayerBooksContainer> loadPrayerBooks() async {
  String jsonString = await _loadAndParseXmltoJson('prayerBooks');
  return PrayerBooksContainer.fromJson(json.decode(jsonString)["prayer_books"]);
}

Future<CalendarScaffold> loadCalendar() async {
  String jsonString = await _loadAndParseXmltoJson('calendar');
  return CalendarScaffold.fromJson(json.decode(jsonString)["calendar"]);
}

Future<Map> loadCalendarAsJSON() async{
  String jsonString = await _loadAndParseXmltoJson('calendar');
  return json.decode(jsonString)["calendar"];
}

Future<SongBooksContainer> loadSongBooks() async {
  String jsonString = await _loadAndParseXmltoJson('songBooks');
  return SongBooksContainer.fromJson(json.decode(jsonString)["songbooks"]);
}
