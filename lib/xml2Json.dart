//import '../lib/json/xml_parser.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:xml2json/xml2json.dart';


void main() async {
  String rawXml = await File(p.current + '/assets/wlp_format/docs/prayerBooks.xml').readAsString();

  rawXml = rawXml.replaceAll(new RegExp(r">\n( +)?<"), '><');
//  var parsedXml = xml.parse(rawXml);
  final Xml2Json myTransformer = new Xml2Json();
  myTransformer.parse(rawXml);
  final jsonString =  myTransformer.toGData();

  File(p.current + '/assets/wlp_format/docs/prayerBooks.json').writeAsStringSync(jsonString);

}


