import '../bible_format.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import '../parts.dart';
import '../bible_reference.dart';

/// Methods used to parse the zenfania bible xml.
/// Zenfania xml does not have a reliable book order, or book titles.
/// Therefore these must be supplied in the booksData map.
/// key - the 3 letter standart abbreviation from BibleFormat.standardAbbreviations
/// attributes:
///     title - book title
///     bnumber - bnumber attribute from <BIBLEBOOK bnumber=xxx> in xml.
/// is passed a booksData map which must
class ZenfaniaBible extends BibleFormat {
  Map<String, Map<String, String>> bookTitlesMap;
  Map bible;

  ZenfaniaBible({
    path,
    this.bookTitlesMap,
  }) : super(path: path) {
    initializeBible();
  }

  @override
  Map getBookTitlesAndChapters() {
    return bookTitlesMap;
  }

  @override
  Future<List<Widget>> renderPassage(BibleRef ref) async {
    String bnumber = bookTitlesMap[ref.bookAbbr]['bnumber'].toString();
    var bookMap = bible["XMLBIBLE"]["BIBLEBOOK"]
        .firstWhere((var book) => book["bnumber"] == bnumber);

    List<Widget> passage = [];

    int currentChapter = ref.chapter;

    for (var chapter in bookMap["CHAPTER"]) {
      int currentVerse = 0;
      currentChapter = int.parse(chapter['cnumber']);
      if (afterPassage(currentChapter, currentVerse, ref)) {
        break;
      }

      if (currentChapter >= ref.chapter) {
        if (ref.refType == 'Book' ||
            inPassage(currentChapter, currentVerse, ref)) {
          passage.add(BibleChapterHeader(currentChapter.toString()));
        }

        for (var verse in chapter["VERS"]) {
          currentVerse = int.parse(verse["vnumber"]);

          if (inPassage(currentChapter, currentVerse, ref)) {
            passage.add(BibleBasicText([
              {'vNumber': currentVerse.toString()},
              verse['\$t'],
            ]));
          } else if (afterPassage(currentChapter, currentVerse, ref)) {
            break;
          }
        }
      }
    }
    passage.add(Container(
      height: 100.0,
    ));

    return passage;
  }

  bool inPassage(int chapter, int verse, BibleRef ref) {
    if (chapter > ref.endingChapter || chapter < ref.chapter) {
      return false;
    } else if (chapter >= ref.endingChapter && verse > ref.endingVerse) {
      return false;
    } else if (chapter == ref.chapter && verse < ref.verse) {
      return false;
    }
    return true;
  }

  bool beforePassage(int chapter, int verse, BibleRef ref) {
    if (chapter < ref.chapter) {
      return true;
    } else if (chapter == ref.chapter && verse < ref.verse) {
      return true;
    }
    return false;
  }

  bool afterPassage(int chapter, int verse, BibleRef ref) {
    if (chapter > ref.endingChapter) {
      return true;
    } else if (chapter == ref.endingChapter && verse > ref.endingVerse) {
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

  initializeBible() async {
    Map data = await loadJson(path);
    bible = data;
    setBooksAndChapters(bible);
  }

  /// must be a Map with the following properties:
  /// abbr - abbreviation which matches
  /// bnumber - int
  /// title - title
  setBooksAndChapters(Map bible) {
    List bookList = bible["XMLBIBLE"]["BIBLEBOOK"];

    bookTitlesMap.forEach((String key, Map<String, dynamic> attributes) {
      Map book = bookList.firstWhere(
          (book) => book['bnumber'] == attributes['bnumber'].toString());

      attributes['chapters'] = book['CHAPTER'].length.toString();
    });
  }
}
