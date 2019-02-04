//import '../bibleParse/formats/usx.dart';
import '../bibleParse/bible_format.dart';
import 'package:flutter/material.dart';

class Bible extends Object {
  final String abbreviation;
  final String language;
  final BibleFormat bibleFormat;
  final String title;

  Bible({
    @required this.title,
    @required this.language,
    @required this.bibleFormat,
    @required this.abbreviation,
  });
}

