// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializePrayerBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerBooksContainer _$PrayerBooksContainerFromJson(Map<String, dynamic> json) {
  return PrayerBooksContainer(
    _decodePrayerBookorService(json['prayer_book']),
  );
}

PrayerBook _$PrayerBookFromJson(Map<String, dynamic> json) {
  return PrayerBook(
    json['language'] as String,
    json['id'] as String,
    _asAttribute(json['title']),
    _decodePrayerBookorService(json['service']),
  );
}

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return Service(
    json['id'] as String,
    _asAttribute(json['title']),
    _asAttribute(json['titleShort']),
    _decodeSection(json['section']),
  );
}

Section _$SectionFromJson(Map<String, dynamic> json) {
  return Section(
    json['type'] as String,
    json['visibility'] as String,
    json['fetchItemsFrom'] as String,
    _asAttribute(json['major_header']),
    _asAttribute(json['title']),
    _asIntAttribute(json['number']),
    _asAttribute(json['rubric']),
    _decodeItem(json['item']),
    _decodeCollect(json['collect']),
    json['schedule'] as String,
  );
}

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json[r'$t'] as String,
    json['who'] as String,
    json['type'] as String,
    json['includeGloria'] as String,
    _asAttribute(json['title']),
    json['other'] as String,
    _asAttribute(json['ref']),
    _decodeStanza(json['stanza']),
  );
}

Collect _$CollectFromJson(Map<String, dynamic> json) {
  return Collect(
    json['id'] as String,
    json['altId'] as String,
    _asAttribute(json['title']),
    _asAttribute(json['subtitle']),
    _asAttribute(json['ref']),
    _asAttribute(json['color']),
    _asAttribute(json['date']),
    _asAttribute(json['type']),
    _asAttribute(json['collect_rubric']),
    _asAttribute(json['post_communion_rubric']),
    _decodeCollectPrayers(json['collect']),
    _decodePostCommunionPrayers(json['post_communion_prayer']),
  );
}

CollectPrayer _$CollectPrayerFromJson(Map<String, dynamic> json) {
  return CollectPrayer(
    json[r'$t'] as String,
    json['type'] as String,
    _decodeStanza(json['stanza']),
  );
}

PostCommunionPrayer _$PostCommunionPrayerFromJson(Map<String, dynamic> json) {
  return PostCommunionPrayer(
    json[r'$t'] as String,
    json['type'] as String,
    _decodeStanza(json['stanza']),
  );
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return Stanza(
    json['verse'] as String,
    json['indent'] as String,
    json[r'$t'] as String,
    json['type'] as String,
  );
}
