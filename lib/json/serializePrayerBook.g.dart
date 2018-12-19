// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializePrayerBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerBooksContainer _$PrayerBooksContainerFromJson(Map<String, dynamic> json) {
  return PrayerBooksContainer(json['prayer_book'] == null
      ? null
      : _decodePrayerBookorService(json['prayer_book']));
}

Map<String, dynamic> _$PrayerBooksContainerToJson(
        PrayerBooksContainer instance) =>
    <String, dynamic>{'prayer_book': instance.prayerBooks};

PrayerBook _$PrayerBookFromJson(Map<String, dynamic> json) {
  return PrayerBook(
      json['language'] as String,
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['service'] == null
          ? null
          : _decodePrayerBookorService(json['service']));
}

Map<String, dynamic> _$PrayerBookToJson(PrayerBook instance) =>
    <String, dynamic>{
      'language': instance.language,
      'id': instance.id,
      'title': instance.title,
      'service': instance.services
    };

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return Service(
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['titleShort'] == null ? null : _asAttribute(json['titleShort']),
      json['section'] == null ? null : _decodeSection(json['section']));
}

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'section': instance.sections,
      'titleShort': instance.titleShort
    };

Section _$SectionFromJson(Map<String, dynamic> json) {
  return Section(
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

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'type': instance.type,
      'visibility': instance.visibility,
      'schedule': instance.schedule,
      'fetchItemsFrom': instance.fetchItemsFrom,
      'major_header': instance.majorHeader,
      'title': instance.title,
      'number': instance.number,
      'rubric': instance.rubric,
      'item': instance.items,
      'collect': instance.collects
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      json[r'$t'] as String,
      json['who'] as String,
      json['type'] as String,
      json['includeGloria'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['other'] as String,
      json['ref'] == null ? null : _asAttribute(json['ref']),
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      r'$t': instance.$t,
      'who': instance.who,
      'type': instance.type,
      'includeGloria': instance.includeGloria,
      'title': instance.title,
      'ref': instance.ref,
      'other': instance.other,
      'stanza': instance.stanzas
    };

Collect _$CollectFromJson(Map<String, dynamic> json) {
  return Collect(
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

Map<String, dynamic> _$CollectToJson(Collect instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'ref': instance.ref,
      'color': instance.color,
      'date': instance.date,
      'type': instance.type,
      'collect_rubric': instance.collectRubric,
      'post_communion_rubric': instance.postCommunionRubric,
      'collect': instance.collectPrayers,
      'post_communion_prayer': instance.postCommunionPrayers
    };

CollectPrayer _$CollectPrayerFromJson(Map<String, dynamic> json) {
  return CollectPrayer(json[r'$t'] as String, json['type'] as String,
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

Map<String, dynamic> _$CollectPrayerToJson(CollectPrayer instance) =>
    <String, dynamic>{
      r'$t': instance.$t,
      'type': instance.type,
      'stanza': instance.stanzas
    };

PostCommunionPrayer _$PostCommunionPrayerFromJson(Map<String, dynamic> json) {
  return PostCommunionPrayer(json[r'$t'] as String, json['type'] as String,
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

Map<String, dynamic> _$PostCommunionPrayerToJson(
        PostCommunionPrayer instance) =>
    <String, dynamic>{
      r'$t': instance.$t,
      'type': instance.type,
      'stanza': instance.stanzas
    };

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return Stanza(json['verse'] as String, json['indent'] as String,
      json[r'$t'] as String, json['type'] as String);
}

Map<String, dynamic> _$StanzaToJson(Stanza instance) => <String, dynamic>{
      r'$t': instance.$t,
      'verse': instance.verse,
      'indent': instance.indent,
      'type': instance.type
    };
