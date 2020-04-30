import 'package:flutter/material.dart';

//import '../json/serializeSongBook.dart';
import '../theme.dart';
import 'songs.dart';
import '../model/songBook.dart';
import '../songParse/song_format.dart';

class SongPage extends StatelessWidget {

  final SongEntry song;
  final SongBook book;

  SongPage({ Key key, this.book, this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              songTitle(song),
              song.subtitle != null ?
              Text(
                song.subtitle ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .caption
                    .merge(referenceAndSubtitleStyle),
              ) : Container(),
            ],
          )
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
        child: FutureBuilder<List>(
          future: book.songFormat.renderSong(song),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container();
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children: snapshot.data,
                );
            }
          },
        ),
      ),
    );
  }


  List<Widget> _songBody(song, context) {
    List<Widget> widgets = [];

    int refrainLocation;

    if (song.refrain != null) {
      refrainLocation =
      song.refrain.afterVerse == null ? 1 : song.refrain.afterVerse;
    }

    for (var i = 0; i < song.verses.length; i++) {
      if (refrainLocation == i) {
        widgets.add(_refrain(song.refrain, context));
      }
      widgets.add(_verseRow(song.verses[i], i, context));
    }

    return widgets;
  }

  Padding _refrain(refrain, context) {
    List<Widget> list = [];

    list.add(new Text('Refrain' + ':', style: Theme
        .of(context)
        .textTheme
        .caption
        .merge(referenceAndSubtitleStyle),));

    for (var stanza in refrain.stanzas) {
      list.add(Text(stanza.text, style: Theme
          .of(context)
          .textTheme
          .bodyText1));
    }

    return new Padding(
      padding: EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  Widget _verseRow(verse, vNumber, context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 20.0,
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                (vNumber + 1).toString() + '.',
                style: Theme
                    .of(context)
                    .textTheme
                    .caption
                    .merge(referenceAndSubtitleStyle),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: _verse(verse, context),
            ),
          ],
        )
    );
  }

  Widget _verse(verse, context) {
    List<Widget> list = [];
    for (var stanza in verse.stanzas) {
      list.add(Text(stanza.text, style: Theme
          .of(context)
          .textTheme
          .bodyText2,),);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

}


