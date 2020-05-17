import 'package:flutter/material.dart';
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
}


