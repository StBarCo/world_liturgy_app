import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/calendar.dart';
import 'package:world_liturgy_app/styles.dart';
import 'package:world_liturgy_app/app.dart';
import 'package:world_liturgy_app/colors.dart';

class ServicePage extends StatefulWidget{
  final initialCurrentIndexes;

  ServicePage({Key key, @required this.initialCurrentIndexes}) : super(key: key);

  @override
  _ServicePageState createState() => new _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Map currentIndexes;
  Service currentService;
  ScrollController _serviceScrollController = new ScrollController();
  String currentLanguage;

  _ServicePageState();

  @override
  void initState() {
    super.initState();
    currentIndexes = widget.initialCurrentIndexes;
    currentService = _getServiceFromIndexes(currentIndexes);

  }

  Service _getServiceFromIndexes(indexes) {
    return globals.allPrayerBooks.getPrayerBook(indexes['prayerBook'])
        .getService(indexes['service']);

  }

  void _changeLanguage() {
      int maxPbIndex = globals.allPrayerBooks.prayerBooks.length - 1;
      int currentPbIndex = globals.allPrayerBooks.getPrayerBookIndexById(
          currentIndexes['prayerBook']);
      int newPbIndex = currentPbIndex == maxPbIndex ? 0 : currentPbIndex + 1;

      currentIndexes['prayerBook'] =
          globals.allPrayerBooks.prayerBooks[newPbIndex].id;

      currentService = _getServiceFromIndexes(currentIndexes);
      LanguageState.of(context).onTap(globals.allPrayerBooks.prayerBooks[newPbIndex].language);
  }

  void _changeService(String prayerBook, String service, previousService) {
    bool changingBook = currentIndexes['prayerBook'] == prayerBook ? false : true;
    currentIndexes['service'] = service;
    currentIndexes['prayerBook'] = prayerBook;
    currentService = _getServiceFromIndexes(currentIndexes);


    if(service != previousService){
      _serviceScrollController.jumpTo(0.0);
    }

//    if changing prayerBooks
    if(changingBook){
      LanguageState.of(context).onTap(globals.allPrayerBooks.getPrayerBook(prayerBook).language);
    }else{
      setState(() {
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    checkForCurrentDay();
    final languageState = LanguageState.of(context);
    currentLanguage = languageState.currentLanguage;

    return new Theme(
      data: baseTheme,
      child: new Scaffold (
        drawer: _buildDrawer(globals.allPrayerBooks.prayerBooks),
        appBar: new AppBar(
          elevation: 1.0,
          backgroundColor: kPrimaryLight,
          textTheme: Theme.of(context).textTheme,
          title: Text(
              currentService.title,
              style: Theme.of(context).textTheme.title.copyWith(
                fontFamily: 'Signika',
              ),
          ),

          actions: <Widget>[
            FlatButton(
              onPressed: (){
                _changeLanguage();
              },
              padding: EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).primaryIconTheme.color,
                    size: 30.0,

                  ),
                  Text(
                      globals.translate(currentLanguage, 'languageName'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).primaryIconTheme.color,

                      )
                  ),
                ],
              ),
            ),
          ],
        ),
        body: _buildService(context, currentService),

      )
    );
  }


  Drawer _buildDrawer(prayerBooks) {
    return Drawer(

      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: new ListView.builder(

        itemBuilder: (BuildContext context, int index) =>
            drawerPrayerBookEntry(context, prayerBooks[index]),
        itemCount: prayerBooks.length,
      ),
    );
  }

  Widget drawerPrayerBookEntry(BuildContext context, PrayerBook prayerBook) {
    if (prayerBook.services.isEmpty)
      return new ListTile(title: new Text(prayerBook.title ?? 'No Title'));
    return new ExpansionTile(
      key: new PageStorageKey<PrayerBook>(prayerBook),
      title: new Text(prayerBook.title ?? 'No title', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
      children: _buildServicesTiles(context, prayerBook),
      initiallyExpanded: prayerBook.id == currentIndexes['prayerBook'],

    );
  }

  List<Widget> _buildServicesTiles(context, prayerBook) {
    List<Widget> servicesList = [];
//    Service serviceName;
    for (var service in prayerBook.services) {
      servicesList.add(new Padding(
          padding: EdgeInsets.only(left:20.0),

          child: new ListTile(
            title: new Text(service.title ?? 'No title',),
            selected: service.id == currentIndexes['service'] && prayerBook.id == currentIndexes['prayerBook'],
            onTap: () {
              Navigator.pop(context);
              _changeService(prayerBook.id, service.id, currentIndexes['service']);
            },
            dense: true,
          )
      ));
    }
    return servicesList;

  }

  //TODO: Look at refactoring service building with widget classes
//  https://flutter.io/catalog/samples/expansion-tile-sample/
  Widget _buildService(BuildContext context, Service service ) {
    return new ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: service.sections.length,
      itemBuilder: (context, index) {
        var section = service.sections[index];
        return _buildSection(context, currentIndexes, section, currentLanguage);
      },
      controller: _serviceScrollController,


    );
  }

}



    Widget _buildSection(BuildContext context, currentIndexes, section, language){
//      final alreadySaved = _saved.contains(pair);
      return new Card(

        margin: EdgeInsets.only(bottom: 8.0),
        elevation: 0.0,

        child: new Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: new Column(
            children: _buildItemsList(context, currentIndexes, section, language),
          ),
        )

      );

    }

    List<Widget> _buildItemsList(BuildContext context, currentIndexes, section, language){
      List<Widget> itemsList = new List<Widget>();

      if (section.type == 'collectOfTheDay'){
        itemsList.add(CalendarItem(currentPrayerBookIndex: currentIndexes["prayerBook"], buildType: "collect",) );
      } else if (section.type == 'postCommunionOfTheDay') {
        itemsList.add(CalendarItem(currentPrayerBookIndex: currentIndexes["prayerBook"], buildType: "postCommunion",) );

      } else if (section.type == 'scheduled' && section.schedule.contains(globals.currentDay.season)) {
        itemsList.addAll(_buildNormalSection(section, language, context));
      } else if (section.type == 'scheduledFeast' && (section.schedule == globals.currentDay.principalFeastID || section.schedule == globals.currentDay.holyDayID)){
        itemsList.addAll(_buildNormalSection(section, language, context));
      } else {
        if (section.visibility == 'collapsed') {
          itemsList.add(_buildHeaderForCollapsed(context, currentIndexes, section, language));
        } else if (section.visibility == 'indexed'){
          itemsList.add(_buildSectionHeader( section, context));
          itemsList.add(_buildLinksForIndexed(context, section, language));
        } else if (section.visibility == 'hidden') {
          itemsList.add(new Row());
        } else {
          itemsList.addAll(_buildNormalSection(section, language, context));
        }

      }
      return itemsList;
    }

  List<Widget> _buildNormalSection(section, language, context){
    List<Widget> itemsList = [];

    if (_sectionHasHeader(section)) {
      itemsList.add(_buildSectionHeader(section, context));
    }
    if (section.items != null) {
      var prevItemWho;
      for (var item in section.items) {
        Widget row = _buildItem(item, language, context, prevItemWho, );
        var padding = new Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: row,
        );
        if (row != null) itemsList.add(padding);
        prevItemWho = item.who;
      }
    } else if (section.collects != null){
      for (var collect in section.collects) {
        Widget column = buildDailyPrayers(collect, language,context);
        var padding = new Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: column,
        );
        if (column != null) itemsList.add(padding);
      }
    }
    return itemsList;
  }


  _buildHeaderForCollapsed(context, currentIndexes, section, language){
    return GestureDetector(
        onTap: () {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new ExpandedSection(section: section, currentIndexes: currentIndexes, language: language)
          );
          Navigator.push(context, route);
        },
        child: new Column(
          children: <Widget>[
            _buildSectionHeader(section, context, collapsed: true),
            new Text(globals.translate(language,"tapToExpand"), style: Theme.of(context).textTheme.caption.copyWith(color: kSecondaryColor),)
          ],
        )
    );
  }

  _buildLinksForIndexed(context, section, language) {
    List<Widget> headers = [];

    for (var item in section.items) {
      headers.add(new GestureDetector(
          onTap: () {
            var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                new ExpandedIndexedItem(item: item,)
            );
            Navigator.push(context, route);
          },
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(top:12.0),
                  child:  new Text(item.title, style: Theme.of(context).textTheme.subhead.copyWith(
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ), textAlign: TextAlign.center),

              ),
              new Padding(
                padding: EdgeInsets.only(top:4.0),
                child: new Text(
                  item.ref ?? '',
                  style: referenceAndSubtitleStyle(context, color: Theme.of(context).accentColor ),
                    textAlign: TextAlign.center,
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top:4.0),
                child: new Text(globals.translate(language,"tapToExpand"), style: Theme.of(context).textTheme.caption.copyWith(color: kSecondaryColor), textAlign: TextAlign.center),
              ),
            ],
          )
      )
      );
    }
    return Padding(child: new Column(children:headers), padding: EdgeInsets.symmetric(horizontal: 48.0),);
  }






class ExpandedSection extends StatelessWidget {
  final Section section;
  final currentIndexes;
  final String language;

  ExpandedSection({ Key key, this.section, this.currentIndexes, this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: baseTheme,
      child: new Scaffold(
          appBar: new AppBar(
            elevation: 1.0,
            backgroundColor: kPrimaryLight,
            textTheme: Theme.of(context).textTheme,
            title: Text(section.indexName, style: Theme.of(context).textTheme.title.copyWith(
            fontFamily: 'Signika',),)
          ),
          body: new ListView(
            children: <Widget>[
              new Card(
                  margin: EdgeInsets.only(bottom: 8.0),
                  elevation: 0.0,
                  child: new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: new Column(
                        children: _buildExpandedSectionItems(section, language, context),
                      )
                  )
              )
            ],
          )

      )

    );


  }



  List<Widget> _buildExpandedSectionItems(section, language, context) {
    List<Widget> itemsList = new List<Widget>();
    if (section.rubric != null) {
      itemsList.add(new Padding(
        child: _rubric(section.rubric, context),
        padding: new EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
      ));
    }
    if (section.items != null) {
      var prevItemWho;
      for (var item in section.items) {
        Widget row = _buildItem(item, language, context, prevItemWho);
        var padding = new Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: row,
        );
        if (row != null) itemsList.add(padding);
        prevItemWho = item.who;
      }
    }


    return itemsList;
  }
}

class ExpandedIndexedItem extends StatelessWidget {
  final Item item;

  ExpandedIndexedItem({ Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 1.0,
          backgroundColor: kPrimaryLight,
          textTheme: Theme.of(context).textTheme,
          title: Text(item.title, style: Theme.of(context).textTheme.title.copyWith(
            fontFamily: 'Signika',),),
        ),
        body: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: _buildExpandedIndexedItems(item, context),

        )
    );
  }

  List<Widget> _buildExpandedIndexedItems(item, context) {

    return stanzasColumn(item, context, returnType: 'list', exclude: 'title');
  }
}

bool _sectionHasHeader(section){
  return section.title != null
      || section.rubric != null
      || section.number != null
      || section.majorHeader !=null;
}

Widget _buildSectionHeader(section, context, {bool collapsed: false}){

  List<Widget> headerList = [];
  if (section.majorHeader != null){
    headerList.add(_majorHeader(section.majorHeader, context));
  }

  if (section.number !=null){
    headerList.add(Center(child:_sectionNumber(section.number.toString())));
  }
  if (section.title !=null){
    headerList.add(new Padding(
        padding: new EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
        child:_sectionTitle(section.title, collapsed, context)));
  }

//  if (section.number !=null || section.title != null){
//    List<Widget> row = [];
//    if (section.number !=null){
//      headerList.add(_sectionNumber(section.number));
//    }
//    if (section.title !=null){
//      headerList.add(new Flexible(child:_sectionTitle(section.title)));
//    }
//
//    headerList.add(new
//      Padding(
//        padding: new EdgeInsets.only(top:16.0, bottom: 0.0, left: 42.0, right: 42.0),
//        child: Row(
//          children: row,
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//        )
//    ));
//  }

  if (section.rubric != null) {
    headerList.add(Center(
      child: new Padding(
          child:_rubric(section.rubric, context),
          padding: new EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
      ),
    ));
  }
  return Padding(

    child: Center(
      child: Column(
        children: headerList,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    ),
    padding: EdgeInsets.only(top:0.0, bottom: 0.0),
  );
}

Widget _rubric(rubric, context) {
    return Text(
      rubric.toString(),
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
    );
  }

Widget _sectionNumber(number){
  return Container(
//    fit: BoxFit.fitHeight,
    child: new Transform(
      child: new CircleAvatar(
          child: new Text(number.toString(),textScaleFactor: 2.0,),
          foregroundColor: kPrimaryDark,
          backgroundColor: kPrimaryLight,
      ),
      alignment: Alignment.center,

      transform: new Matrix4.identity()
        ..scale(0.5),
    ),
  );
}

Widget _sectionTitle(title, collapsed, context){
  if(collapsed){
    return Text(
      title ,
      style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).accentColor),
      textAlign: TextAlign.center,
    );
  } else {
    return Text(
      title ,
      style: Theme.of(context).textTheme.subhead,
      textAlign: TextAlign.center,
    );
  }

}

Widget _majorHeader(header, context){
  return Padding(
      padding: new EdgeInsets.only(top:0.0, bottom: 12.0),
      child:
      Text(
        header ,
        style: Theme.of(context).textTheme.headline,
        textAlign: TextAlign.center,
      )
  );
}

Widget _buildItem(item, language, context, [prevItemWho]){
  if (item.type == 'title' && item.text != null){
    return Padding(child:_sectionTitle(item.text, false, context),padding: EdgeInsets.only(top: 12.0),);
  }else if (item.type == 'rubric'){
    return Padding(child:_rubric(item.text, context),padding: EdgeInsets.only(top:18.0, bottom: 5.0),);
  }else if (item.who == 'leader' || item.who == 'minister'
      || item.who == 'reader' || item.who == 'leaderOther' || item.who == 'bishop' || item.who == "archBishop"){
    return _leaderItem(item, language, prevItemWho, context);
  } else if (item.who == 'people' || item.who == 'all' || item.who== 'peopleOther') {
    return _peopleItem(item, language, prevItemWho, context);
  } else if (item.who == 'none') {
    return null;
  } else if (item.type == 'versedStanzas') {
    return stanzasColumn(item, context);
  } else if (item.type == 'stanzas' ){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:stanzasColumn(item, context));
  } else if (item.who == null) {
    return genericItem(item, context);
  } else {
    return _unknownItem(item, context);
  }
}

Widget _leaderItem(item, language, prevItemWho, context){
  var _pickedIcon = item.who == 'minister' ? Icon(Icons.person) : item.who == 'reader' ? Icon(Icons.local_library) : Icon(Icons.person);
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Opacity(
        opacity: item.who == prevItemWho ? 0.0 : 1.0,
        child: new Column(
          children: _makeAvatar(
            _pickedIcon,
            item.who == 'leaderOther' ? item.other :globals.translate(language, item.who),
            context,
          )
        )
      ),
      new Flexible(
        child: new Padding(
          padding: EdgeInsets.only(left: 16.0, right: 42.0, top: 12.0),
          child:  _isStanzas(item) ? stanzasColumn(item, context,style: Theme.of(context).textTheme.body1) : _doesItemHasRef(item) ? _itemTextWithRef(item,  Theme.of(context).textTheme.body1, referenceAndSubtitleStyle(context)) : _itemText(item,  style:  Theme.of(context).textTheme.body1),
        )
      ),
    ],
  );
}

Widget _peopleItem(item, language, prevItemWho, context){
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      new Flexible(
          child: new Padding(
            padding: EdgeInsets.only(
                left: item.who == 'all' ? 16.0 : 42.0,
                right: 16.0,
                top:12.0
            ),
            child: _isStanzas(item) ? stanzasColumn(item, context, style: Theme.of(context).textTheme.body2) : _doesItemHasRef(item) ? _itemTextWithRef(item, Theme.of(context).textTheme.body2, referenceAndSubtitleStyle(context), alignment:  TextAlign.right) : _itemText(item, style: Theme.of(context).textTheme.body2, alignment:  TextAlign.right),

          )
      ),
      new Opacity(
          opacity: item.who == prevItemWho ? 0.0 : 1.0,
          child: new Column(
            children: _makeAvatar(
                Icon(Icons.people),
              item.who == 'peopleOther' ? item.other : globals.translate(language, item.who),
                context,
            )
          )
      ),
    ],
  );
}

Widget genericItem(item, context){
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Expanded(
        child: new Padding(
          child: _doesItemHasRef(item) ? _itemTextWithRef(item,  Theme.of(context).textTheme.body1, referenceAndSubtitleStyle(context)) : _itemText(item,  style: Theme.of(context).textTheme.body1),
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        ),
      )
    ],
  );
}

Widget _unknownItem(item, context){
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Column(
        children: _makeAvatar(
            Icon(Icons.error),
            item.who ?? '',
            context,
            color: Colors.red
        )
      ),
      new Expanded(
        child: _doesItemHasRef(item) ? _itemTextWithRef(item, Theme.of(context).textTheme.body1, referenceAndSubtitleStyle(context)) : _itemText(item,  style: Theme.of(context).textTheme.body1),
      ),
//          new Column(
//            children: <Widget>[
//              new CircleAvatar(
//                child: Icon(Icons.group),
//                backgroundColor: Colors.green,
//              ),
//              new Text(item.who ?? 'no who'),
//            ],
//          ),
    ],
  );
}

List<Widget> _makeAvatar(avatar, String label, context, {Color color}){
  List<Widget> list = [
    new CircleAvatar(
      child: avatar,
      backgroundColor: kPrimaryLight,
      foregroundColor: color ?? kPrimaryDark,
    ),

    new Container(
      constraints: new BoxConstraints(maxWidth: 70.0),
      child: new Text(label, style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center,),
    ),
  ];
  return list;
}

bool _doesItemHasRef(item){
  try {
    return item.ref != null;
  }
  catch (e) {
    return false;
  }
}

bool _isStanzas(item){
  return item.type != null && item.type == 'stanzas' || item.type == 'versedStanzas';
}

Text _itemText(item,{TextStyle style, TextAlign alignment = TextAlign.left}){
  if(style != null) {
    return Text(
      item.text, style: style,
      textAlign: alignment,
    );
  }else {
    return Text(item.text);
  }
}

RichText _itemTextWithRef(item, TextStyle style, TextStyle refStyle, {TextAlign alignment = TextAlign.left}){
  return RichText(

      textAlign: alignment,
      text: new TextSpan(
          text: item.text,
          style: style,
          children:[
            new TextSpan(text: '   '),
            new TextSpan(
                text:item.ref,
                style: refStyle),

          ]
      )
  );
}

//text style is passed on, return type can be either column or list.
//column is used for general creation, but a list will be used in an expanded
//indexed item.
dynamic stanzasColumn(item, context, {TextStyle style, String returnType: 'column', String exclude: 'none' }){
  List<Widget> stanzaList = new List();

  if (item.title != null && (exclude == 'none' || !exclude.contains('title'))) {
    stanzaList.add(_canticleTitle(item.title, context));
  }

  if (item.ref != null && (exclude == 'none' || !exclude.contains('ref'))) {
    stanzaList.add(_titleReference(item.ref, context));
  }

  var _itemType = item.type;
  for (var stanza in item.stanzas){
    Widget row;
    if(_itemType == 'versedStanzas' && stanza.type != 'gloria') {
      row = _versedStanza(stanza, style: style);
    }else {
      row= _stanza(stanza, style: style);
    }

    var padding = new Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: row,
    );
    if (row != null) stanzaList.add(padding);
  }

  if (returnType == 'list'){
    return stanzaList;
  }else{
    return new Column(
      children: stanzaList,
    );
  }
}

Widget _versedStanza(stanza, {TextStyle style}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Container(

        child: new Text(stanza.verse ?? '', style: TextStyle(color: kPrimaryDark,),),
        width: 18.0,
      ),
      new Expanded(
          child: new Padding(
            padding: EdgeInsets.only(
            left: stanza.verse != null ? 0.0 : 18.0,
            bottom: stanza.verse != null ? 0.0 : 3.0,
            ),
            child: _itemText(stanza, style: style),
          ),
      )
    ],
  );
}

Widget _stanza(stanza, {TextStyle style}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Flexible(
        child: new Padding(
          padding: EdgeInsets.only(
            left: stanza.indent != null ? int.tryParse(stanza.indent)*18.0 ?? 0.0 : 0.0,
          ),
          child: _itemText(stanza, style: style),
        ),
      )
    ]
  );
}

Widget buildDailyPrayers(Collect collect, language, context, [buildType='full']){

  Map<String, List> buildTypes = {
    'full': ['title', 'subtitle', 'type', 'date', 'color', 'ref', 'collects', 'postCommunions' ],
    'collect':['title', 'subtitle', 'type', 'date', 'collects'],
    'postCommunion':['title', 'subtitle', 'type', 'date', 'postCommunions'],
  };

  List sectionsToBuild = buildTypes[buildType];
  List<Widget> children = [];

  if(collect.title != null && sectionsToBuild.contains('title')){
    children.add(collectTitle(collect.title, context));
  }
  if(collect.subtitle != null && sectionsToBuild.contains('subtitle')){
    children.add(collectSubtitle(collect.subtitle, context));
  }

  if(collect.type != null && sectionsToBuild.contains('type')){
    children.add(collectProperty(collect.type, referenceAndSubtitleStyle(context)),);
  }

  if (collect.date != null && sectionsToBuild.contains('date')){
    children.add(collectProperty(collect.date, referenceAndSubtitleStyle(context)));
  }

  if (collect.color != null && sectionsToBuild.contains('color')){
    children.add(collectProperty(collect.color, referenceAndSubtitleStyle(context)));
  }

  if (collect.ref != null && sectionsToBuild.contains('ref')){
    children.add(collectProperty(collect.ref, referenceAndSubtitleStyle(context)));
  }

  if ((collect.collectRubric  != null || collect.collectPrayers != null)  && sectionsToBuild.contains('postCommunions') && sectionsToBuild.contains('collects')){
    children.add(prayerHeader(globals.translate(language, "collect"), context));
  }
  if (collect.collectRubric != null  && sectionsToBuild.contains('collects')){
    children.add(_rubric(collect.collectRubric, context));
  }

  if (collect.collectPrayers != null  && sectionsToBuild.contains('collects')){
    children.addAll(prayers(collect.collectPrayers, language, context));
  }

  if ((collect.postCommunionRubric  != null || collect.postCommunionPrayers != null) && sectionsToBuild.contains('postCommunions') && sectionsToBuild.contains('collects')) {
    children.add(prayerHeader(globals.translate(language, 'postCommunionPrayer'), context));
  }

  if (collect.postCommunionRubric != null  && sectionsToBuild.contains('postCommunions')){
    children.add(_rubric(collect.postCommunionRubric, context));
  }

  if (collect.postCommunionPrayers != null  && sectionsToBuild.contains('postCommunions')){
    children.addAll(prayers(collect.postCommunionPrayers, language, context));
  }
  return new Column(
    children: children,
  );
}

Widget collectTitle(title, context){
  return Padding(
      padding: new EdgeInsets.only(top: 10.0, bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        title,
        style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
  );
}

Widget collectSubtitle(title, context){
  return Padding(
      padding: new EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        title,
        style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).primaryColorDark),
        textAlign: TextAlign.center,
      )
  );
}

Widget prayerHeader(header, context){
  return Padding(
      padding: new EdgeInsets.only(top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
      child: new Text(
        header,
        style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).primaryColorDark),
        textAlign: TextAlign.center,
      )
  );
}

List<Widget> prayers(listOfPrayers, language, context){
  List<Widget> collectList = [];
  for (var prayer in listOfPrayers){

    if (prayer.type == 'versedStanzas') {
      collectList.add(stanzasColumn(prayer, context));
    } else if (prayer.type == 'stanzas' ){
      collectList.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:stanzasColumn(prayer, context, style: Theme.of(context).textTheme.body1)));
    } else {
      collectList.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical:6.0),child: Text(prayer.text != null ? prayer.text : '', style: Theme.of(context).textTheme.body1,)));
    }
  }
  if (collectList.length > 1){
    collectList.insert(1,_rubric(globals.translate(language, 'or'), context));
  }
  return collectList;
}

Widget collectProperty(property, TextStyle style){
  return Padding(
      padding: new EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        property,
        textAlign: TextAlign.center,
        style: style,
      ),
  );
}

Widget _canticleTitle(title, context){
  return Padding(
      padding: new EdgeInsets.only(top:12.0, bottom: 8.0),
      child: new Text(
        title,
        style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 16.0),
        textAlign: TextAlign.center,
      )
  );
}

Widget _titleReference(ref, context){
  return Text(
    ref,
    style: referenceAndSubtitleStyle(context),
    textAlign: TextAlign.center,
  );
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);



