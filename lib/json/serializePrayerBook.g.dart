// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializePrayerBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerBooksContainer _$PrayerBooksContainerFromJson(Map<String, dynamic> json) {
  return new PrayerBooksContainer(json['prayer_book'] == null
      ? null
      : _decodePrayerBookorService(json['prayer_book']));
}

abstract class _$PrayerBooksContainerSerializerMixin {
  List<PrayerBook> get prayerBooks;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'prayer_book': prayerBooks};
}

PrayerBook _$PrayerBookFromJson(Map<String, dynamic> json) {
  return new PrayerBook(
      json['language'] as String,
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['service'] == null
          ? null
          : _decodePrayerBookorService(json['service']));
}

abstract class _$PrayerBookSerializerMixin {
  String get language;
  String get id;
  String get title;
  List<Service> get services;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'id': id,
        'title': title,
        'service': services
      };
}

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return new Service(
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['section'] == null ? null : _decodeSection(json['section']));
}

abstract class _$ServiceSerializerMixin {
  String get id;
  String get title;
  List<Section> get sections;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'section': sections};
}

Section _$SectionFromJson(Map<String, dynamic> json) {
  return new Section(
      json['type'] as String,
      json['visibility'] as String,
      json['fetchItemsFrom'] as String,
      json['major_header'] == null ? null : _asAttribute(json['major_header']),
      json['title'] == null ? null : _asAttribute(json['title']),
      json['number'] == null ? null : _asIntAttribute(json['number']),
      json['rubric'] == null ? null : _asAttribute(json['rubric']),
      json['item'] == null ? null : _decodeItem(json['item']),
      json['collect'] == null ? null : _decodeCollect(json['collect']),
      json['schedule'] as String);
}

abstract class _$SectionSerializerMixin {
  String get type;
  String get visibility;
  String get schedule;
  String get fetchItemsFrom;
  String get majorHeader;
  String get title;
  int get number;
  String get rubric;
  List<Item> get items;
  List<Collect> get collects;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'visibility': visibility,
        'schedule': schedule,
        'fetchItemsFrom': fetchItemsFrom,
        'major_header': majorHeader,
        'title': title,
        'number': number,
        'rubric': rubric,
        'item': items,
        'collect': collects
      };
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return new Item(
      json[r'$t'] as String,
      json['who'] as String,
      json['type'] as String,
      json['includeGloria'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['other'] as String,
      json['ref'] == null ? null : _asAttribute(json['ref']),
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

abstract class _$ItemSerializerMixin {
  String get $t;
  String get who;
  String get type;
  String get includeGloria;
  String get title;
  String get ref;
  String get other;
  List<Stanza> get stanzas;
  Map<String, dynamic> toJson() => <String, dynamic>{
        r'$t': $t,
        'who': who,
        'type': type,
        'includeGloria': includeGloria,
        'title': title,
        'ref': ref,
        'other': other,
        'stanza': stanzas
      };
}

Collect _$CollectFromJson(Map<String, dynamic> json) {
  return new Collect(
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['subtitle'] == null ? null : _asAttribute(json['subtitle']),
      json['ref'] == null ? null : _asAttribute(json['ref']),
      json['color'] == null ? null : _asAttribute(json['color']),
      json['date'] == null ? null : _asAttribute(json['date']),
      json['type'] == null ? null : _asAttribute(json['type']),
      json['collect_rubric'] == null
          ? null
          : _asAttribute(json['collect_rubric']),
      json['post_communion_rubric'] == null
          ? null
          : _asAttribute(json['post_communion_rubric']),
      json['collect'] == null ? null : _decodeCollectPrayers(json['collect']),
      json['post_communion_prayer'] == null
          ? null
          : _decodePostCommunionPrayers(json['post_communion_prayer']));
}

abstract class _$CollectSerializerMixin {
  String get id;
  String get title;
  String get subtitle;
  String get ref;
  String get color;
  String get date;
  String get type;
  String get collectRubric;
  String get postCommunionRubric;
  List<CollectPrayer> get collectPrayers;
  List<PostCommunionPrayer> get postCommunionPrayers;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'ref': ref,
        'color': color,
        'date': date,
        'type': type,
        'collect_rubric': collectRubric,
        'post_communion_rubric': postCommunionRubric,
        'collect': collectPrayers,
        'post_communion_prayer': postCommunionPrayers
      };
}

CollectPrayer _$CollectPrayerFromJson(Map<String, dynamic> json) {
  return new CollectPrayer(json[r'$t'] as String, json['type'] as String,
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

abstract class _$CollectPrayerSerializerMixin {
  String get $t;
  String get type;
  List<Stanza> get stanzas;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{r'$t': $t, 'type': type, 'stanza': stanzas};
}

PostCommunionPrayer _$PostCommunionPrayerFromJson(Map<String, dynamic> json) {
  return new PostCommunionPrayer(json[r'$t'] as String, json['type'] as String,
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

abstract class _$PostCommunionPrayerSerializerMixin {
  String get $t;
  String get type;
  List<Stanza> get stanzas;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{r'$t': $t, 'type': type, 'stanza': stanzas};
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return new Stanza(json['verse'] as String, json['indent'] as String,
      json[r'$t'] as String, json['type'] as String);
}

abstract class _$StanzaSerializerMixin {
  String get $t;
  String get verse;
  String get indent;
  String get type;
  Map<String, dynamic> toJson() => <String, dynamic>{
        r'$t': $t,
        'verse': verse,
        'indent': indent,
        'type': type
      };
}
