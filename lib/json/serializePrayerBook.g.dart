// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializePrayerBook.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

PrayerBooksContainer _$PrayerBooksContainerFromJson(
        Map<String, dynamic> json) =>
    new PrayerBooksContainer((json['prayer_book'] as List)
        ?.map((e) => e == null
            ? null
            : new PrayerBook.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$PrayerBooksContainerSerializerMixin {
  List<PrayerBook> get prayerBooks;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'prayer_book': prayerBooks};
}

PrayerBook _$PrayerBookFromJson(Map<String, dynamic> json) => new PrayerBook(
    json['language'] as String,
    json['id'] as String,
    json['title'] == null
        ? null
        : new Title.fromJson(json['title'] as Map<String, dynamic>),
    (json['service'] as List)
        ?.map((e) =>
            e == null ? null : new Service.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$PrayerBookSerializerMixin {
  String get language;
  String get id;
  Title get titleObject;
  List<Service> get services;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'id': id,
        'title': titleObject,
        'service': services
      };
}

Service _$ServiceFromJson(Map<String, dynamic> json) => new Service(
    json['id'] as String,
    json['title'] == null
        ? null
        : new Title.fromJson(json['title'] as Map<String, dynamic>),
    (json['section'] as List)
        ?.map((e) =>
            e == null ? null : new Section.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$ServiceSerializerMixin {
  String get id;
  Title get titleObject;
  List<Section> get sections;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': titleObject, 'section': sections};
}

Section _$SectionFromJson(Map<String, dynamic> json) => new Section(
    json['type'] as String,
    json['visibility'] as String,
    json['fetchItemsFrom'] as String,
    json['major_header'] == null
        ? null
        : new MajorHeader.fromJson(
            json['major_header'] as Map<String, dynamic>),
    json['title'] == null
        ? null
        : new Title.fromJson(json['title'] as Map<String, dynamic>),
    json['number'] == null
        ? null
        : new Title.fromJson(json['number'] as Map<String, dynamic>),
    json['rubric'] == null
        ? null
        : new Rubric.fromJson(json['rubric'] as Map<String, dynamic>),
    (json['item'] as List)
        ?.map((e) =>
            e == null ? null : new Item.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['schedule'] as String);

abstract class _$SectionSerializerMixin {
  String get type;
  String get visibility;
  String get schedule;
  String get fetchItemsFrom;
  MajorHeader get majorHeaderObject;
  Title get titleObject;
  Title get numberObject;
  Rubric get rubricObject;
  List<Item> get items;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'visibility': visibility,
        'schedule': schedule,
        'fetchItemsFrom': fetchItemsFrom,
        'major_header': majorHeaderObject,
        'title': titleObject,
        'number': numberObject,
        'rubric': rubricObject,
        'item': items
      };
}

MajorHeader _$MajorHeaderFromJson(Map<String, dynamic> json) =>
    new MajorHeader(json[r'$t'] as String);

abstract class _$MajorHeaderSerializerMixin {
  String get $t;
  Map<String, dynamic> toJson() => <String, dynamic>{r'$t': $t};
}

Title _$TitleFromJson(Map<String, dynamic> json) =>
    new Title(json[r'$t'] as String);

abstract class _$TitleSerializerMixin {
  String get $t;
  Map<String, dynamic> toJson() => <String, dynamic>{r'$t': $t};
}

Rubric _$RubricFromJson(Map<String, dynamic> json) =>
    new Rubric(json[r'$t'] as String, json['link'] as String);

abstract class _$RubricSerializerMixin {
  String get $t;
  String get link;
  Map<String, dynamic> toJson() => <String, dynamic>{r'$t': $t, 'link': link};
}

Item _$ItemFromJson(Map<String, dynamic> json) => new Item(
    json[r'$t'] as String,
    json['who'] as String,
    json['type'] as String,
    json['includeGloria'] as String,
    json['title'] == null
        ? null
        : new Title.fromJson(json['title'] as Map<String, dynamic>),
    json['ref'] == null
        ? null
        : new Title.fromJson(json['ref'] as Map<String, dynamic>),
    (json['stanza'] as List)
        ?.map((e) =>
            e == null ? null : new Stanza.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$ItemSerializerMixin {
  String get $t;
  String get who;
  String get type;
  String get includeGloria;
  Title get titleObject;
  Title get refObject;
  List<Stanza> get stanzas;
  Map<String, dynamic> toJson() => <String, dynamic>{
        r'$t': $t,
        'who': who,
        'type': type,
        'includeGloria': includeGloria,
        'title': titleObject,
        'ref': refObject,
        'stanza': stanzas
      };
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) => new Stanza(
    json['verse'] as String, json['indent'] as String, json[r'$t'] as String);

abstract class _$StanzaSerializerMixin {
  String get $t;
  String get verse;
  String get indent;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{r'$t': $t, 'verse': verse, 'indent': indent};
}
