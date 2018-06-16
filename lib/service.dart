import 'package:flutter/material.dart';
import 'package:world_liturgy_app/json/serializePrayerBook.dart';
import 'globals.dart' as globals;
import 'package:world_liturgy_app/json/serializeCalendar.dart';

class ServiceView extends StatelessWidget{
  final currentService;
  final currentIndexes;

  ServiceView({Key key, @required this.currentService, @required this.currentIndexes}) : super(key: key);

//  ServiceViewState();

  @override
  Widget build(BuildContext context) {
    final allPrayerBooks = globals.allPrayerBooks;

//    PrayerBook currentPrayerBook = allPrayerBooks.prayerBooks[prayerBookIndex];
//    Service currentService = currentPrayerBook.services[serviceIndex];

    return new Scaffold (
      drawer: _buildDrawer(allPrayerBooks.prayerBooks, currentIndexes),
      appBar: new AppBar(
        title: new Text(currentService.title),
        actions:  <Widget>[

//          eventually will use MaterialSearch to find index item and navigate to it
//        first need resolution on this: https://github.com/flutter/flutter/issues/12319
////        currently flutter cannot go to item
//          new IconButton(
//            onPressed: () {
////              _showMaterialSearch(context);
//            },
//            tooltip: 'Search',
//            icon: new Icon(Icons.search),
//          )
        ],
      ),
      body: _buildService(context, currentService),
    );
  }

  Drawer _buildDrawer(prayerBooks, currentIndexes) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
        new DrawerPrayerBookEntry(context, prayerBooks[index], currentIndexes),
        itemCount: prayerBooks.length,
      ),
    );
  }
  

//TODO: Look at refactoring service building with widget classes
//  https://flutter.io/catalog/samples/expansion-tile-sample/
  Widget _buildService(BuildContext context, Service service) {

    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: service.sections.length,
        itemBuilder: (context, index) {
           var section = service.sections[index];
                return _buildSection(context, section);
        },


    );
  }

    Widget _buildSection(BuildContext context, section){
//      final alreadySaved = _saved.contains(pair);
      return new Column(
        children: _buildItemsList(context, section),
      );
    }

    List<Widget> _buildItemsList(BuildContext context, section){
      List<Widget> itemsList = new List<Widget>();

      if (section.visibility == 'collapsed') {
        itemsList.add(_buildHeaderForCollapsed(context, section));
      } else if (section.visibility == 'indexed'){
        itemsList.add(_buildSectionHeader( section));
        itemsList.add(_buildLinksForIndexed(context, section));
      } else if (section.visibility == 'hidden') {
        itemsList.add(new Row());
      } else {
        if (_sectionHasHeader(section)) {
          itemsList.add(_buildSectionHeader(section));
        }
          if (section.items != null) {
            var prevItemWho;
            for (var item in section.items) {
              Widget row = _buildItem(item, prevItemWho);
              var padding = new Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: row,
              );
              if (row != null) itemsList.add(padding);
              prevItemWho = item.who;
            }
          }
        }
        return itemsList;
      }


  _buildHeaderForCollapsed(context, section){
    return GestureDetector(
        onTap: () {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new ExpandedSection(section: section,)
          );
          Navigator.push(context, route);
        },
        child: new Column(
          children: <Widget>[
            _buildSectionHeader(section),
            new Text('Tap to expand.'.toUpperCase(), style: _rubricTextStyle,)
          ],
        )
    );
  }

  _buildLinksForIndexed(context, section) {
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
                  child:  new Text(item.title, style: _canticleTitleTextStyle, textAlign: TextAlign.center),

              ),
              new Padding(
                padding: EdgeInsets.only(top:4.0),
                child: new Text(item.ref ?? '', style: _titleRefTextStyle, textAlign: TextAlign.center,),

              ),
              new Padding(
                padding: EdgeInsets.only(top:4.0),
                child: new Text('Tap to expand.', style: _rubricTextStyle, textAlign: TextAlign.center),
              ),
            ],
          )
      )
      );
    }
    return Padding(child: new Column(children:headers), padding: EdgeInsets.symmetric(horizontal: 48.0),);
  }
}

class DrawerPrayerBookEntry extends StatelessWidget {
  const DrawerPrayerBookEntry(BuildContext context, this.prayerBook, this.currentIndexes);

  final PrayerBook prayerBook;
  final currentIndexes;

  Widget _buildTiles(BuildContext context, PrayerBook prayerBook) {
    if (prayerBook.services.isEmpty)
      return new ListTile(title: new Text(prayerBook.title ?? 'No Title'));
    return new ExpansionTile(
      key: new PageStorageKey<PrayerBook>(prayerBook),
      title: new Text(prayerBook.title ?? 'No title'),
      children: _buildServicesTiles(context, prayerBook),
      initiallyExpanded: prayerBook.id == currentIndexes['prayerBook'],

    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context, prayerBook);
  }


  List<Widget> _buildServicesTiles(context, prayerBook) {
    List<Widget> servicesList = [];
//    Service serviceName;
    for (var service in prayerBook.services) {
      servicesList.add(new ListTile(
        title: new Text(service.title ?? 'No title',),
        selected: service.id == currentIndexes['service'] && prayerBook.id == currentIndexes['prayerBook'],
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return ServiceView(
                  currentService: service, currentIndexes: {'prayerBook':prayerBook.id, 'service': service.id},
              );
            },
          ));
        },
      ));
    }
    return servicesList;

  }
}

class ExpandedSection extends StatelessWidget {
  final Section section;

  ExpandedSection({ Key key, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: _sectionIndexName(section),
        ),
        body: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: _buildExpandedSectionItems(section),

        )
    );
  }



  List<Widget> _buildExpandedSectionItems(section) {
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
        Widget row = _buildItem(item, prevItemWho);
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

    return _stanzasColumn(item, returnType: 'list');
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
    headerList.add(Center(child:_sectionNumber(section.number)));
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
      rubric.toUpperCase(),
      style: _rubricTextStyle,
      textAlign: TextAlign.center,
    );
  }

Widget _sectionNumber(number){
  return Container(
//    fit: BoxFit.fitHeight,
    child: new Transform(
      child: new CircleAvatar(
          child: new Text(number,textScaleFactor: 2.0,),
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
        style: _sectionTitleTextStyle,
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
        style: _majorHeaderTextStyle,
        textAlign: TextAlign.center,
      )
  );
}

Widget _buildItem(item, [prevItemWho]){
  if (item.type == 'title' && item.text != null){
    return Padding(child:_sectionTitle(item.text),padding: EdgeInsets.only(top: 12.0),);
  }else if (item.type == 'rubric'){
    return Padding(child:_rubric(item.text),padding: EdgeInsets.only(top:18.0),);
  }else if (item.who == 'leader' || item.who == 'minister'
      || item.who == 'reader' || item.who == 'assistant'){
    return _leaderItem(item, prevItemWho);
  } else if (item.who == 'people' || item.who == 'all') {
    return _peopleItem(item, prevItemWho);
  } else if (item.who == 'none') {
    return null;
  } else if (item.type == 'versedStanzas') {
    return _stanzasColumn(item);
  } else if (item.type == 'stanzas' ){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 18.0),child:_stanzasColumn(item));
  } else if (item.who == null) {
    return _genericItem(item);
  } else {
    return _unknownItem(item);
  }
}

Widget _leaderItem(item, prevItemWho){
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

            new Text(capitalize(item.who), style: _avatarTextStyle,),
          ],
        )
      ),
      new Flexible(
        child: new Padding(
          padding: EdgeInsets.only(left: 16.0, right: 42.0, top: 12.0),
          child:  _isStanzas(item) ? _stanzasColumn(item) : _doesItemHasRef(item) ? _itemTextWithRef(item) : _itemText(item),
        )
      ),
    ],
  );
}

Widget _peopleItem(item, prevItemWho){
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

            child: _isStanzas(item) ? _stanzasColumn(item, style: _peopleItemTextStyle) : _doesItemHasRef(item) ? _itemTextWithRef(item, _peopleItemTextStyle, TextAlign.right) : _itemText(item, _peopleItemTextStyle, TextAlign.right),

          )
      ),
      new Opacity(
          opacity: item.who == prevItemWho ? 0.0 : 1.0,
          child: new Column(
            children: <Widget>[
              new CircleAvatar(
                  child: Icon(Icons.people)
              ),

              new Text(capitalize(item.who), style: _avatarTextStyle,),
            ],
          )
      ),
    ],
  );
}

Widget _genericItem(item){
  return new Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      new Expanded(
        child: new Padding(
          child: _doesItemHasRef(item) ? _itemTextWithRef(item) : _itemText(item),
          padding: EdgeInsets.symmetric(horizontal: 18.0),
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
          new Text(item.who ?? '',style: _avatarTextStyle,),
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
  return item.ref != null;
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
            new TextSpan(text:item.ref, style: _titleRefTextStyle),

          ]
      )
  );
}

//text style is passed on, return type can be either column or list.
//column is used for general creation, but a list will be used in an expanded
//indexed item.
dynamic _stanzasColumn(item, {TextStyle style, String returnType: 'column'}){
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
    if(_itemType == 'versedStanzas') {
      row = _versedStanza(stanza, style);
    }else if(_itemType == 'stanzas'){
      row= _stanza(stanza, style);
    }

    var padding = new Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: row,
    );
    if (row != null) stanzaList.add(row);
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
            bottom: stanza.verse != null ? 0.0 : 6.0,
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

Widget _canticleTitle(title){
  return Padding(
      padding: new EdgeInsets.only(top:12.0, bottom: 8.0),
      child: new Text(
        title,
        style: _canticleTitleTextStyle,
        textAlign: TextAlign.center,
      )
  );
}

Widget _titleReference(ref){
  return Text(
    ref,
    style: _titleRefTextStyle,
    textAlign: TextAlign.center,
  );
}

TextStyle _peopleItemTextStyle = new TextStyle(fontWeight: FontWeight.bold, );
TextStyle _rubricTextStyle = new TextStyle(fontSize: 10.0, color: Colors.black54 );
TextStyle _sectionTitleTextStyle = new TextStyle(fontSize: 18.0);
TextStyle _majorHeaderTextStyle = new TextStyle(fontSize: 20.0, );
TextStyle _avatarTextStyle = new TextStyle(fontSize: 10.0, color: Colors.black54);
TextStyle _canticleTitleTextStyle = new TextStyle(fontSize: 16.0);
TextStyle _titleRefTextStyle = new TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0, );


String capitalize(String s) => s[0].toUpperCase() + s.substring(1);