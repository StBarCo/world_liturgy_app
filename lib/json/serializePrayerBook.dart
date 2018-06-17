import 'package:json_annotation/json_annotation.dart';

part 'serializePrayerBook.g.dart';

@JsonSerializable()
class PrayerBooksContainer extends Object with _$PrayerBooksContainerSerializerMixin {
  @JsonKey(fromJson: _decodePrayerBookorService, name:'prayer_book')
  final List<PrayerBook> prayerBooks;

  PrayerBooksContainer(
      this.prayerBooks,
      );

  factory PrayerBooksContainer.fromJson(Map<String, dynamic> json) => _$PrayerBooksContainerFromJson(json);
}

@JsonSerializable()
class PrayerBook extends Object with _$PrayerBookSerializerMixin {
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
    return this.services.where((service) => service.id == id).toList();
  }

  getServiceIndexById(String id){
    List list = [];
    this.services.forEach((service){
      list.add(service.id);
    });

    return list.indexOf(id);
  }
}

@JsonSerializable()
class Service extends Object with _$ServiceSerializerMixin {

  final String id;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(name: "section", fromJson: _decodeSection)
  final List<Section> sections;

  Service(
      this.id,
      this.title,
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
class Section extends Object with _$SectionSerializerMixin {
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
    if (this.majorHeader != null){
      string += this.majorHeader + ' ';
    }else if (this.title != null){
      string += this.title + ' - ';
    }else if (this.rubric !=null){
      string += this.rubric;
    }else if (this.items[0]?.text != null){
      string += this.items[0].text.toString();
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
class Item extends Object with _$ItemSerializerMixin{
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

  @JsonKey(nullable: true, name:'stanza', fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  Item(
      this.$t,
      this.who,
      this.type,
      this.includeGloria,
      this.title,
      this.ref,
      this.stanzas,
      );
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

}

@JsonSerializable()
class Collect extends Object with _$CollectSerializerMixin{

  @JsonKey(nullable: true,)
  final String id;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

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
class CollectPrayer extends Object with _$CollectPrayerSerializerMixin{
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true)
  final String type;

  @JsonKey(nullable: true, name:'stanza', fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  CollectPrayer(
      this.$t,
      this.type,
      this.stanzas,
      );
  factory CollectPrayer.fromJson(Map<String, dynamic> json) => _$CollectPrayerFromJson(json);
}

@JsonSerializable()
class PostCommunionPrayer extends Object with _$PostCommunionPrayerSerializerMixin{
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true)
  final String type;

  @JsonKey(nullable: true, name:'stanza', fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  PostCommunionPrayer(
      this.$t,
      this.type,
      this.stanzas,
      );
  factory PostCommunionPrayer.fromJson(Map<String, dynamic> json) => _$PostCommunionPrayerFromJson(json);

}

@JsonSerializable()
class Stanza extends Object with _$StanzaSerializerMixin {
  @JsonKey(nullable: true)
  final String $t;
  String get text => clean(this.$t);

  @JsonKey(nullable: true)
  final String verse;

  @JsonKey(nullable: true)
  final String indent;

  Stanza(
      this.verse,
      this.indent,
      this.$t);
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
  return clean(item[r'$t']);
}

int _asIntAttribute(item){
  return int.parse(item[r'$t']);
}