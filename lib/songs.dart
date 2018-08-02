import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializeSongBook.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/songs.dart';

class SongsPage extends StatefulWidget{
  SongsPage({Key key}) : super(key:key);

  @override
  _SongsPageState createState() {
    return new _SongsPageState();
  }
}

class _SongsPageState extends State<SongsPage> {
  SongBooksContainer allSongBooks = globals.allSongBooks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            buildSongIndex(context, allSongBooks.books[index]),
        itemCount: allSongBooks.books.length,
      );
  }
}

Widget buildSongIndex(BuildContext context, SongBook songBook) {
  if (songBook.songs.isEmpty)
    return new ListTile(title: new Text(songBook.title ?? 'No Title'));
  return new ExpansionTile(
    key: new PageStorageKey<SongBook>(songBook),
    title: new Text(songBook.title ?? 'No title', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
    children: _buildServicesTiles(context, songBook),

  );
}

List<Widget> _buildServicesTiles(context, songBook) {
  List<Widget> songsList = [];
//    Service serviceName;
  for (var song in songBook.songs) {
    songsList.add(new Padding(
        padding: EdgeInsets.only(left:20.0),

        child: new ListTile(
          title: new Text(song.title ?? 'No title',),
          selected: false,
          onTap: () {
//            Navigator.pop(context);
//            _changeService(prayerBook.id, service.id, currentIndexes['service']);
          },
          dense: true,
        )
    ));
  }
  return songsList;

}

//class _SongsPageState extends State<SongsPage> {
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      itemExtent: 250.0,
//      itemBuilder: (context, index) => Container(
//
//
//        padding: EdgeInsets.all(10.0),
//        child: Material(
//          elevation: 4.0,
//          borderRadius: BorderRadius.circular(5.0),
//          color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
//          child: Center(
//            child: Text(index.toString()),
//          ),
//        ),
//      ),
//      itemCount: globals.allSongBooks.books.length,
//    );
//  }
//}