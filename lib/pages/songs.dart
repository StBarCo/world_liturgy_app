import 'package:flutter/material.dart';

import '../json/serializeSongBook.dart';
import '../globals.dart' as globals;
import '../theme.dart';
import '../app.dart';
import 'song.dart';

class SongsPage extends StatefulWidget {
  SongsPage({Key key}) : super(key: key);

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
    return new Scaffold(
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
              if (selected != null) {
//                setState;
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => buildSongIndex(
            context, allSongBooks.books[index], allSongBooks.books.length == 1),
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
    final List suggestions = query.isEmpty ? [] : _getSongSuggestions(query);

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
    if (query.isEmpty) {
      return <Widget>[];
    } else {
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
    globals.allSongBooks.books.asMap().forEach((index, songBook) {
      List<Song> filtered = songBook.songs
          .where((Song song) => _songFilter(song, queryList))
          .toList();
      list.add([index, filtered]);
    });

    return list;
  }

  bool _songFilter(Song song, queryList) {
    String string = '';
    if (song.number != null) {
      string += song.number.toString() + ' ';
    }
    if (song.title != null) {
      string += song.title.toLowerCase() + ' ';
    }
    if (song.subtitle != null) {
      string += ' ' + song.subtitle.toLowerCase();
    }

    bool match = false;

    for (int i = 0; i < queryList.length; i++) {
      if (string.contains(queryList[i])) {
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

    bool expanded =
        suggestions.length == 1 || suggestionsCount < 8 ? true : false;

    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) => buildSongIndex(
          context,
          globals.allSongBooks.books[suggestions[index][0]],
          expanded,
          suggestions[index][1]),
      itemCount: suggestions.length,
    );
  }
}

Widget buildSongIndex(BuildContext context, SongBook songBook, bool expanded,
    [List<Song> songList]) {
  bool showCount = false;
  if (songList == null) {
    songList = songBook.songs;
  } else {
    showCount = true;
  }

  String titleText = showCount
      ? songBook.title + " (" + songList.length.toString() + ")"
      : songBook.title;

  if (songBook.songs.isEmpty)
    return new ListTile(title: new Text(songBook.title ?? 'No Title'));
  return new ExpansionTile(
    key: new PageStorageKey<SongBook>(songBook),
    title: new Text(
      titleText ?? 'No title',
      style: Theme.of(context)
          .textTheme
          .subhead
          .copyWith(color: Theme.of(context).accentColor),
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
        padding: EdgeInsets.only(left: 20.0),
        child: new ListTile(
          leading: Icon(Icons.music_note),
          title: songTitle(song, style: Theme.of(context).textTheme.body1),
          subtitle: Text(song.subtitle ?? '',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .merge(referenceAndSubtitleStyle)),
          selected: false,
          onTap: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext itemContext) => new RefreshState(
                  currentDay: RefreshState.of(context).currentDay,
                  currentLanguage: RefreshState.of(context).currentLanguage,
                  textScaleFactor: RefreshState.of(context).textScaleFactor,
//              onTap: onTap,
                  child: MediaQuery(
                    data: MediaQuery.of(itemContext).copyWith(textScaleFactor: RefreshState.of(context).textScaleFactor),
                    child: Theme(
                      data: updateTheme(Theme.of(context), RefreshState.of(context).currentDay),
                      child: SongPage(song: song),
                    ),
                  )
              ),
            );
            Navigator.push(
                context,
                route
            );
          },
          dense: true,
        )));
  }
  return songsList;
}

Text songTitle(Song song, {style}) {
  String text = '';

  if (song.number != null) {
    text += song.number.toString() + '. ';
  }
  if (song.title != null) {
    text += song.title;
  }
  if (text == '') {
    text = 'No Title';
  }

  if (style == null) {
    return new Text(text);
  } else {
    return new Text(
      text,
      style: style,
    );
  }
}
