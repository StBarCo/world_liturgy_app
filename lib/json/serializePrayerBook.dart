import 'package:json_annotation/json_annotation.dart';

part 'serializePrayerBook.g.dart';

@JsonSerializable()
class PrayerBooksContainer extends Object {
  @JsonKey(fromJson: _decodePrayerBookorService, name: 'prayer_book')
  final List<PrayerBook> prayerBooks;

  PrayerBooksContainer(this.prayerBooks,);

  factory PrayerBooksContainer.fromJson(Map<String, dynamic> json) =>
      _$PrayerBooksContainerFromJson(json);

  getPrayerBookIndexById(String id) {
    List list = [];
    this.prayerBooks.forEach((prayerBook) {
      list.add(prayerBook.id);
    });

    return list.indexOf(id);
  }

  PrayerBook getPrayerBook(String id, {String language}) {
    List<PrayerBook> tempList;

    if(id == null && language != null){
      tempList = this.prayerBooks
          .where((prayerBook) => prayerBook.language == language).toList();
    } else {
      tempList = this.prayerBooks
          .where((prayerBook) => prayerBook.id == id).toList();
    }
    return tempList != null && tempList.length > 0 ? tempList.first : this.prayerBooks.first;
  }

  String getPrayerBookIdFromLanguage(String language) {
    return this.prayerBooks
        .where((prayerBook) => prayerBook.language == language).toList().first.id;
  }
}

@JsonSerializable()
class PrayerBook extends Object {
  final String language;
  final String id;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(name: "service", fromJson: _decodePrayerBookorService)
  final List<Service> services;

  PrayerBook(
      this.language,
      this.id,
      this.title,
      this.services,
      );
  factory PrayerBook.fromJson(Map<String, dynamic> json) => _$PrayerBookFromJson(json);

  getService(String id){
    return this.services.where((service) => service.id == id).first;
  }

  getServiceIndexById(String id){
    List list = [];
    for(Service service in this.services){
      list.add(service.id);

      if (service.id == id) {break;}
    }

    return list.indexOf(id);
  }
}

@JsonSerializable()
class Service extends Object {

  final String id;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(name: "section", fromJson: _decodeSection)
  final List<Section> sections;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String titleShort;

  Service(
      this.id,
      this.title,
      this.titleShort,
      this.sections,
      );

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

  getSection(String id){
    return this.sections.where((section) => section.type == id).toList();
  }

  getSectionIndexByType(String type){
    List list = [];
    this.sections.forEach((section){
      list.add(section.type);
    });

    return list.indexOf(type);
  }
}

@JsonSerializable()
class Section extends Object {
  @JsonKey(nullable: true,)
  final String type;

  @JsonKey(nullable: true,)
  final String visibility;

  @JsonKey(nullable: true,)
  final String schedule;

  @JsonKey(nullable: true,)
  final String fetchItemsFrom;

  @JsonKey(nullable: true, name: "major_header", fromJson: _asAttribute)
  final String majorHeader;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(nullable: true,  fromJson: _asIntAttribute)
  final int number;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String rubric;

  @JsonKey(name: "item", nullable: true, fromJson: _decodeItem)
  final List<Item> items;

  @JsonKey(name: "collect", nullable: true, fromJson: _decodeCollect)
  final List<Collect> collects;

  String get indexName{
    String string = '';
    if (this.number != null){
      string += this.number.toString() + ': ';
    }
    if (this.title != null){
      string += this.title;
    } else if (this.rubric != null){
      string += this.rubric;

    } else {
      string += this.items.first.text;
    }

    if (string.length > 27){
      string = string.substring(0,26) + '...';
    }

    return string;
  }


  Section(
      this.type,
      this.visibility,
      this.fetchItemsFrom,
      this.majorHeader,
      this.title,
      this.number,
      this.rubric,
      this.items,
      this.collects,
      this.schedule,
      );
  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

}

//@JsonSerializable()
//class MajorHeader extends Object with _$MajorHeaderSerializerMixin {
//  final String $t;
//  String get text => clean(this.$t);
//
//  MajorHeader(this.$t);
//  factory MajorHeader.fromJson(Map<String, dynamic> json) => _$MajorHeaderFromJson(json) ;
//}
//
//@JsonSerializable()
//class Title extends Object with _$TitleSerializerMixin {
//  final String $t;
//  String get text => clean(this.$t);
//
//  Title(this.$t);
//  factory Title.fromJson(Map<String, dynamic> json) => _$TitleFromJson(json) ;
//}
//
//@JsonSerializable()
//class Rubric extends Object with _$RubricSerializerMixin {
//  final String $t;
//  String get text => clean(this.$t);
//
//  final String link;
//
//  Rubric(this.$t, this.link);
//  factory Rubric.fromJson(Map<String, dynamic> json) => _$RubricFromJson(json);
//}

@JsonSerializable()
class Item extends Object {
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true,)
  final String who;

  @JsonKey(nullable: true)
  final String type;

  @JsonKey(nullable: true)
  final String includeGloria;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String ref;

  @JsonKey(nullable: true)
  final String other;

  @JsonKey(nullable: true, name:'stanza', fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  Item(
      this.$t,
      this.who,
      this.type,
      this.includeGloria,
      this.title,
      this.other,
      this.ref,
      this.stanzas,
      );
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

}

@JsonSerializable()
class Collect extends Object {

  @JsonKey(nullable: true,)
  final String id;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String subtitle;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String ref;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String color;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String date;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String type;

  @JsonKey(nullable: true, name:"collect_rubric", fromJson: _asAttribute)
  final String collectRubric;

  @JsonKey(nullable: true, name:"post_communion_rubric", fromJson: _asAttribute)
  final String postCommunionRubric;

  @JsonKey(nullable: true, name:"collect", fromJson: _decodeCollectPrayers)
  final List<CollectPrayer> collectPrayers;

  @JsonKey(nullable: true, name:"post_communion_prayer", fromJson: _decodePostCommunionPrayers)
  final List<PostCommunionPrayer> postCommunionPrayers;


  Collect(
      this.id,
      this.title,
      this.subtitle,
      this.ref,
      this.color,
      this.date,
      this.type,
      this.collectRubric,
      this.postCommunionRubric,
      this.collectPrayers,
      this.postCommunionPrayers,
      );
  factory Collect.fromJson(Map<String, dynamic> json) => _$CollectFromJson(json);

}

@JsonSerializable()
class CollectPrayer extends Object {
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true)
  final String type;

  @JsonKey(nullable: true, name:'stanza', fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  String get title => null;
  String get ref => null;

  CollectPrayer(
      this.$t,
      this.type,
      this.stanzas,
      );
  factory CollectPrayer.fromJson(Map<String, dynamic> json) => _$CollectPrayerFromJson(json);
}

@JsonSerializable()
class PostCommunionPrayer extends Object {
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true)
  final String type;

  @JsonKey(nullable: true, name:'stanza', fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  String get title => null;
  String get ref => null;

  PostCommunionPrayer(
      this.$t,
      this.type,
      this.stanzas,
      );
  factory PostCommunionPrayer.fromJson(Map<String, dynamic> json) => _$PostCommunionPrayerFromJson(json);

}

@JsonSerializable()
class Stanza extends Object {
  @JsonKey(nullable: true)
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true)
  final String verse;

  @JsonKey(nullable: true)
  final String indent;

  @JsonKey(nullable: true)
  final String type;

  Stanza(
      this.verse,
      this.indent,
      this.$t,
      this.type);
  factory Stanza.fromJson(Map<String, dynamic> json) => _$StanzaFromJson(json);
}

String clean(String s) => s?.replaceAll(new RegExp(r"\\r\\n+ *|\\"), '');

_decodePrayerBookorService(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];

  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  if (list.first['service'] != null){
    return list.map((e) =>
    e == null ? null : new PrayerBook.fromJson(e as Map<String, dynamic>))
        ?.toList();
  }else if (list.first['section'] != null){
    return list.map((e) =>
    e == null ? null : new Service.fromJson(e as Map<String, dynamic>))
        ?.toList();
  }else{
    return null;
  }
}

_decodeSection(itemOrList){
  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Section.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodeItem(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Item.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodeStanza(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Stanza.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodeCollect(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Collect.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodeCollectPrayers(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new CollectPrayer.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodePostCommunionPrayers(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new PostCommunionPrayer.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

String _asAttribute(item){
  try {
    return clean(item[r'$t']);
  } catch (e){
    print(e);
    print("Error serializing PrayerBooks in _asAttribute function");
    print(item.toString());
    return null;
  }
}

int _asIntAttribute(item){

  try {
    return int.parse(item[r'$t']);
  } catch (e){
    print(e);
    print("Error serializing PrayerBooks in _asIntAttribute function");
    print(item.toString());
    return null;
  }

}