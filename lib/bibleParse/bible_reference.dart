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

  BibleRef.fromString(String refString){
    this.bookAbbr = "Abb";
  }

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
    } else if (this.refType == 'Book') {
      return 10000;
    }

    return _chapter;
  }

  int get endingVerse {
    if (_endingVerse != null) {
      return _endingVerse;
    } else if (this.refType == 'Verse') {
      return _verse;
    } else {
      return 10000;
    }
  }

  Map<String, String> get printRef {
    Map<String, String> output = {
      'type': this.refType,
      'book': bookAbbr,
      'content': '',
    };
    if (output['type'] == 'Chapter') {
      output['content'] = _chapter.toString();
    } else if (output['type'] == "Verse") {
      output['content'] = _chapter.toString() + ':' + _verse.toString();
    } else if (output['type'] == "Passage") {
      String endingRef = endingChapter.toString();
      if (endingVerse != null) {
        endingRef += ':' + endingVerse.toString();
      }
      output['content'] =
          _chapter.toString() + ':' + _verse.toString() + '-' + endingRef;
    } else if (output['type'] == 'Passage - Single Chapter') {
      output['content'] = _chapter.toString() +
          ':' +
          _verse.toString() +
          "-" +
          _endingVerse.toString();
    }

    return output;
  }

  String get refType {
    if (_chapter == null && _endingChapter == null) {
      return 'Book';
    } else if (_endingChapter == null && _endingVerse == null) {
      if (_verse == null) {
        return 'Chapter';
      } else {
        return 'Verse';
      }
    } else if (_endingChapter == null) {
      return 'Passage - Single Chapter';
    } else {
      return 'Passage';
    }
  }
}


List<dynamic> parseStringReference(String ref){
    String book = ref.trim().substring(0,3);
    String versesList = ref.trim().replaceRange(0,3,'').replaceAll(RegExp(r"[^0-9:,-]"), '');

    if (versesList.isNotEmpty){
      List<dynamic> list = [];
      int chapter;

      for(String v in versesList.split(',')){
        List<String> bounds = v.split('-');


        Map<String, int> attr = {'c': null, 'v': null, 'e_c': null, 'e_v': null};
        try {

//        if bounds[0] contains ":" -> chapter & verse
//        if chapter != null and !":" -> (assumed chapter) & verse
//        if chapter == null and !":" -> chapter only

//        references whole chapters
        if(chapter == null && !bounds[0].contains(":")) {
          attr['c'] = int.parse(bounds[0]);
          attr['v'] = 1;

//          references explicit chapter verse
        } else if (bounds[0].contains(":")) {
          List beg = bounds[0].split(':');
          attr['c'] = int.parse(beg[0]);
          attr['v'] = int.parse(beg[1]);
          chapter = int.parse(beg[0]);
        } else {
          attr['c'] = chapter ?? 1;
          attr['v'] = int.parse(bounds[0]);
        }

        if(bounds.length == 2){
          if(chapter == null && !bounds[1].contains(":")) {
            attr['e_c'] = int.parse(bounds[1]);

//          references explicit chapter verse
          } else if (bounds[1].contains(":")) {
            List end = bounds[1].split(':');
            attr['e_c'] = int.parse(end[0]);
            attr['e_v'] = int.parse(end[1]);
            chapter = int.parse(end[0]);
          } else {
            attr['e_c'] = chapter ?? 1;
            attr['e_v'] = int.parse(bounds[1]);
          }
        }

          list.add(
              BibleRef(book, attr['c'], attr['v'], attr['e_c'], attr['e_v']));
        } catch (e){
          list.add(false);
        }
      }
      return list;
    } else {
      return [BibleRef(book)];
    }

}


