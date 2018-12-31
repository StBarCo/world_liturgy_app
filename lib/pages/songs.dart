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
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  final List<SongBook> songBooks = List.from(globals.allSongBooks.books);
  List<SongBook> filteredSongBooks = List.from(globals.allSongBooks.books);
  Icon _searchIcon = new Icon(Icons.search);

  _SongsPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredSongBooks = List.from(songBooks);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
//      centerTitle: true,
      textTheme: Theme
          .of(context)
          .textTheme,
      title: _appBarTitle(),
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      filteredSongBooks = _getSongSuggestions(songBooks, _searchText);
    } else {
      filteredSongBooks = List.from(songBooks);
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          buildSongIndex(
              filteredSongBooks[index], filteredSongBooks.length == 1),
      itemCount: filteredSongBooks.length,
    );
  }

  List<SongBook> _getSongSuggestions(List<SongBook> songBooks, String query) {
    List<SongBook> filteredList = [];
    List queryList = query.toLowerCase().split(" ");
    songBooks.asMap().forEach((index, songBook) {
      List<Song> filteredSongs = songBook.songs
          .where((Song song) => _songFilter(song, queryList))
          .toList();
      filteredList.add(SongBook(
        songBooks[index].language,
        songBooks[index].id,
        songBooks[index].title,
        filteredSongs,
      ));
    });

    return filteredList;
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

  Widget _appBarTitle() {
    if (_searchIcon.icon != Icons.search) {
      return TextField(
        controller: _filter,
        decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: globals.translate(getLanguage(context), 'search') + '...',
        )
      );
    }

    return appBarTitle(
        globals.translate(getLanguage(context), 'songs'), context);
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
      } else {
        this._searchIcon = new Icon(Icons.search);
        filteredSongBooks = songBooks;
        _filter.clear();
      }
    });
  }


  Widget buildSongIndex(SongBook songBook, bool expanded,
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
        style: Theme
            .of(context)
            .textTheme
            .subhead
            .copyWith(color: Theme
            .of(context)
            .accentColor),
      ),
      initiallyExpanded: expanded,
      children: _buildServicesTiles(songList),
    );
  }

  List<Widget> _buildServicesTiles(songList) {
    List<Widget> songsList = [];
    dynamic currentDay = RefreshState
        .of(context)
        .currentDay;
    dynamic currentLanguage = RefreshState
        .of(context)
        .currentLanguage;
    dynamic textScaleFactor = RefreshState
        .of(context)
        .textScaleFactor;
//    Service serviceName;
    for (var song in songList) {
      songsList.add(new Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: new ListTile(
            leading: Icon(Icons.music_note),
            title: songTitle(song, style: Theme
                .of(context)
                .textTheme
                .body1),
            subtitle: Text(song.subtitle ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .caption
                    .merge(referenceAndSubtitleStyle)),
            selected: false,
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext itemContext) =>
                new RefreshState(
                    currentDay: currentDay,
                    currentLanguage: currentLanguage,
                    textScaleFactor: textScaleFactor,
//              onTap: onTap,
                    child: MediaQuery(
                      data: MediaQuery.of(itemContext)
                          .copyWith(textScaleFactor: textScaleFactor),
                      child: Theme(
                        data: updateTheme(Theme.of(context), currentDay),
                        child: SongPage(song: song),
                      ),
                    )),
              );
              Navigator.push(context, route);
            },
            dense: true,
          )));
    }
    return songsList;
  }
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

