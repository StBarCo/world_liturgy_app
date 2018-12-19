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

PrayerBook _$PrayerBookFromJson(Map<String, dynamic> json) {
  return PrayerBook(
      json['language'] as String,
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['service'] == null
          ? null
          : _decodePrayerBookorService(json['service']));
}

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return Service(
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['titleShort'] == null ? null : _asAttribute(json['titleShort']),
      json['section'] == null ? null : _decodeSection(json['section']));
}

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

CollectPrayer _$CollectPrayerFromJson(Map<String, dynamic> json) {
  return CollectPrayer(json[r'$t'] as String, json['type'] as String,
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

PostCommunionPrayer _$PostCommunionPrayerFromJson(Map<String, dynamic> json) {
  return PostCommunionPrayer(json[r'$t'] as String, json['type'] as String,
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return Stanza(json['verse'] as String, json['indent'] as String,
      json[r'$t'] as String, json['type'] as String);
}
