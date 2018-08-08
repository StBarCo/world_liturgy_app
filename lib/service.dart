import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'package:world_liturgy_app/globals.dart' as globals;
import 'package:world_liturgy_app/calendar.dart';
import 'package:world_liturgy_app/styles.dart';
import 'package:world_liturgy_app/app.dart';

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


    return new Scaffold (
      drawer: _buildDrawer(globals.allPrayerBooks.prayerBooks),
      appBar: new AppBar(
        title: new Text(currentService.title),
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
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.button.color,
                    fontSize: 10.0,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildService(context, currentService),
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
      padding: const EdgeInsets.all(16.0),
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
      return new Column(
        children: _buildItemsList(context, currentIndexes, section, language),
      );
    }

    List<Widget> _buildItemsList(BuildContext context, currentIndexes, section, language){
      List<Widget> itemsList = new List<Widget>();

      if (section.type == 'collectOfTheDay'){
        itemsList.add(CalendarItem(currentPrayerBookIndex: currentIndexes["prayerBook"], buildType: "collect",) );
      } else if (section.type == 'postCommunionOfTheDay') {
        itemsList.add(CalendarItem(currentPrayerBookIndex: currentIndexes["prayerBook"], buildType: "postCommunion",) );

      } else if (section.type == 'scheduled' && section.schedule.contains(globals.currentDay.season)) {
        itemsList.addAll(_buildNormalSection(section, language));
      } else if (section.type == 'scheduledFeast' && (section.schedule == globals.currentDay.principalFeastID || section.schedule == globals.currentDay.holyDayID)){
        itemsList.addAll(_buildNormalSection(section, language));
      } else {
        if (section.visibility == 'collapsed') {
          itemsList.add(_buildHeaderForCollapsed(context, currentIndexes, section, language));
        } else if (section.visibility == 'indexed'){
          itemsList.add(_buildSectionHeader( section));
          itemsList.add(_buildLinksForIndexed(context, section, language));
        } else if (section.visibility == 'hidden') {
          itemsList.add(new Row());
        } else {
          itemsList.addAll(_buildNormalSection(section, language));
        }

      }
      return itemsList;
    }

  List<Widget> _buildNormalSection(section, language){
    List<Widget> itemsList = [];

    if (_sectionHasHeader(section)) {
      itemsList.add(_buildSectionHeader(section));
    }
    if (section.items != null) {
      var prevItemWho;
      for (var item in section.items) {
        Widget row = _buildItem(item, language, prevItemWho, );
        var padding = new Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: row,
        );
        if (row != null) itemsList.add(padding);
        prevItemWho = item.who;
      }
    } else if (section.collects != null){
      for (var collect in section.collects) {
        Widget column = buildDailyPrayers(collect, language);
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
            _buildSectionHeader(section),
            new Text(globals.translate(language,"tapToExpand").toUpperCase(), style: rubricTextStyle,)
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
                  child:  new Text(item.title, style: canticleTitleTextStyle, textAlign: TextAlign.center),

              ),
              new Padding(
                padding: EdgeInsets.only(top:4.0),
                child: new Text(item.ref ?? '', style: titleRefTextStyle, textAlign: TextAlign.center,),

              ),
              new Padding(
                padding: EdgeInsets.only(top:4.0),
                child: new Text(globals.translate(language,"tapToExpand").toUpperCase(), style: rubricTextStyle, textAlign: TextAlign.center),
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

    return new Scaffold(
        appBar: new AppBar(
          title: _sectionIndexName(section),
        ),
        body: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: _buildExpandedSectionItems(section, language),

        )
    );
  }



  List<Widget> _buildExpandedSectionItems(section, language) {
    List<Widget> itemsList = new List<Widget>();
    if (section.rubric != null) {
      itemsList.add(new Padding(
        child: _rubric(section.rubric),
        padding: new EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
      ));
    }
    if (section.items != null) {
      var prevItemWho;
      for (var item in section.items) {
        Widget row = _buildItem(item, language, prevItemWho);
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
          title: _sectionTitle(item.title ??
              'Not Named: Collapsed and Linked Sections Must have names'),
        ),
        body: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: _buildExpandedIndexedItems(item),

        )
    );
  }



  List<Widget> _buildExpandedSectionItems(section) {
    List<Widget> itemsList = new List<Widget>();
    if (_sectionHasHeader(section)) {
      itemsList.add(_buildSectionHeader(section));

      if (section.items != null) {
        var prevItemWho;
        for (var item in section.items) {
          Widget row = _buildItem(item, prevItemWho);
          var padding = new Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: row,
          );
          if (row != null) itemsList.add(padding);
          prevItemWho = item.who;
        }
      }
    }

    return itemsList;
  }
  List<Widget> _buildExpandedIndexedItems(item) {

    return stanzasColumn(item, returnType: 'list');
  }
}

bool _sectionHasHeader(section){
  return section.title != null
      || section.rubric != null
      || section.number != null
      || section.majorHeader !=null;
}

Widget _buildSectionHeader(section){
  List<Widget> headerList = [];
  if (section.majorHeader != null){
    headerList.add(_majorHeader(section.majorHeader));
  }

  if (section.number !=null){
    headerList.add(Center(child:_sectionNumber(section.number.toString())));
  }
  if (section.title !=null){
    headerList.add(new Padding(
        padding: new EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
        child:_sectionTitle(section.title)));
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
    headerList.add(new Padding(
        child:_rubric(section.rubric),
        padding: new EdgeInsets.only(bottom: 0.0, left: 20.0, right: 20.0),
    ));
  }
  return Padding(
    child: Column(
      children: headerList,
      mainAxisAlignment: MainAxisAlignment.start,
    ),
    padding: EdgeInsets.only(top:20.0, bottom: 0.0),
  );
}

Widget _rubric(rubric) {
    return Text(
      rubric,
      style: rubricTextStyle,
      textAlign: TextAlign.center,
    );
  }

Widget _sectionNumber(number){
  return Container(
//    fit: BoxFit.fitHeight,
    child: new Transform(
      child: new CircleAvatar(
          child: new Text(number.toString(),textScaleFactor: 2.0,),
//          backgroundColor: Colors.black26,
      ),
      alignment: Alignment.center,

      transform: new Matrix4.identity()
        ..scale(0.5),
    ),
  );
}

Widget _sectionTitle(title){
     return Text(
        title ,
        style: sectionTitleTextStyle,
        textAlign: TextAlign.center,
      );
}

Widget _sectionIndexName(section){
  return Text(
      section.indexName,
      textAlign: TextAlign.right,
  );
}

Widget _majorHeader(header){
  return Padding(
      padding: new EdgeInsets.only(top:30.0, bottom: 12.0),
      child:
      Text(
        header ,
        style: majorHeaderTextStyle,
        textAlign: TextAlign.center,
      )
  );
}

Widget _buildItem(item, language, [prevItemWho]){
  if (item.type == 'title' && item.text != null){
    return Padding(child:_sectionTitle(item.text),padding: EdgeInsets.only(top: 12.0),);
  }else if (item.type == 'rubric'){
    return Padding(child:_rubric(item.text),padding: EdgeInsets.only(top:18.0),);
  }else if (item.who == 'leader' || item.who == 'minister'
      || item.who == 'reader' || item.who == 'leaderOther' || item.who == 'bishop' || item.who == "archBishop"){
    return _leaderItem(item, language, prevItemWho);
  } else if (item.who == 'people' || item.who == 'all' || item.who== 'peopleOther') {
    return _peopleItem(item, language, prevItemWho);
  } else if (item.who == 'none') {
    return null;
  } else if (item.type == 'versedStanzas') {
    return stanzasColumn(item);
  } else if (item.type == 'stanzas' ){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:stanzasColumn(item));
  } else if (item.who == null) {
    return genericItem(item);
  } else {
    return _unknownItem(item);
  }
}

Widget _leaderItem(item, language, prevItemWho){
  Icon _pickedIcon = item.who == 'minister' ? Icon(Icons.person) : item.who == 'reader' ? Icon(Icons.local_library) : Icon(Icons.person);
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Opacity(
        opacity: item.who == prevItemWho ? 0.0 : 1.0,
        child: new Column(

          children: <Widget>[
            new CircleAvatar(
                child: _pickedIcon
            ),
            new Container(
              constraints: new BoxConstraints(maxWidth: 70.0),
              child: new Text(item.who == 'leaderOther' ? item.other :globals.translate(language, item.who), style: avatarTextStyle,),
            ),

          ],
        )
      ),
      new Flexible(
        child: new Padding(
          padding: EdgeInsets.only(left: 16.0, right: 42.0, top: 12.0),
          child:  _isStanzas(item) ? stanzasColumn(item) : _doesItemHasRef(item) ? _itemTextWithRef(item) : _itemText(item),
        )
      ),
    ],
  );
}

Widget _peopleItem(item, language, prevItemWho){
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

            child: _isStanzas(item) ? stanzasColumn(item, style: peopleItemTextStyle) : _doesItemHasRef(item) ? _itemTextWithRef(item, peopleItemTextStyle, TextAlign.right) : _itemText(item, peopleItemTextStyle, TextAlign.right),

          )
      ),
      new Opacity(
          opacity: item.who == prevItemWho ? 0.0 : 1.0,
          child: new Column(
            children: <Widget>[
              new CircleAvatar(
                  child: Icon(Icons.people)
              ),

              new Container(
                constraints: new BoxConstraints(maxWidth: 70.0),
                child: new Text(item.who == 'peopleOther' ? item.other : globals.translate(language, item.who), style: avatarTextStyle, textAlign: TextAlign.center,),
              ),
            ],
          )
      ),
    ],
  );
}

Widget genericItem(item){
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Expanded(
        child: new Padding(
          child: _doesItemHasRef(item) ? _itemTextWithRef(item) : _itemText(item),
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        ),
      )

    ],
  );
}

Widget _unknownItem(item){
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Column(
        children: <Widget>[
          new CircleAvatar(
              child: Icon(Icons.error),
              backgroundColor: Colors.red,
          ),
          new Text(item.who ?? '',style: avatarTextStyle,),
        ],
      ),
      new Expanded(
        child: _doesItemHasRef(item) ? _itemTextWithRef(item) : _itemText(item),
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

Text _itemText(item,[TextStyle style, TextAlign alignment = TextAlign.left]){
  if(style != null) {
    return Text(
      item.text, style: style,
      textAlign: alignment,
    );
  }else {
    return Text(item.text);
  }
}

RichText _itemTextWithRef(item,[TextStyle style, TextAlign alignment = TextAlign.left]){
  return RichText(

      textAlign: alignment,
      text: new TextSpan(
          text: item.text,
          style: new TextStyle(color: Colors.black),
          children:[
            new TextSpan(text: '   '),
            new TextSpan(text:item.ref, style: titleRefTextStyle),

          ]
      )
  );
}

//text style is passed on, return type can be either column or list.
//column is used for general creation, but a list will be used in an expanded
//indexed item.
dynamic stanzasColumn(item, {TextStyle style, String returnType: 'column'}){
  List<Widget> stanzaList = new List();

  if (item.title != null) {
    stanzaList.add(_canticleTitle(item.title));
  }

  if (item.ref != null) {
    stanzaList.add(_titleReference(item.ref));
  }

  var _itemType = item.type;
  for (var stanza in item.stanzas){
    Widget row;
    if(_itemType == 'versedStanzas' && stanza.type != 'gloria') {
      row = _versedStanza(stanza, style);
    }else {
      row= _stanza(stanza, style);
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

Widget _versedStanza(stanza, [TextStyle style]){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Container(
        child: new Text(stanza.verse ?? '',),
        width: 18.0,
      ),
      new Expanded(
          child: new Padding(
            padding: EdgeInsets.only(
            left: stanza.verse != null ? 0.0 : 18.0,
            bottom: stanza.verse != null ? 0.0 : 3.0,
            ),
            child: _itemText(stanza,style),
          ),
      )
    ],
  );
}

Widget _stanza(stanza, [TextStyle style]){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Flexible(
        child: new Padding(
          padding: EdgeInsets.only(
            left: stanza.indent != null ? int.tryParse(stanza.indent)*18.0 ?? 0.0 : 0.0,
          ),
          child: _itemText(stanza,style),
        ),
      )
    ]
  );
}

Widget buildDailyPrayers(Collect collect, language, [buildType='full']){

  Map<String, List> buildTypes = {
    'full': ['title', 'subtitle', 'type', 'date', 'color', 'ref', 'collects', 'postCommunions' ],
    'collect':['title', 'subtitle', 'type', 'date', 'collects'],
    'postCommunion':['title', 'subtitle', 'type', 'date', 'postCommunions'],
  };

  List sectionsToBuild = buildTypes[buildType];
  List<Widget> children = [];

  if(collect.title != null && sectionsToBuild.contains('title')){
    children.add(collectTitle(collect.title));
  }
  if(collect.subtitle != null && sectionsToBuild.contains('subtitle')){
    children.add(collectSubtitle(collect.subtitle));
  }

  if(collect.type != null && sectionsToBuild.contains('type')){
    children.add(collectProperty(collect.type));
  }

  if (collect.date != null && sectionsToBuild.contains('date')){
    children.add(collectProperty(collect.date));
  }

  if (collect.color != null && sectionsToBuild.contains('color')){
    children.add(collectProperty(collect.color));
  }

  if (collect.ref != null && sectionsToBuild.contains('ref')){
    children.add(collectProperty(collect.ref));
  }

  if ((collect.collectRubric  != null || collect.collectPrayers != null)  && sectionsToBuild.contains('postCommunions') && sectionsToBuild.contains('collects')){
    children.add(prayerHeader(globals.translate(language, "collect")));
  }
  if (collect.collectRubric != null  && sectionsToBuild.contains('collects')){
    children.add(_rubric(collect.collectRubric));
  }

  if (collect.collectPrayers != null  && sectionsToBuild.contains('collects')){

    children.addAll(prayers(collect.collectPrayers, language));

  }

  if ((collect.postCommunionRubric  != null || collect.postCommunionPrayers != null) && sectionsToBuild.contains('postCommunions') && sectionsToBuild.contains('collects')) {
    children.add(prayerHeader(globals.translate(language, 'postCommunionPrayer')));
  }

  if (collect.postCommunionRubric != null  && sectionsToBuild.contains('postCommunions')){
    children.add(_rubric(collect.postCommunionRubric));
  }

  if (collect.postCommunionPrayers != null  && sectionsToBuild.contains('postCommunions')){
//    List<Widget> collectList = [];
//    for (var prayer in collect.postCommunionPrayers){
//
//      if (prayer.type == 'versedStanzas') {
//        collectList.add(stanzasColumn(prayer));
//      } else if (prayer.type == 'stanzas' ){
//        collectList.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:stanzasColumn(prayer)));
//      } else {
//        collectList.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child: Text(prayer.text)));
//      }
//    }
//    if (collectList.length > 1){
//      collectList.insert(1,_rubric('Or'));
//    }
//    children.addAll(collectList);
    children.addAll(prayers(collect.postCommunionPrayers, language));


  }

  return new Column(
    children: children,
  );
}

Widget collectTitle(title){
  return Padding(
      padding: new EdgeInsets.only(top: 10.0, bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        title,
        style: canticleTitleTextStyle,
        textAlign: TextAlign.center,
      ),

  );
}

Widget collectSubtitle(title){
  return Padding(
      padding: new EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        title,
        style: collectSubtitleStyle,
        textAlign: TextAlign.center,
      )
  );
}

Widget prayerHeader(header){
  return Padding(
      padding: new EdgeInsets.only(top: 10.0, bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        header,
        style: collectPrayerHeaderStyle,
        textAlign: TextAlign.center,
      )
  );
}

List<Widget> prayers(listOfPrayers, language){
  List<Widget> collectList = [];
  for (var prayer in listOfPrayers){

    if (prayer.type == 'versedStanzas') {
      collectList.add(stanzasColumn(prayer));
    } else if (prayer.type == 'stanzas' ){
      collectList.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:stanzasColumn(prayer)));
    } else {
      collectList.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical:6.0),child: Text(prayer.text != null ? prayer.text : '')));
    }
  }
  if (collectList.length > 1){
    collectList.insert(1,_rubric(globals.translate(language, 'or')));
  }

  return collectList;
}


Widget collectProperty(property){
  return Padding(
      padding: new EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
      child: new Text(
        property,
        textAlign: TextAlign.center,
        style: collectPropertyStyle,
      ),
  );
}

Widget _canticleTitle(title){
  return Padding(
      padding: new EdgeInsets.only(top:12.0, bottom: 8.0),
      child: new Text(
        title,
        style: canticleTitleTextStyle,
        textAlign: TextAlign.center,
      )
  );
}



Widget _titleReference(ref){
  return Text(
    ref,
    style: titleRefTextStyle,
    textAlign: TextAlign.center,
  );
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);



