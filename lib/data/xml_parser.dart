import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'dart:async';
import 'dart:io';

Future<String> _loadXmlAsset() async {
//  if no prayerbook file, load sample file
  try {
    return await rootBundle.loadString('assets/data/prayerBooks.xml');
  } catch(_) {
    return await rootBundle.loadString('assets/data/prayerBooksSample.xml');
  }

}

Future<PrayerBooksContainer> loadXml() async {
  String rawXml = await _loadXmlAsset();

//Regex that removes line breaks between elements -- this allows the
//  annoying parser to correctly parse the data.
  rawXml = rawXml.replaceAll(new RegExp(r">\n( +)?<"), '><');
//  var parsedXml = xml.parse(rawXml);
  final Xml2Json myTransformer = new Xml2Json();
  myTransformer.parse(rawXml);
  final jsonString =  myTransformer.toGData();
//  var jsonMap = json.decode(jsonString);
  PrayerBooksContainer allPrayerBooks = PrayerBooksContainer.fromJson( json.decode(jsonString)["prayer_books"]);

  return allPrayerBooks;
}
