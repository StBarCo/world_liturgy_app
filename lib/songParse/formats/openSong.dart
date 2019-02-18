import '../song_format.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import '../parts.dart';

/// openSong format has a single file for each song.
/// This requires a map sent in as index giving song title
/// and location for each song.
///
class OpenSongBook extends SongFormat {
  List<SongEntry> _songList;
  final Map index;
  Map songCache = {};

  OpenSongBook({
    path,
    this.index,
//    this.bookTitlesMap,
  }) : super(path: path) {
    initializeSongBook();
  }

  @override
  get songList {
    return _songList;
  }

  @override
  Future<List<Widget>> renderSong(SongEntry songEntry) async {
    List<Widget> passage = [];

    dynamic song = songCache[songEntry.title];

    song ??= await loadJson(this.path + 'songs/' + songEntry.location);

    List<String> songLyrics = song['song']['lyrics']['\$t'].split('[');

    songLyrics.forEach((String lyric){
      List<String> verse = [];
      List<String> splitLyric = lyric.split('\\n');
      String verseIdentifier = splitLyric[0].replaceFirst(']','').toLowerCase();

      splitLyric.removeAt(0);

      splitLyric.removeWhere((stanza) => stanza.length == 0 || stanza[0] == '.' || stanza[0] == '-');

      splitLyric.forEach((stanza){
        verse.add(clean(stanza.trim()));
      });

      if(verse.length != 0){
        if(['c','c2','p','b', 'p'].contains(verseIdentifier)){
          passage.add(refrain(verse));
        } else {
          int verseHeader;
          if(verseIdentifier[0] == 'v') {verseIdentifier = verseIdentifier.substring(1);}
          try{
            verseHeader = int.parse(verseIdentifier);
          } catch (e){
            verseHeader = null;
          }
          passage.add(verseRow(verse, verseHeader));
        }
      }
    });

    passage.add(Container(
      height: 100.0,
    ));

    return passage;
  }

  initializeSongBook() async {
    _songList = initializeTableOfContents();
//    setBooksAndChapters(bible);
  }

  List<SongEntry> initializeTableOfContents() {
    List<SongEntry> songEntries = [];

    List sorted = index.keys.toList();
    sorted.sort();

    sorted.forEach((title) {
      songEntries.add(
        SongEntry(
          title: title,
          location: index[title],
        ),
      );
    });

    return songEntries;
  }
}
