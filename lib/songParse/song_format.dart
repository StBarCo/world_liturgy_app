//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:xml/xml.dart';

///The BibleParser will be a master package designed to read various formats of the Bible
///and output them in a flutter readable format. /parts contains generic methods/classes to render a passage.
/// Each format will have a package/or dart file which will handle creation/display of passage by implementing
/// methods in /parts.

class SongFormat extends Object {
  ///  The base class of a format. This class should never be implemented on its own,
  ///  but will be extended and customized for each format. There are basic methods
  ///  which should always be overriden in extended classes.

  final String path;
  List<SongEntry> _songList;

  SongFormat({
    @required this.path,
  });

  Future<List<Widget>> renderSong(SongEntry songEntry) async {
    print(_overridePrompt + 'getChapter()');
    List<Widget> song = [Text("Song Text will go in here.")];
    return song;
//    return [Text(_overridePrompt + 'getChapter()')];
  }

  Text renderTitle() {
    print(_overridePrompt + 'getChapter()');
    return Text("Song Title");
  }

  openSongBook(String bookAbbr) {
    return null;
  }

  get songList {
    return _songList;
  }

  final String _overridePrompt =
      'Override this method in your extended format class: ';

  String availableSongFormatsInfo() {
    String output = 'Current SongFormats: \n';

//    openSong
    output +=
        '''Each song is a single XML file with the following basic structure:
    <song>
      <title>... </title>
      <lyrics> multi-line text with the following headers: 
      [sectionType] => [INTRO], [# verse], [C => chorus]..., 
      '.' => ,
      lyrics
      
      see http://www.opensong.org/home/file-formats
      
     ''';

//    WLPFormat
    output += '''WLP format is a single file xml format...
    
    ''';

    print(output);

    return output;
  }

  Future<XmlDocument> loadXML(fileName) async {
    String xmlAsString = await getStringFromFile(fileName);
    xmlAsString.replaceAll(new RegExp(r">\r\n( +)?<"), '><');
    return parse(xmlAsString.replaceAll(new RegExp(r">\r\n( +)?<"), '><'));
  }

  /// Assumes the given path is a text-file-asset.
  Future<String> getStringFromFile(String path) {
    return rootBundle.loadString(path);
  }

  Future<Map> loadJson(fileName) async {
    String xmlAsString = await getStringFromFile(fileName);
    xmlAsString.replaceAll(new RegExp(r">\r\n( +)?<"), '><');

    final Xml2Json myTransformer = new Xml2Json();
    myTransformer
        .parse(xmlAsString.replaceAll(new RegExp(r">\r\n( +)?<"), '><'));

    return json.decode(myTransformer.toGData());
  }

  String getTextProperty(Map map) {
    return clean(map['\$t']);
  }

  String clean(String s) => s?.replaceAll(new RegExp(r"\\r\\n+ *|\\|\|*"), '');

}


class SongEntry extends Object {
  String title;
  int number;
  String subtitle;
  dynamic location;

  SongEntry(
      {@required this.title,
      this.number,
      this.subtitle,
      @required this.location,});
}
