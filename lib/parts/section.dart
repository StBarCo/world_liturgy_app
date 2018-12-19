import 'package:flutter/material.dart';

import '../app.dart';
import '../globals.dart' as globals;
import '../theme.dart';
import '../json/serializePrayerBook.dart';

import '../model/calendar.dart';
import '../pages/calendar.dart';

part 'collects.dart';

class GeneralContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _sectionCard(null);
  }

  Widget _sectionCard(child) {
    return Card(
        margin: EdgeInsets.only(bottom: 8.0),
        elevation: 0.0,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: child));
  }

  Widget _rubric(String rubric, BuildContext context) {
    return Text(
      rubric.toString(),
      style:
          Theme.of(context).textTheme.caption.merge(referenceAndSubtitleStyle),
      textAlign: TextAlign.center,
    );
  }

  Widget _sectionNumber(int number, BuildContext context) {
    return Container(
//    fit: BoxFit.fitHeight,
      child: Transform(
        child: CircleAvatar(
          child: Text(
            number.toString(),
            textScaleFactor: 2.0,
          ),
          foregroundColor: Theme.of(context).primaryIconTheme.color,
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(0.5),
      ),
    );
  }

  Widget _sectionTitle(String title, collapsed, BuildContext context) {
    if (collapsed) {
      return Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(color: Theme.of(context).primaryColorDark),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        title,
        style: Theme.of(context).textTheme.subhead,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _majorHeader(String header, BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0, bottom: 12.0),
        child: Text(
          header,
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.center,
        ));
  }

  Widget _buildItem(Item item, BuildContext context, [prevItemWho]) {
    if (item.type == 'title' && item.text != null) {
      return Padding(
        child: _sectionTitle(item.text, false, context),
        padding: EdgeInsets.only(top: 12.0),
      );
    } else if (item.type == 'rubric') {
      return Padding(
        child: _rubric(item.text, context),
        padding: EdgeInsets.only(top: 18.0, bottom: 5.0),
      );
    } else if (item.type == 'reading') {
      return Container();
//    return lectionaryReading(item, context);
//        TODO: make methods to show header, fields, and reading(s).

    } else if (item.who == 'leader' ||
        item.who == 'minister' ||
        item.who == 'reader' ||
        item.who == 'leaderOther' ||
        item.who == 'bishop' ||
        item.who == "archBishop") {
      return _leaderItem(item, prevItemWho, context);
    } else if (item.who == 'people' ||
        item.who == 'all' ||
        item.who == 'peopleOther') {
      return _peopleItem(item, prevItemWho, context);
    } else if (item.who == 'none') {
      return null;
    } else if (item.type == 'versedStanzas') {
      return stanzasColumn(item, context);
    } else if (item.type == 'stanzas') {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: stanzasColumn(item, context));
    } else if (item.who == null) {
      return genericItem(item, context);
    } else {
      return _unknownItem(item, context);
    }
  }

  Widget _leaderItem(Item item, prevItemWho, BuildContext context) {
    var _pickedIcon = item.who == 'minister'
        ? Icon(Icons.person)
        : item.who == 'reader' ? Icon(Icons.local_library) : Icon(Icons.person);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Opacity(
            opacity: item.who == prevItemWho ? 0.0 : 1.0,
            child: Column(
                children: _makeAvatar(
              _pickedIcon,
              item.who == 'leaderOther'
                  ? item.other
                  : globals.translate(getLanguage(context), item.who),
              context,
            ))),
        Flexible(
            child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 42.0, top: 12.0),
          child: _isStanzas(item)
              ? stanzasColumn(item, context,
                  style: Theme.of(context).textTheme.body1)
              : _doesItemHasRef(item)
                  ? _itemTextWithRef(
                      item,
                      Theme.of(context).textTheme.body1,
                      Theme.of(context)
                          .textTheme
                          .caption
                          .merge(referenceAndSubtitleStyle))
                  : _itemText(item, style: Theme.of(context).textTheme.body1),
        )),
      ],
    );
  }

  Widget _peopleItem(Item item, prevItemWho, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
            child: Padding(
          padding: EdgeInsets.only(
              left: item.who == 'all' ? 16.0 : 42.0, right: 16.0, top: 12.0),
          child: _isStanzas(item)
              ? stanzasColumn(item, context,
                  style: Theme.of(context).textTheme.body2)
              : _doesItemHasRef(item)
                  ? _itemTextWithRef(
                      item,
                      Theme.of(context).textTheme.body2,
                      Theme.of(context)
                          .textTheme
                          .caption
                          .merge(referenceAndSubtitleStyle),
                      alignment: TextAlign.right)
                  : _itemText(item,
                      style: Theme.of(context).textTheme.body2,
                      alignment: TextAlign.right),
        )),
        Opacity(
            opacity: item.who == prevItemWho ? 0.0 : 1.0,
            child: Column(
                children: _makeAvatar(
              Icon(Icons.people),
              item.who == 'peopleOther'
                  ? item.other
                  : globals.translate(getLanguage(context), item.who),
              context,
            ))),
      ],
    );
  }

  Widget genericItem(Item item, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            child: _doesItemHasRef(item)
                ? _itemTextWithRef(
                    item,
                    Theme.of(context).textTheme.body1,
                    Theme.of(context)
                        .textTheme
                        .caption
                        .merge(referenceAndSubtitleStyle))
                : _itemText(item, style: Theme.of(context).textTheme.body1),
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          ),
        )
      ],
    );
  }

  Widget _unknownItem(Item item, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
            children: _makeAvatar(Icon(Icons.error), item.who ?? '', context,
                color: Colors.red)),
        Expanded(
          child: _doesItemHasRef(item)
              ? _itemTextWithRef(
                  item,
                  Theme.of(context).textTheme.body1,
                  Theme.of(context)
                      .textTheme
                      .caption
                      .merge(referenceAndSubtitleStyle))
              : _itemText(item, style: Theme.of(context).textTheme.body1),
        ),
//          Column(
//            children: <Widget>[
//              CircleAvatar(
//                child: Icon(Icons.group),
//                backgroundColor: Colors.green,
//              ),
//              Text(item.who ?? 'no who'),
//            ],
//          ),
      ],
    );
  }

  List<Widget> _makeAvatar(Icon avatar, String label, context, {Color color}) {
    List<Widget> list = [
      CircleAvatar(
        child: avatar,
        backgroundColor: Theme.of(context).primaryColorLight,
        foregroundColor: color ?? Theme.of(context).iconTheme.color,
      ),
      Container(
        constraints: BoxConstraints(maxWidth: 70.0),
        child: Text(
          label,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ),
    ];
    return list;
  }

  bool _doesItemHasRef(Item item) {
    try {
      return item.ref != null;
    } catch (e) {
      return false;
    }
  }

  Text _itemText(dynamic item,
      {TextStyle style, TextAlign alignment = TextAlign.left}) {
    if (style != null) {
      return Text(
        item.text,
        style: style,
        textAlign: alignment,
      );
    } else {
      return Text(item.text);
    }
  }

  RichText _itemTextWithRef(Item item, TextStyle style, TextStyle refStyle,
      {TextAlign alignment = TextAlign.left}) {
    return RichText(
        textAlign: alignment,
        text: TextSpan(text: item.text, style: style, children: [
          TextSpan(text: '   '),
          TextSpan(text: item.ref, style: refStyle),
        ]));
  }

  dynamic stanzasColumn(dynamic item, context,
      {TextStyle style, String returnType: 'column', String exclude: 'none'}) {
    List<Widget> stanzaList = List();

    if (item.title != null &&
        (exclude == 'none' || !exclude.contains('title'))) {
      stanzaList.add(_canticleTitle(item.title, context));
    }

    if (item.ref != null && (exclude == 'none' || !exclude.contains('ref'))) {
      stanzaList.add(_titleReference(item.ref, context));
    }

    var _itemType = item.type;
    for (var stanza in item.stanzas) {
      Widget row;
      if (_itemType == 'versedStanzas' && stanza.type != 'gloria') {
        row = _versedStanza(stanza, style: style);
      } else {
        row = _stanza(stanza, style: style);
      }

      var padding = Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0),
        child: row,
      );
      if (row != null) stanzaList.add(padding);
    }

    if (returnType == 'list') {
      return stanzaList;
    } else {
      return Column(
        children: stanzaList,
      );
    }
  }

  Widget _versedStanza(Stanza stanza, {TextStyle style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            stanza.verse ?? '',
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
          width: 18.0,
        ),
        Expanded(
          child: Padding(
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

  Widget _stanza(Stanza stanza, {TextStyle style}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                left: stanza.indent != null
                    ? int.tryParse(stanza.indent) * 18.0 ?? 0.0
                    : 0.0,
              ),
              child: _itemText(stanza, style: style),
            ),
          )
        ]);
  }

  bool _isStanzas(Item item) {
    return item.type != null && item.type == 'stanzas' ||
        item.type == 'versedStanzas';
  }

  Widget _titleReference(ref, context) {
    return Text(
      ref,
      style:
          Theme.of(context).textTheme.caption.merge(referenceAndSubtitleStyle),
      textAlign: TextAlign.center,
    );
  }

  Widget _canticleTitle(title, context) {
    return Padding(
        padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 16.0),
          textAlign: TextAlign.center,
        ));
  }


  Widget _collectTitle(title, context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _collectSubtitle(title, context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
        child: Text(
          title,
          style:
          Theme.of(context).textTheme.body2.copyWith(color: Colors.black38),
          textAlign: TextAlign.center,
        ));
  }

  Widget _prayerHeader(header, context) {
    return Padding(
        padding:
        EdgeInsets.only(top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
        child: Text(
          header,
          style:
          Theme.of(context).textTheme.body2.copyWith(color: Colors.black38),
          textAlign: TextAlign.center,
        ));
  }

  Widget _prayers(listOfPrayers, language, context) {
    List<Widget> collectList = [];
    for (var prayer in listOfPrayers) {
      if (prayer.type == 'versedStanzas') {
        collectList.add(stanzasColumn(prayer, context));
      } else if (prayer.type == 'stanzas') {
        collectList.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: stanzasColumn(prayer, context,
                style: Theme.of(context).textTheme.body1)));
      } else {
        collectList.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
            child: Text(
              prayer.text != null ? prayer.text : '',
              style: Theme.of(context).textTheme.body1,
            )));
      }
    }
    if (collectList.length > 1) {
      collectList.insert(
          1, _rubric(globals.translate(language, 'or'), context));
    }
    return Padding(
      child: Column(children: collectList),
      padding: EdgeInsets.only(bottom: 0.0),
    );
  }

  Widget _collectProperty(property, TextStyle style) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
      child: Text(
        property,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}

class SectionContent extends GeneralContent {
//  final Map currentIndexes;
  final Section section;

  SectionContent(
    //      this.currentIndexes,
    this.section,
  );

  @override
  Widget build(BuildContext context) {
    Widget items = _sectionItems(section, context);
    if (items != null) {
      return _sectionCard(items);
    } else {
      return Container();
    }
  }

  Widget _sectionItems(section, context) {
    List<Widget> itemsList = [];

    if (_sectionHasHeader(section)) {
      itemsList.add(_buildSectionHeader(section, context));
    }
    if (section.items != null) {
      var prevItemWho;
      for (var item in section.items) {
        Widget row = _buildItem(
          item,
          context,
          prevItemWho,
        );
        var padding = Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: row,
        );
        if (row != null) itemsList.add(padding);
        prevItemWho = item.who;
      }
    }
    if (itemsList != null) {
      return Column(children: itemsList);
    }
    return null;
  }

  bool _sectionHasHeader(Section section) {
    return section.title != null ||
        section.rubric != null ||
        section.number != null ||
        section.majorHeader != null;
  }

  Widget _buildSectionHeader(Section section, BuildContext context,
      {bool collapsed: false}) {
    List<Widget> headerList = [];
    if (section.majorHeader != null) {
      headerList.add(_majorHeader(section.majorHeader, context));
    }

    if (section.number != null) {
      headerList.add(Center(child: _sectionNumber(section.number, context)));
    }
    if (section.title != null) {
      headerList.add(Padding(
          padding: EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
          child: _sectionTitle(section.title, collapsed, context)));
    }

    if (section.rubric != null) {
      headerList.add(Center(
        child: Padding(
          child: _rubric(section.rubric, context),
          padding: EdgeInsets.only(bottom: 5.0, left: 20.0, right: 20.0),
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
      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
    );
  }
}

/// CollectSectionContent is to render the section of the PrayerBook that
/// holds the Collects for various seasons. The method used to render the
/// individual collects as needed for a various day is CollectContent
/// in collects.dart.
class CollectSectionContent extends SectionContent {
  CollectSectionContent(section) : super(section);

  Widget _sectionItems(section, context) {
    List<Widget> itemsList = [];

    if (_sectionHasHeader(section)) {
      itemsList.add(_buildSectionHeader(section, context));
    }

    for (var collect in section.collects) {
      Widget column = DailyPrayersContent(collect);
      var padding = Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: column,
      );
      if (column != null) itemsList.add(padding);
    }

    return Column(children: itemsList);
  }
}

class CollapsedSectionCard extends SectionContent {
  CollapsedSectionCard(section) : super(section);

  Widget _sectionItems(section, context) {
    String language = getLanguage(context);
    return GestureDetector(
      onTap: () {
        var route = MaterialPageRoute(
          builder: (BuildContext itemContext) => RefreshState(
              currentDay: RefreshState.of(context).currentDay,
              currentLanguage: language,
              textScaleFactor: RefreshState.of(context).textScaleFactor,
              child: MediaQuery(
                data: MediaQuery.of(itemContext).copyWith(
                    textScaleFactor: RefreshState.of(context).textScaleFactor),
                child: Theme(
                  data: updateTheme(
                      Theme.of(context), RefreshState.of(context).currentDay),
                  child: ExpandedSection(
                    section,
                    language,
                    Theme.of(context),
                  ),
                ),
              )),
        );
        Navigator.push(context, route);
      },
      child: Column(
        children: <Widget>[
          _buildSectionHeader(section, context, collapsed: true),
          Text(
            globals.translate(language, "tapToExpand"),
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Theme.of(context).primaryColorDark),
          ),
        ],
      ),
    );
  }
}

class IndexedSectionCard extends SectionContent {
  IndexedSectionCard(section) : super(section);

  Widget _sectionItems(section, context) {
    List<Widget> headers = [];

    headers.add(_buildSectionHeader(section, context));

    for (var item in section.items) {
      headers.add(GestureDetector(
          onTap: () {
            var route = MaterialPageRoute(
              builder: (BuildContext itemContext) => RefreshState(
                  currentDay: RefreshState.of(context).currentDay,
                  currentLanguage: RefreshState.of(context).currentLanguage,
                  textScaleFactor: RefreshState.of(context).textScaleFactor,
//              onTap: onTap,
                  child: MediaQuery(
                    data: MediaQuery.of(itemContext).copyWith(
                        textScaleFactor:
                            RefreshState.of(context).textScaleFactor),
                    child: Theme(
                      data: updateTheme(Theme.of(context),
                          RefreshState.of(context).currentDay),
                      child: ExpandedIndexedContent(
                        section,
                        item,
                      ),
                    ),
                  )),
            );
            Navigator.push(context, route);
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(item.title,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColorDark,
                        ),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  item.ref ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .merge(referenceAndSubtitleStyle)
                      .copyWith(color: Theme.of(context).primaryColorDark),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                    globals.translate(getLanguage(context), "tapToExpand"),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Theme.of(context).primaryColorDark),
                    textAlign: TextAlign.center),
              ),
            ],
          )));
    }
    return Padding(
      child: Column(children: headers),
      padding: EdgeInsets.symmetric(horizontal: 48.0),
    );
  }
}

class ExpandedSection extends SectionContent {
  final String currentLanguage;
  final ThemeData theme;

  ExpandedSection(section, this.currentLanguage, this.theme) : super(section);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        appBar: AppBar(
          elevation: 5.0,
          textTheme: Theme.of(context).textTheme,
          title: appBarTitle(section.indexName, context),
        ),
        body: ListView(
          children: <Widget>[
            Card(
                margin: EdgeInsets.only(bottom: 8.0),
                elevation: 0.0,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      children: _buildExpandedSectionItems(
                          section, currentLanguage, context),
                    )))
          ],
        ));
  }

  List<Widget> _buildExpandedSectionItems(section, language, context) {
    List<Widget> itemsList = List<Widget>();
    if (section.rubric != null) {
      itemsList.add(Padding(
        child: _rubric(section.rubric, context),
        padding: EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
      ));
    }
    if (section.items != null) {
      var prevItemWho;
      for (var item in section.items) {
        Widget row = _buildItem(item, context, prevItemWho);
        var padding = Padding(
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

class ExpandedIndexedContent extends SectionContent {
  final Item item;

  ExpandedIndexedContent(section, this.item) : super(section);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          textTheme: Theme.of(context).textTheme,
          title: appBarTitle(item.title, context),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: _buildExpandedIndexedItems(item, context),
        ));
  }

  List<Widget> _buildExpandedIndexedItems(item, context) {
    return stanzasColumn(item, context, returnType: 'list', exclude: 'title');
  }
}

//text style is passed on, return type can be either column or list.
//column is used for general creation, but a list will be used in an expanded
//indexed item.

class DailyPrayersContent extends GeneralContent {
  final Collect collect;
  final String buildType;

  DailyPrayersContent(this.collect, [this.buildType = 'full']);

  build(BuildContext context) {
    Map<String, List> buildTypes = {
      'full': [
        'title',
        'subtitle',
        'type',
        'date',
        'color',
        'ref',
        'collects',
        'postCommunions'
      ],
      'collect': ['title', 'subtitle', 'type', 'date', 'collects'],
      'postCommunion': ['title', 'subtitle', 'type', 'date', 'postCommunions'],
      'titles': ['title']
    };

    List sectionsToBuild = buildTypes[buildType];
    List<Widget> children = [];
    String language = getLanguage(context);

    if (collect.title != null && sectionsToBuild.contains('title')) {
      children.add(_collectTitle(collect.title, context));
    }
    if (collect.subtitle != null && sectionsToBuild.contains('subtitle')) {
      children.add(_collectSubtitle(collect.subtitle, context));
    }

    if (collect.type != null && sectionsToBuild.contains('type')) {
      children.add(
        _collectProperty(
            collect.type,
            Theme.of(context)
                .textTheme
                .caption
                .merge(referenceAndSubtitleStyle)),
      );
    }

    if (collect.date != null && sectionsToBuild.contains('date')) {
      children.add(_collectProperty(
          collect.date,
          Theme.of(context)
              .textTheme
              .caption
              .merge(referenceAndSubtitleStyle)));
    }

    if (collect.color != null && sectionsToBuild.contains('color')) {
      children.add(_collectProperty(
          collect.color,
          Theme.of(context)
              .textTheme
              .caption
              .merge(referenceAndSubtitleStyle)));
    }

    if (collect.ref != null && sectionsToBuild.contains('ref')) {
      children.add(_collectProperty(
          collect.ref,
          Theme.of(context)
              .textTheme
              .caption
              .merge(referenceAndSubtitleStyle)));
    }

    if ((collect.collectRubric != null || collect.collectPrayers != null) &&
        sectionsToBuild.contains('postCommunions') &&
        sectionsToBuild.contains('collects')) {
      children
          .add(_prayerHeader(globals.translate(language, "collect"), context));
    }
    if (collect.collectRubric != null && sectionsToBuild.contains('collects')) {
      children.add(_rubric(collect.collectRubric, context));
    }

    if (collect.collectPrayers != null &&
        sectionsToBuild.contains('collects')) {
      children.add(_prayers(collect.collectPrayers, language, context));
    }

    if ((collect.postCommunionRubric != null ||
            collect.postCommunionPrayers != null) &&
        sectionsToBuild.contains('postCommunions') &&
        sectionsToBuild.contains('collects')) {
      children.add(_prayerHeader(
          globals.translate(language, 'postCommunionPrayer'), context));
    }

    if (collect.postCommunionRubric != null &&
        sectionsToBuild.contains('postCommunions')) {
      children.add(_rubric(collect.postCommunionRubric, context));
    }

    if (collect.postCommunionPrayers != null &&
        sectionsToBuild.contains('postCommunions')) {
      children.add(_prayers(collect.postCommunionPrayers, language, context));
    }
    return Column(
      children: children,
    );
  }


}

//String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
