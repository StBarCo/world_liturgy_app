import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class PrayerBooksContainer extends Object with _$PrayerBooksContainerSerializerMixin {
  @JsonKey(name: 'prayer_book')
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

  @JsonKey(nullable: true, name: "title")
  final Title titleObject;
  String get title => clean(this.titleObject?.$t);

  @JsonKey(name: "service")
  final List<Service> services;

  PrayerBook(
      this.language,
      this.id,
      this.titleObject,
      this.services,
      );
  factory PrayerBook.fromJson(Map<String, dynamic> json) => _$PrayerBookFromJson(json);

}

@JsonSerializable()
class Service extends Object with _$ServiceSerializerMixin {

  final String id;

  @JsonKey(nullable: true, name: "title")
  final Title titleObject;
  String get title => clean(this.titleObject?.$t);

  @JsonKey(name: "section")
  final List<Section> sections;

  Service(
      this.id,
      this.titleObject,
      this.sections,
      );

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
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

  @JsonKey(nullable: true, name: "major_header")
  final MajorHeader majorHeaderObject;
  String get majorHeader => clean(this.majorHeaderObject?.$t);

  @JsonKey(nullable: true, name: "title")
  final Title titleObject;
  String get title => clean(this.titleObject?.$t);

  @JsonKey(nullable: true, name: "number")
  final Title numberObject;
  String get number => clean(this.numberObject?.$t);

  @JsonKey(nullable: true, name:"rubric")
  final Rubric rubricObject;
  String get rubric => clean(this.rubricObject?.$t);

  @JsonKey(name: "item", nullable: true)
  final List<Item> items;

  String get indexName{
    String string = '';
    if (this.number != null){
      string += this.number + ': ';
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
      this.majorHeaderObject,
      this.titleObject,
      this.numberObject,
      this.rubricObject,
      this.items,
      this.schedule,
      );
  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

}

@JsonSerializable()
class MajorHeader extends Object with _$MajorHeaderSerializerMixin {
  final String $t;
  String get text => clean(this.$t);

  MajorHeader(this.$t);
  factory MajorHeader.fromJson(Map<String, dynamic> json) => _$MajorHeaderFromJson(json) ;
}

@JsonSerializable()
class Title extends Object with _$TitleSerializerMixin {
  final String $t;
  String get text => clean(this.$t);

  Title(this.$t);
  factory Title.fromJson(Map<String, dynamic> json) => _$TitleFromJson(json) ;
}

@JsonSerializable()
class Rubric extends Object with _$RubricSerializerMixin {
  final String $t;
  String get text => clean(this.$t);

  final String link;

  Rubric(this.$t, this.link);
  factory Rubric.fromJson(Map<String, dynamic> json) => _$RubricFromJson(json);
}

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

  @JsonKey(nullable: true, name: "title")
  final Title titleObject;
  String get title => clean(this.titleObject?.$t);

  @JsonKey(nullable: true, name: "ref")
  final Title refObject;
  String get ref => clean(this.refObject?.$t);

  @JsonKey(nullable: true, name:'stanza')
  final List<Stanza> stanzas;

  Item(
      this.$t,
      this.who,
      this.type,
      this.includeGloria,
      this.titleObject,
      this.refObject,
      this.stanzas,
      );
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

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
