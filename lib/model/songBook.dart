
import '../songParse/song_format.dart';
import 'package:flutter/material.dart';

class SongBook extends Object{
  final String language;
  final SongFormat songFormat;
  final String title;

  SongBook({
    @required this.title,
    @required this.language,
    @required this.songFormat,
  });

}
