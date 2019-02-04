//import 'dart:ui';
import 'package:flutter/material.dart';

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
      "gen": "Genesis",
      "exo": "Exodus",
      "lev": "Leviticus",
      "num": "Numbers",
      "deu": "Deuteronomy",
      "jos": "Joshua",
      "jdg": "Judges",
      "rut": "Ruth",
      "1sa": "1 Samuel",
      "2sa": "2 Samuel",
      "1ki": "1 Kings",
      "2ki": "2 Kings",
      "1ch": "1 Chronicles",
      "2ch": "2 Chronicles",
      "ezr": "Ezra",
      "neh": "Nehemiah",
      "est": "Esther",
      "job": "Job",
      "psa": "Psalm",
      "pro": "Proverbs",
      "ecc": "Ecclesiastes",
      "sng": "Song of Solomon",
      "isa": "Isaiah",
      "jer": "Jeremiah",
      "lam": "Lamentations",
      "ezk": "Ezekiel",
      "dan": "Daniel",
      "hos": "Hosea",
      "jol": "Joel",
      "amo": "Amos",
      "oba": "Obadiah",
      "jon": "Jonah",
      "mic": "Micah",
      "nam": "Nahum",
      "hab": "Habakkuk",
      "zep": "Zephaniah",
      "hag": "Haggai",
      "zec": "Zechariah",
      "mal": "Malachi",
      "mat": "Matthew",
      "mrk": "Mark",
      "luk": "Luke",
      "jhn": "John",
      "act": "Acts",
      "rom": "Romans",
      "1co": "1 Corinthians",
      "2co": "2 Corinthians",
      "gal": "Galatians",
      "eph": "Ephesians",
      "php": "Philippians",
      "col": "Colossians",
      "1th": "1 Thessalonians",
      "2th": "2 Thessalonians",
      "1ti": "1 Timothy",
      "2ti": "2 Timothy",
      "tit": "Titus",
      "phm": "Philemon",
      "heb": "Hebrews",
      "jas": "James",
      "1pe": "1 Peter",
      "2pe": "2 Peter",
      "1jn": "1 John",
      "2jn": "2 John",
      "3jn": "3 John",
      "jud": "Jude",
      "rev": "Revelation",
      "tob": "Tobit",
      "jdt": "Judith",
      "esg": "ESG",
      "wis": "Wisdom",
      "sir": "Sirach",
      "bar": "Baruch",
      "1ma": "1 Maccabees",
      "2ma": "2 Maccabees",
      "3ma": "3 Maccabees",
      "4ma": "4 Maccabees",
      "1es": "1 Esdras",
      "2es": "2 Esdras",
      "man": "Prayer of Manasses",
      "ps2": "Psalm 151",
      "dag": "The Book of Daniel with Greek Portions",
    };
  }
}

/// A generous reference system:
/// bookAbbr => whole book,
/// bookAbbr & chapter => individual chapter,
/// bookAbbr & chapter & verse => individual verse
///
/// endingChapter & endingVerse are inclusive
/// (e.g. endingChapter ==5  should return all of chapter 5 and then stop)
///
/// verse or endingVerse should not be used without chapter,
/// because different bible formats may have different logic
///
class BibleRef extends Object {
  String bookAbbr;

  int _chapter;
  int _verse;
  int _endingChapter;
  int _endingVerse;

  BibleRef(this.bookAbbr,
      [this._chapter, this._verse, this._endingChapter, this._endingVerse]);

  set chapter(int i) {
    _chapter = i;
  }

  set verse(int i) {
    _verse = i;
  }

  set endingChapter(int i) {
    _endingChapter = i;
  }

  set endingVerse(int i) {
    _endingVerse = i;
  }

  int get chapter {
    if (_chapter == null) {
      return 1;
    } else {
      return _chapter;
    }
  }

  int get verse {
    if (_verse == null) {
      return 1;
    } else {
      return _verse;
    }
  }

  int get endingChapter {
    if (_endingChapter != null) {
      return _endingChapter;
    } else {
      return _chapter;
    }
  }

  int get endingVerse {
    if (_endingVerse != null) {
      return _endingVerse;
    } else if (_chapter != null && _verse != null && _endingChapter == null) {
      return _verse;
    } else {
      return null;
    }
  }

  String get print {
    String type = this.refType;
    if (type == 'Book') {
      return bookAbbr;
    } else if (type == 'Chapter'){
      return bookAbbr + _chapter.toString();
    } else if (type == "Verse"){
      return bookAbbr + _chapter.toString() + ':' + _verse.toString();
    } else if (type == "Passage"){
      String endingRef = endingChapter.toString();
      if(endingVerse != null) {
        endingRef += ':' + endingVerse.toString();
      }
      return bookAbbr + _chapter.toString() + ':' + _verse.toString() + '-' + endingRef;
    } else if (type == 'Passage - Single Chapter'){
      return bookAbbr + _chapter.toString() + ':' + _verse.toString() + _endingVerse.toString();
    }
    return 'Unknown Passage Type';

  }

  String get refType {
    if (_chapter == null && _endingChapter == null) {
      return 'Book';
    } else if (_endingChapter == null && _endingVerse == null) {
      if (verse == null) {
        return 'Chapter';
      } else {
        return 'Verse';
      }
    } else if (_endingChapter != null) {
      return 'Passage - Single Chapter';
    } else {
      return 'Passage';
    }
  }
}
