import '../bible_format.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'dart:core';
import '../parts.dart';
import '../bible_reference.dart';

class USXBible extends BibleFormat {
  final String publicationID;
  Map<String, XmlDocument> booksData = {};
  Map bibleMetadata;
  Map<String, Map<String, dynamic>> bookTitlesAndChapters;

  USXBible({
    path,
    this.publicationID,
  }) : super(path: path) {
    initializeMetadata();
  }

  @override
  Map getBookTitlesAndChapters() {
    return bookTitlesAndChapters;
  }

  @override
  Future<List<Widget>> renderPassage(BibleRef ref) async {
    XmlDocument bookXml;
    if (booksData.containsKey(ref.bookAbbr)) {
      bookXml = booksData[ref.bookAbbr];
    } else {
      bookXml = await getFutureBook(ref.bookAbbr);
      booksData[ref.bookAbbr] = bookXml;
    }
    List<Widget> passage = [];

    Iterable<XmlNode> xmlStart;

    if (ref.refType == 'Book') {
      xmlStart = bookXml
          .findElements('usx')
          .first
          .children;
    } else {
      xmlStart = bookXml
          .findElements('usx')
          .first
          .findElements('chapter')
          .firstWhere((ch) =>
      ch is XmlElement &&
          ch.getAttribute('number') == ref.chapter.toString())
          .following;
    }

    int currentChapter = ref.chapter;
    int currentVerse = 0;


    for (var node in xmlStart) {



      if (node is XmlElement) {
        String type = node.name.qualified;
        String elementStyle = node.getAttribute('style');
        if (type == 'chapter') {
          currentChapter = int.parse(node.getAttribute("number"));

          currentVerse = 0;
          if(!inPassage(currentChapter, currentVerse, ref)) {
            break;
          }

          if (ref.refType != 'Chatper' && ref.refType != "Passage - Single Chapter"){
            passage.add(BibleChapterHeader(currentChapter.toString()));
          }
        } else if (type == 'para' && !isIgnoredParagraphStyle(elementStyle)) {
          if (isIgnoredParagraphStyle(elementStyle)) break;
          List paragraphParts = [];
          for (var child in node.children) {
            var content;

            if (child is XmlElement) {
//              if verse check for break conditions
              if (child.name.qualified == 'verse') {
                currentVerse = int.parse(child.getAttribute('number'));
                content = {'vNumber': currentVerse.toString()};
//                'wj' style is words of Jesus -- render as normal text
              } else if (child.name.qualified == 'char' &&
                  child.getAttribute('style') == 'wj') {
                content = child.text;
              }
            } else {
              content = child.text;
            }

            if (inPassage(currentChapter, currentVerse, ref) ){
              paragraphParts.add(content);
            }

          }
          if(paragraphParts.isNotEmpty){
            passage
                .add(selectParagraphBuilder(elementStyle.trim(), paragraphParts));
          }
          if (afterPassage(currentChapter, currentVerse, ref) ){
            break;
          }

        }
      }
    }

    //          add blank space at bottom of chapter
    passage.add(Container(
      height: 100.0,
    ));

    return passage;
  }

  bool inPassage(int chapter, int verse, BibleRef ref){
    if(chapter > ref.endingChapter || chapter < ref.chapter) {
      return false;
    } else if(chapter >= ref.endingChapter &&
        verse > ref.endingVerse) {
      return false;
    } else if(chapter == ref.chapter && verse < ref.verse) {
      return false;
    }
    return true;
  }

  bool beforePassage(int chapter, int verse, BibleRef ref){
    if(chapter < ref.chapter) {
      return true;
    } else if(chapter == ref.chapter && verse < ref.verse) {
      return true;
    }
    return false;
  }

  bool afterPassage(int chapter, int verse, BibleRef ref){
    if(chapter > ref.endingChapter) {
      return true;
    } else if(chapter == ref.endingChapter &&
        verse > ref.endingVerse) {
      return true;
    }
    return false;

  }

  @override
  int getChaptersInBook(book) {
    print('getChaptersInBook()');

    return null;
  }

  @override
  int getVersesInChapter(chapter) {
    print('getVersesInChapter()');
    return null;
  }

  initializeMetadata() async {
    Map data = await loadJson(path + '/metadata.xml');
    bibleMetadata = data;
    String versification =
    await getStringFromFile(path + '/release/versification.vrs');
    setBooksAndChapters(versification);
  }

//  openBook(String book) {
//    waitForBook(book, bookTitlesAndChapters[book]['src']);
////    return true;
//  }

  Future<XmlDocument> getFutureBook(bookAbbrev) async {
    return loadXML(path + '/' + bookTitlesAndChapters[bookAbbrev]['src']);
  }

  setBooksAndChapters(String versificationData) {
    Map<String, Map<String, dynamic>> masterMap = {};

    List bookList = bibleMetadata['DBLMetadata']['publications']['publication']
        .firstWhere((e) => e['id'] == publicationID)['structure']['content'];

    List bookTitlesList = bibleMetadata['DBLMetadata']['names']['name'];

    bookList.forEach((element) {
      Map bookTitles =
      bookTitlesList.firstWhere((e) => e['id'] == element['name']);

      masterMap[element['role']] = {
        'src': element['src'],
        'abbr': bookTitles['abbr']['\$t'],
        'title': bookTitles['short']['\$t'],
        'long': bookTitles['long']['\$t'],
      };
    });

    List<String> chapterCounts = versificationData
        .split('#')
        .firstWhere((String s) => s.startsWith(" Verse number is the maximum "))
        .split('\n');

    chapterCounts.forEach((String data) {
      List asList = data.split(' ');

      if (masterMap.containsKey(asList.first)) {
        masterMap[asList.first]['chapters'] =
            asList.last
                .split(':')
                .first
                .toString();
      }
    });

    bookTitlesAndChapters = masterMap;
  }

  waitForBook(String abbr, String bookLocation) async {
    booksData[abbr] = await loadXML(path + '/' + bookLocation);

//    return currentXMLBook;
  }

  selectParagraphBuilder(String style, List parts) {
    if (['p,m'].contains(style)) {
      return BibleParagraphBasic(parts);
    } else if (['pm,pmo, pmc, mi'].contains(style)) {
      return BibleParagraphIndented(parts);
    } else if (style == 'pmr') {
      return BibleParagraphIndented(parts, TextAlign.right);
    } else if (style == 'nb') {
      return BibleParagraphNoBreak(parts);
    } else if (style == 'b') {
      return BiblePoetryBlankLine();
    } else if (['sp', 'd'].contains(style)) {
      return BiblePassageHeading(parts);
    } else if (['ms1'].contains(style)) {
      return BibleMajorSection(parts);
    } else if (['q', 'q1', 'q2', 'q3', 'q4', 'qc', 'qr', 'qs']
        .contains(style)) {
      int indent = int.tryParse(style
          .split('')
          .last) ?? 0;
      return BiblePoetryStanza(parts, indent);
    } else {
      return BibleParagraphBasic(parts);
    }
//    d, b, sp, li1, nb,
  }

  bool isIgnoredParagraphStyle(style) {
    List<String> ignoredStyles = [
//      'ms1',
      'ide',
      'toc1',
      'toc2',
      'toc3',
      'mt1',
    ];

    return ignoredStyles.contains(style);
  }
}

