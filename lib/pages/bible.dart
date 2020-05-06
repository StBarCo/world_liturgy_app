import 'package:flutter/material.dart';

import '../app.dart';
import '../pages/calendar.dart';
import '../model/bible.dart';
import '../globals.dart' as globals;
import '../shared_preferences.dart';
import '../bibleParse/bible_reference.dart';

class BiblePage extends StatefulWidget {
  final Bible bible;
  final BibleRef ref;

  BiblePage({this.bible, this.ref, Key key}) : super(key: key);

  @override
  _BiblePageState createState() {
    return new _BiblePageState();
  }
}

class _BiblePageState extends State<BiblePage> {
  PageController _pageController;
  ScrollController _menuScrollController;
  Bible currentBible;
  BibleRef currentRef;
  Map currentBookInfo;

  _BiblePageState();

  @override
  void initState() {
    super.initState();

    currentBible = widget.bible;
    currentRef = widget.ref;
    currentBookInfo = currentBible.bibleFormat
        .getBookTitlesAndChapters()[currentRef.bookAbbr];
    _pageController = PageController(initialPage: currentRef.chapter-1);
    _menuScrollController = ScrollController();

  }

  Bible initialBible() {
    return globals.bibles.first;
  }

  changeBook(BibleRef newRef) {
    if (currentRef.bookAbbr != newRef.bookAbbr) {
      currentBookInfo =
      currentBible.bibleFormat.getBookTitlesAndChapters()[newRef.bookAbbr];
    }
    setState(() {
      currentRef.bookAbbr = newRef.bookAbbr;
      currentRef.chapter = newRef.chapter;
      SharedPreferencesHelper.setCurrentBible([currentBible.abbreviation, currentRef.bookAbbr, currentRef.chapter.toString()]);

    });

    _pageController.animateToPage(newRef.chapter - 1,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
//    _pageController.jumpTo(0.0);
  }

  changeChapter(int newChapter) {
    setState(() {
      currentRef.chapter = newChapter;
      SharedPreferencesHelper.setCurrentBible([currentBible.abbreviation, currentRef.bookAbbr, currentRef.chapter.toString()]);

    });
//    Future.delayed(Duration(milliseconds: 500), () {
//      _pageController.animateToPage(currentRef.chapter - 1,
//          duration: Duration(milliseconds: 400), curve: Curves.ease);
//    });
  }

  changeBible(String abbr) {
    currentBible =
        globals.bibles.firstWhere((bible) => bible.abbreviation == abbr);
    currentBookInfo =
    currentBible.bibleFormat.getBookTitlesAndChapters()[currentRef.bookAbbr];
    setState(() {
//      currentRef = currentRef;
      SharedPreferencesHelper.setCurrentBible([abbr, currentRef.bookAbbr, currentRef.chapter.toString()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetAnimationCurve: Curves.ease,
                  child: ListView(
                    key: Key('menu'),
                    controller: _menuScrollController,
                    children: booksMenu(),
                  ),
                );
              },
              barrierDismissible: true,
            );
            List bookList = currentBible.bibleFormat
                .getBookTitlesAndChapters()
                .keys
                .toList();

            Future.delayed(Duration(milliseconds: 50), () {
              _menuScrollController.jumpTo(
                (bookList.indexOf(currentRef.bookAbbr) * 58.0),
              );
            });
          },
          child: Row(
            children: <Widget>[
              appBarTitle(
                currentBible.bibleFormat
                    .getBookTitlesAndChapters()[currentRef.bookAbbr]['title'] +
                    ' ' + currentRef.printRef['content'],
                context,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme
                    .of(context)
                    .primaryIconTheme
                    .color,
              ),
            ],
          ),
        ),
        textTheme: Theme
            .of(context)
            .textTheme,
        actions: [
          PopupMenuButton(
            child: FlatButton(
              onPressed: null,
              child: Row(
                children: <Widget>[
                  Text(
                    currentBible.abbreviation,
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryIconTheme
                            .color),
                  ),
                  Icon(Icons.arrow_drop_down,
                      color: Theme
                          .of(context)
                          .primaryIconTheme
                          .color)
                ],
              ),
            ),
            itemBuilder: (BuildContext context) {
              return globals.bibles.map((Bible bible) {
                return PopupMenuItem(
                  value: bible.abbreviation,
                  child: ListTile(
                    title: Text(bible.abbreviation),
                    subtitle: Text(bible.title),
                    selected: currentBible == bible,
                  ),
                );
              }).toList();
            },
            onSelected: (value) {
              changeBible(value);
            },
          ),
        ],
      ),

      body: PageView.builder(
        itemBuilder: (context, chapter) {
          return Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0),
            child: FutureBuilder<List>(
                future: currentBible.bibleFormat.renderPassage(currentRef),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return ListView(
                        key: PageStorageKey(chapter.toString()),
                        children: snapshot.data,
                      );
                  }
                },
            ),
          );
        },
        itemCount: int.parse(currentBookInfo['chapters']),
        controller: _pageController,
        onPageChanged: (newChapter) {
          changeChapter(newChapter + 1);
        },
      ),
    );
  }

  List<Widget> booksMenu() {
    List<Widget> books = [];

    currentBible.bibleFormat
        .getBookTitlesAndChapters()
        .forEach((abbr, bookMap) {
      books.add(ExpansionTile(
        title: Text(
          bookMap['title'],
//            style: Theme.of(context).textTheme.headline,
        ),
        initiallyExpanded: abbr == currentRef.bookAbbr,
        onExpansionChanged: (bool) {
          if (bool) {currentBible.bibleFormat.prefetchBook(abbr);}
        },
        children: [
          GridView.count(
            physics: ScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            childAspectRatio: 1.8,
            crossAxisCount: 5,
            shrinkWrap: true,
            children: List.generate(
              int.parse(bookMap['chapters']),
                  (index) {
                return FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  onPressed: () {
                    changeBook(BibleRef(abbr, index + 1));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    (index + 1).toString(),
                    textAlign: TextAlign.center,
// style: Theme.of(context).textTheme.headline,
                  ),
                );
              },
            ),
          ),
        ],
      ));
    });

    return books;
  }
}

Widget lectionaryReading(item, context) {
  List<Widget> list = [];
  String lectionaryType = item.text.split(',')[0].trim();
  String readingType = item.text.split(',')[1].trim();

//  RefreshState.of(context).currentDay
  List<String> readings =
  getDailyReadings(lectionaryType, readingType, context);

  readings.forEach((ref) {
//    list.addAll(getPassageSection(ref, context));
  });

  return Column(
    children: list,
  );
}




List<String> splitRef(String input){
  RegExp pattern = RegExp(
    r"(\d?)\s*([a-z]+)",
    caseSensitive: false,
    multiLine: false
  );

  if (input.startsWith(pattern)){
    return [
      pattern.stringMatch(input),
      input.replaceAll(pattern, '').trim(),
    ];

  } else {
    return [];
  }
}


