import '../song_format.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import '../parts.dart';

/// WLP Song format is a single file XML that contains a single song book.
class WLPSongBook extends SongFormat {
  List<SongEntry> _songList;
  Map songBook;

  WLPSongBook({
    path,
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

    Map song = songBook['song'][songEntry.location];

    int refrainLocation;

    if(song.containsKey('refrain')){
      if(song['refrain'].containsKey('afterVerse')){
        refrainLocation = song['refrain']['afterVerse'];
      } else {
        refrainLocation = 1;
      }
    }

    List<Widget> passage = [];

    int currentVerse = 0;

    for (Map verse in song['verse']) {
      if(currentVerse == refrainLocation){
        List<String> stanzas = [];
        for(Map stanza in song['refrain']['stanza']){
          stanzas.add(getTextProperty(stanza));
        }
        passage.add(refrain(stanzas));
      }
      currentVerse ++;

      List<String> verseStanzas = [];
      for(Map stanza in verse['stanza']){
        verseStanzas.add(getTextProperty(stanza));
      }
      passage.add(verseRow(verseStanzas, currentVerse));

    }
    passage.add(Container(
      height: 100.0,
    ));

    return passage;
  }

  initializeSongBook() async {
    Map data = await loadJson(path);
    songBook = data['book'];
    _songList = initializeTableOfContents();
//    setBooksAndChapters(bible);
  }

  List<SongEntry> initializeTableOfContents() {
//    Map<String, Map<String, dynamic>> toc = {};
    List songs = songBook['song'];
    List<SongEntry> songEntries = [];
    for (int index = 0; index < songs.length; index++) {
      Map song = songs[index];
      songEntries.add(SongEntry(
        title: getTextProperty(song['title']),
        location: index,
        number: song.containsKey('number')
            ? int.parse(getTextProperty(song['number']))
            : null,
        subtitle: song.containsKey('subtitle')
            ? getTextProperty(song['subtitle'])
            : null,
      ));
    }
    return songEntries;
  }
}
