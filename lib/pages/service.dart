import 'package:flutter/material.dart';
import '../json/serializePrayerBook.dart';
import '../shared_preferences.dart';
import '../json/xml_parser.dart';
import '../globals.dart' as globals;
import '../app.dart';
import 'calendar.dart';
import '../model/calendar.dart';
import '../parts/section.dart';


class ServicePage extends StatefulWidget {
  final initialCurrentIndexes;

  ServicePage({Key key, @required this.initialCurrentIndexes})
      : super(key: key);

  @override
  _ServicePageState createState() => new _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Map currentIndexes;
  Service currentService;
  ScrollController _serviceScrollController = new ScrollController();
  String currentLanguage;
  Day currentDay;
  double textScaleFactor;

  _ServicePageState();

  @override
  void initState() {
    super.initState();
    currentIndexes = widget.initialCurrentIndexes;
    if(globals.allPrayerBooks == null) {
      loadPrayerBooks().then((pb) {
        globals.allPrayerBooks = pb;
        currentService = _getServiceFromIndexes(currentIndexes);

      });
    } else {
      currentService = _getServiceFromIndexes(currentIndexes);
    }
  }

  Service _getServiceFromIndexes(indexes) {
    return globals.allPrayerBooks
        .getPrayerBook(language: indexes['prayerBook'])
        .getService(indexes['service']);
  }

  void _changeLanguage() {
    int maxPbIndex = globals.allPrayerBooks.prayerBooks.length - 1;
    int currentPbIndex = globals.allPrayerBooks
        .getPrayerBookIndexByLang(currentIndexes['prayerBook']);
    int newPbIndex = currentPbIndex == maxPbIndex ? 0 : currentPbIndex + 1;

    currentIndexes['prayerBook'] =
        globals.allPrayerBooks.prayerBooks[newPbIndex].language;

    currentService = _getServiceFromIndexes(currentIndexes);
    RefreshState.of(context).updateValue(
        newLanguage: currentIndexes['prayerBook']);
  }

  void _updateTextScale(double newValue) {
      RefreshState.of(context).updateValue(newTextScale: newValue);
  }

  void _changeService(String prayerBook, String service, previousService) {
    bool changingBook =
        currentIndexes['prayerBook'] == prayerBook ? false : true;
    currentIndexes['service'] = service;
    currentIndexes['prayerBook'] = prayerBook;
    currentService = _getServiceFromIndexes(currentIndexes);

    if (service != previousService) {
      _serviceScrollController.jumpTo(0.0);
    }

//    if changing prayerBooks
    if (changingBook) {
      RefreshState.of(context).updateValue(
          newLanguage:
              globals.allPrayerBooks.getPrayerBook(id: prayerBook).language);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final refreshState = RefreshState.of(context);
    currentLanguage = refreshState.currentLanguage;
    currentDay = refreshState.currentDay;
    textScaleFactor = refreshState.textScaleFactor;

    if(currentService == null || globals.allPrayerBooks == null){
      return Theme(data: Theme.of(context), child: Scaffold(body: Center(child: CircularProgressIndicator())),);
    } else {
      return Theme(
          data: Theme.of(context),
          child: Scaffold(
            drawer: _buildDrawer(globals.allPrayerBooks.prayerBooks, context),
            appBar: AppBar(
              elevation: 1.0,
//          backgroundColor: kPrimaryLight,
              textTheme: Theme
                  .of(context)
                  .textTheme,
              title: appBarTitle(
                  currentService.title, context, currentService.titleShort),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    _changeLanguage();
                  },
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.swap_horiz,
                        color: Theme
                            .of(context)
                            .primaryIconTheme
                            .color,
                        size: 30.0,
                      ),
                      Text(globals.translate(currentLanguage, 'languageName'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption
                              .copyWith(
                            color: Theme
                                .of(context)
                                .primaryIconTheme
                                .color,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            body: _buildService(currentService),
          ));
    }
  }

  Drawer _buildDrawer(prayerBooks, context) {
    return Drawer(
      child: Column(children: <Widget>[
//        Container(
//          margin: EdgeInsets.only(top: 25.0),
//          height: 50.0,
//          child: Text(
//            'THIS WILL BE HEADER',
//            style: Theme.of(context).textTheme.title,
//          ),
//        ),
        AppBar(
          automaticallyImplyLeading: false,
          title: appBarTitle(globals.appTitle, context),
          textTheme: Theme.of(context).textTheme,
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              key: PageStorageKey('drawer_list_key'),
              itemBuilder: (BuildContext context, int index) {
                List<String> favorites = SharedPreferencesHelper.getFavorites();
                bool currentServiceIsAFavorite = favorites.contains(currentIndexes['prayerBook'] + '-' + currentIndexes['service']);
                if(index < prayerBooks.length ){

                  return drawerPrayerBookEntry(context, prayerBooks[index], currentServiceIsAFavorite, true, favorites);
                } else {
                  return drawerPrayerBookEntry(context, prayerBooks[index - prayerBooks.length], currentServiceIsAFavorite, false, favorites);
                }
              },
              itemCount: prayerBooks.length*2,

            ),
          ),
        ),
        Divider(),
        ListTile(
            title: Text('Zoom'),
            leading: Icon(Icons.zoom_in),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, state) {
                      return Container(
                        height: 100.0,
                        padding: EdgeInsets.all(32.0),
                        child: Slider(
                          label: textScaleFactor.toString() + 'x',
                          min: 0.5,
                          max: 1.5,
                          value: textScaleFactor,
                          divisions: 10,
                          onChanged: (double value) {
                            updatedScale(state, value);
                            _updateTextScale(value);
                          },
                        ),
                      );
                    });
                  });
            })
      ]),
    );
  }

  Future<Null> updatedScale(StateSetter updateState, newFactor) async {
    updateState(() {
      textScaleFactor = newFactor;
    });
  }

  Widget drawerPrayerBookEntry(BuildContext context, PrayerBook prayerBook, [bool currentServiceIsAFavorite, bool onlyFavorites = false, List<String> favorites]) {

    // Build the favorites tiles
    if(onlyFavorites){
      return Column(
        children: _buildServicesTiles(context, prayerBook, currentServiceIsAFavorite, true, favorites),
      );

    }else {
      // Build the prayer-books
      if (prayerBook.services.isEmpty)
        return new ListTile(title: new Text(prayerBook.title ?? 'No Title'),);
      return new ExpansionTile(
        key: new PageStorageKey<PrayerBook>(prayerBook),
        title: new Text(
          prayerBook.title ?? 'No title',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        children: _buildServicesTiles(context, prayerBook, currentServiceIsAFavorite, false, favorites),
        initiallyExpanded: !currentServiceIsAFavorite && prayerBook.id == currentIndexes['prayerBook'] ,
      );
    }
  }

  List<Widget> _buildServicesTiles(BuildContext context,PrayerBook prayerBook, bool currentServiceIsAFavorite, bool onlyFavorites, List<String> favorites ) {
    List<Widget> servicesList = [];
//    Service serviceName;
    for (var service in prayerBook.services) {
      String serviceFavString = prayerBook.id + "-" + service.id;
      bool isFavorite = favorites.contains(serviceFavString);

      if(onlyFavorites && !isFavorite){
        continue;
      }

//      //is selected if the service is the currentService AND either in favorites section & is a favorite , or not in favorites section and not a favorite.
//      bool makeSelected = onlyFavorites == currentServiceIsAFavorite &&
//          service.id == currentIndexes['service'] && prayerBook.id == currentIndexes['prayerBook'];
      servicesList.add(new Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: new ListTile(
            title: new Text(
              service.title ?? 'No title',
            ),
            trailing: FavoriteServiceWidget(isFavorite: isFavorite, favoriteID: serviceFavString,),
            selected: service.id == currentIndexes['service'] && prayerBook.language == currentIndexes['prayerBook'],
            onTap: () {
              Navigator.pop(context);
              _changeService(
                  prayerBook.language, service.id, currentIndexes['service']);
            },
            dense: true,
          )));
      }
    return servicesList;
  }


  //TODO: Look at refactoring service building with widget classes
//  https://flutter.io/catalog/samples/expansion-tile-sample/
  Widget _buildService(Service service) {
    Day currentDay = getDay(context);
    return new ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: service.sections.length,
      itemBuilder: (context, index) {
        var section = service.sections[index];
//        return SectionCard(
//          currentIndexes,
//          section,
//        );
        return _sectionType(section, currentIndexes, currentDay);
      },
      controller: _serviceScrollController,
    );
  }

  Widget _sectionType(section, currentIndexes,Day currentDay) {
    if (section.type == 'collectOfTheDay') {
      return CollectContent(currentIndexes["prayerBook"], "collect");
    } else if (section.type == 'postCommunionOfTheDay') {
      return CollectContent(currentIndexes["prayerBook"], "postCommunion");
    } else if (section.type == 'calendarDate') {
      return dayAndLinkToCalendar(currentIndexes, context);

    } else if (section.type == 'scheduled' &&
        section.schedule.contains(currentDay.season.id)) {
      return SectionContent(section);
    } else if (section.type == 'scheduledFeast' &&
        currentDay.isHolyDay() && currentDay.holyDays.where((hd) => hd.id == section.schedule).toList().isNotEmpty ) {
      return SectionContent(section);
    } else {
      if (section.visibility == 'collapsed') {
        return CollapsedSectionCard(section);
      } else if (section.visibility == 'indexed') {
        return IndexedSectionCard(section);
      } else if (section.visibility == 'hidden') {
      } else if (section.collects != null) {
        return CollectSectionContent(section);
      } else {
        return SectionContent(section);
      }
    }
    return Container();
  }
}

class FavoriteServiceWidget extends StatefulWidget {

  final bool isFavorite;
  final String favoriteID;

  FavoriteServiceWidget({Key key, this.isFavorite, this.favoriteID }) : super(key: key);

  _FavoriteServiceWidgetState createState() => _FavoriteServiceWidgetState();
}

class _FavoriteServiceWidgetState extends State<FavoriteServiceWidget> {

  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isFavorited ? Icon(Icons.favorite, color: Colors.red[900],) : Icon(Icons.favorite_border),
      onPressed: (){
        setState((){
          isFavorited = !isFavorited;
          if(isFavorited){
            SharedPreferencesHelper.addFavorite(widget.favoriteID);
          } else {
            SharedPreferencesHelper.removeFavorite(widget.favoriteID);
          }

        });
      },
    );

  }
}
