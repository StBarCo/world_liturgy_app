//import 'dart:ui';
import 'package:flutter/material.dart';
import 'bible_reference.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:xml/xml.dart';


///The BibleParser will be a master package designed to read various formats of the Bible
///and output them in a flutter readable format. /parts contains generic methods/classes to render a passage.
/// Each format will have a package/or dart file which will handle creation/display of passage by implementing
/// methods in /parts.

class BibleFormat extends Object {
  ///  The base class of a format. This class should never be implemented on its own,
  ///  but will be extended and customized for each format. There are basic methods
  ///  which should always be overriden in extended classes.

  final String path;

  BibleFormat({
    @required this.path,
  });

  Future<List<Widget>> renderPassage(BibleRef reference) {
    print(_overridePrompt + 'getChapter()');
//    return [Text(_overridePrompt + 'getChapter()')];
  }

  int getChaptersInBook(book) {
    print(_overridePrompt + 'getChaptersInBook()');

    return null;
  }

  int getVersesInChapter(chapter) {
    print(_overridePrompt + 'getVersesInChapter()');
    return null;
  }

  openBook(String bookAbbr) {
    return null;
  }

  prefetchBook(String bookAbbr){
    return null;
  }

  Map getBookTitlesAndChapters() {
    return {
      'GEN': {
        'long': 'Full Title',
        'short': 'Short Title',
        'abbr': 'Abbreviation',
      },
      'EXO': {
        'long': 'Full Title',
        'short': 'Short Title',
        'abbr': 'Abbreviation',
      },
    };
  }

  final String _overridePrompt =
      'Override this method in your extended format class: ';

  Map<String, String> standardAbbreviations() {
    return {
      "GEN": "Genesis",
      "EXO": "Exodus",
      "LEV": "Leviticus",
      "NUM": "Numbers",
      "DEU": "Deuteronomy",
      "JOS": "Joshua",
      "JDG": "Judges",
      "RUT": "Ruth",
      "1SA": "1 Samuel",
      "2SA": "2 Samuel",
      "1KI": "1 Kings",
      "2KI": "2 Kings",
      "1CH": "1 Chronicles",
      "2CH": "2 Chronicles",
      "EZR": "Ezra",
      "NEH": "Nehemiah",
      "ETH": "Esther",
      "JOB": "Job",
      "PSA": "Psalm",
      "PRO": "Proverbs",
      "ECC": "Ecclesiastes",
      "SNG": "Song of Solomon",
      "ISA": "Isaiah",
      "JER": "Jeremiah",
      "LAM": "Lamentations",
      "EZK": "Ezekiel",
      "DAN": "Daniel",
      "HOS": "Hosea",
      "JOL": "Joel",
      "AMO": "Amos",
      "OBA": "Obadiah",
      "JON": "Jonah",
      "MIC": "Micah",
      "NAH": "Nahum",
      "HAB": "Habakkuk",
      "ZEP": "Zephaniah",
      "HAG": "Haggai",
      "ZEC": "Zechariah",
      "MAL": "Malachi",
      "MAT": "Matthew",
      "MRK": "Mark",
      "LUK": "Luke",
      "JHN": "John",
      "ACT": "Acts",
      "ROM": "Romans",
      "1CO": "1 Corinthians",
      "2CO": "2 Corinthians",
      "GAL": "Galatians",
      "EPH": "Ephesians",
      "PHP": "Philippians",
      "COL": "Colossians",
      "1TH": "1 Thessalonians",
      "2TH": "2 Thessalonians",
      "1TI": "1 Timothy",
      "2TI": "2 Timothy",
      "TIT": "Titus",
      "PHM": "Philemon",
      "HEB": "Hebrews",
      "JAS": "James",
      "1PE": "1 Peter",
      "2PE": "2 Peter",
      "1JN": "1 John",
      "2KN": "2 John",
      "3KN": "3 John",
      "JUD": "Jude",
      "REV": "Revelation",
      "TOB": "Tobit",
      "JDT": "Judith",
      "ESG": "ESG",
      "WIS": "Wisdom",
      "SIR": "Sirach",
      "BAR": "Baruch",
      "1MA": "1 Maccabees",
      "2MA": "2 Maccabees",
      "3MA": "3 Maccabees",
      "4MA": "4 Maccabees",
      "1ES": "1 Esdras",
      "2ES": "2 Esdras",
      "MAN": "Prayer of Manasses",
      "PS2": "Psalm 151",
      "DAG": "The Book of Daniel with Greek Portions",
    };
  }

  String availableBibleFormatsInfo(){
    String output = 'Current BibleFormats: \n';

//    USX
    output +=
    '''USXBIBLE: the USX format is defined by the Digital Library and is the format 
    for their online versions. There are many version open to the public domain
    and many others that can be used with permission from the publisher.
    
    USX bibles have a metadata.xml that defines book location and book order
    as well as the ability to have multiple canons (Catholic, Othodox, Protestant,
    etc.).
    
    Each book is its own .usx file, which is essentially an XML file. The xml
    is generally flat with chapters and paragraphs being siblings. Then verse
    numbers and text are inside of paragraphs.
    
    For more information see: https://app.thedigitalbiblelibrary.org/static/docs/usx/index.html
     ''';

//    zenfenia
    output +=
    '''Zenfania: is an single file xml Bible format. It is heirarchical:
    <XMLBIBLE>
      <BIBLEBOOK bnumber="1" bname="Genesis">
        <CHAPTER cnumber="1">
          <VERS vnumer="1">In the beginning...</VERS>
        </CHAPTER>
      </BIBLEBOOK>
    </XMLBIBLE>
    
    Zenfania does not have a standardized book name. So BibleParse assumes
    uses book number and assumes that books are listed in the traditional 
    Protestant order.
    
    
    For more information see: https://groups.google.com/forum/#!forum/zefania_xml 
    & http://www.bgfdb.de/zefaniaxml/bml/
    
    
    ''';

    print(output);

    return output;
  }

  Future<XmlDocument> loadXML(fileName) async {
    String xmlAsString = await getStringFromFile(fileName);
//    xmlAsString.replaceAll(new RegExp(r">( +)?\r?\n( +)?<"), '><');
    return parse(xmlAsString.replaceAll(new RegExp(r">( +)?\r?\n( +)?<"), '><'));
  }

  /// Assumes the given path is a text-file-asset.
  Future<String> getStringFromFile(String path) {
    return rootBundle.loadString(path);
  }

  Future<Map> loadJson(fileName) async {
    String xmlAsString = await getStringFromFile(fileName);
    xmlAsString.replaceAll(new RegExp(r"( +)?>\r\n( +)?<"), '><');

    final Xml2Json myTransformer = new Xml2Json();
    myTransformer.parse(xmlAsString.replaceAll(new RegExp(r"( +)?>\r\n( +)?<"), '><'));

    return json.decode(myTransformer.toGData());
  }

}

