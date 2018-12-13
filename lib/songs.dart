import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializeSongBook.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/colors.dart';
import 'package:world_liturgy_app/app.dart';
//import 'package:material_search/material_search.dart';

class SongsPage extends StatefulWidget{
  SongsPage({Key key}) : super(key:key);

  @override
  _SongsPageState createState() {
    return new _SongsPageState();
  }
}

class _SongsPageState extends State<SongsPage> {
  final SongBooksContainer allSongBooks = globals.allSongBooks;
  final _SongsSearchDelegate _delegate = new _SongsSearchDelegate();


  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        textTheme: Theme.of(context).textTheme,
        title: appBarTitle('Song Books and Hymnals', context),
        actions: <Widget>[
          new IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final int selected = await showSearch<int>(
                context: context,
                delegate: _delegate,
              );
              if (selected != null ) {
//                setState;
              }
            },
          ),
        ],
      ),
      body:  ListView.builder(
        itemBuilder: (BuildContext context, int index) =>

          buildSongIndex(context, allSongBooks.books[index], allSongBooks.books.length == 1),
          itemCount: allSongBooks.books.length,
      ),
    );


  }
}

class _SongsSearchDelegate extends SearchDelegate<int> {
  final SongBooksContainer allSongBooks = globals.allSongBooks;

  @override
  Widget buildLeading(BuildContext context) {
    return new IconButton(
      tooltip: 'Back',
      icon: new AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final List suggestions = query.isEmpty
        ? []
        : _getSongSuggestions(query);

    return new _SuggestionList(
      query: query,
      suggestions: suggestions,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if(query.isEmpty){
      return <Widget>[];
    }else {
      return <Widget>[
        new IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
  }

  List _getSongSuggestions(String query) {
    List list = [];
    List queryList = query.toLowerCase().split(" ");
    globals.allSongBooks.books.asMap().forEach((index, songBook){
      List<Song> filtered = songBook.songs.where((Song song) => _songFilter(song, queryList)).toList();
      list.add([index, filtered]);
    });

    return list;
  }

  bool _songFilter(Song song, queryList){
    String string = '';
    if (song.number != null){string += song.number.toString() + ' ';}
    if (song.title != null){string += song.title.toLowerCase() + ' ';}
    if (song.subtitle != null){string += ' ' + song.subtitle.toLowerCase();}

    bool match = false;

    for (int i = 0; i < queryList.length; i++ ){
      if(string.contains(queryList[i])){
        match = true;
      } else {
        match = false;
        break;
      }
    }
    return match;
  }
}



class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query});

  final List suggestions;
  final String query;

  @override
  Widget build(BuildContext context) {
    int suggestionsCount = 0;
    suggestions.forEach((s) => suggestionsCount += s[1].length);

    bool expanded = suggestions.length == 1 || suggestionsCount < 8 ? true : false;

    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          buildSongIndex(context, globals.allSongBooks.books[suggestions[index][0]], expanded, suggestions[index][1]),
        itemCount: suggestions.length,
    );
  }
}


Widget buildSongIndex(BuildContext context, SongBook songBook, bool expanded, [List<Song> songList]) {
  bool showCount = false;
  if(songList == null){
    songList = songBook.songs;
  } else {
    showCount = true;
  }

  String titleText = showCount ? songBook.title + " (" + songList.length.toString() + ")" : songBook.title;

  if (songBook.songs.isEmpty)
    return new ListTile(title: new Text(songBook.title ?? 'No Title'));
  return new ExpansionTile(
    key: new PageStorageKey<SongBook>(songBook),
    title: new Text(
      titleText ?? 'No title',
      style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).accentColor),
    ),
    initiallyExpanded: expanded,
    children: _buildServicesTiles(context, songList),
  );
}

List<Widget> _buildServicesTiles(context, songList) {
  List<Widget> songsList = [];
//    Service serviceName;
  for (var song in songList) {
    songsList.add(new Padding(
        padding: EdgeInsets.only(left:20.0),
        child: new ListTile(
          leading: Icon(Icons.music_note),
          title: songTitle(song, style: Theme.of(context).textTheme.body1),
          subtitle: Text(song.subtitle ?? '', style: Theme.of(context).textTheme.caption.merge(referenceAndSubtitleStyle)),
          selected: false,
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => SongPage(song: song)));
          },
          dense: true,
        )
    ));
  }
  return songsList;
}

Text  songTitle (Song song, {style}) {
  String text = '';

  if(song.number != null){
    text += song.number.toString() + '. ';
  }
  if(song.title != null){
    text += song.title;
  }
  if(text == ''){
    text = 'No Title';
  }

  if(style == null){
    return new Text(text);
  }else {
    return new Text(text, style: style,);
  }
}

class SongPage extends StatelessWidget {

  final Song song;

  SongPage({ Key key, this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            songTitle(song),
            Text(
              song.subtitle ?? '',
              style: Theme.of(context).textTheme.caption.merge(referenceAndSubtitleStyle),
            )
          ],
        )
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
        children: _songBody(song, context),
      ),
    );
  }
}

  List<Widget> _songBody (song, context){
    List<Widget> widgets = [];

    int refrainLocation;

    if (song.refrain != null){
      refrainLocation = song.refrain.afterVerse == null ? 1 : song.refrain.afterVerse;
    }

    for (var i = 0; i < song.verses.length; i++) {
      if(refrainLocation == i){
        widgets.add(_refrain(song.refrain, context));
      }
      widgets.add(_verseRow(song.verses[i], i,  context));
    }

    return widgets;
  }

  Padding _refrain (refrain, context){
    List<Widget> list = [];

    list.add(new Text('Refrain' + ':', style: Theme.of(context).textTheme.caption.merge(referenceAndSubtitleStyle),));

    for (var stanza in refrain.stanzas) {
      list.add(Text(stanza.text, style: Theme.of(context).textTheme.body2));
    }

    return new Padding(
      padding: EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  Widget _verseRow(verse, vNumber, context){
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 20.0,
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              (vNumber+1).toString() + '.',
              style: Theme.of(context).textTheme.caption.merge(referenceAndSubtitleStyle),
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

  Widget _verse (verse, context){
    List<Widget> list = [];
    for (var stanza in verse.stanzas) {
      list.add(Text(stanza.text, style: Theme.of(context).textTheme.body1, ),);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }




