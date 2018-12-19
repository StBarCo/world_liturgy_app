// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeSongBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongBooksContainer _$SongBooksContainerFromJson(Map<String, dynamic> json) {
  return SongBooksContainer(
      json['book'] == null ? null : _decodeSongBook(json['book']));
}

Map<String, dynamic> _$SongBooksContainerToJson(SongBooksContainer instance) =>
    <String, dynamic>{'book': instance.books};

SongBook _$SongBookFromJson(Map<String, dynamic> json) {
  return SongBook(
      json['language'] as String,
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['song'] == null ? null : _decodeSongs(json['song']));
}

Map<String, dynamic> _$SongBookToJson(SongBook instance) => <String, dynamic>{
      'language': instance.language,
      'id': instance.id,
      'title': instance.title,
      'song': instance.songs
    };

Song _$SongFromJson(Map<String, dynamic> json) {
  return Song(
      json['number'] == null ? null : _asAttribute(json['number']),
      json['title'] == null ? null : _asAttribute(json['title']),
      json['subtitle'] == null ? null : _asAttribute(json['subtitle']),
      json['verse'] == null ? null : _decodeVerse(json['verse']),
      json['refrain'] == null
          ? null
          : Refrain.fromJson(json['refrain'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'number': instance.number,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'verse': instance.verses,
      'refrain': instance.refrain
    };

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return Verse(json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

Map<String, dynamic> _$VerseToJson(Verse instance) =>
    <String, dynamic>{'stanza': instance.stanzas};

Refrain _$RefrainFromJson(Map<String, dynamic> json) {
  return Refrain(json['stanza'] == null ? null : _decodeStanza(json['stanza']),
      json['afterVerse'] == null ? null : _asInt(json['afterVerse']));
}

Map<String, dynamic> _$RefrainToJson(Refrain instance) => <String, dynamic>{
      'afterVerse': instance.afterVerse,
      'stanza': instance.stanzas
    };

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return Stanza(json[r'$t'] as String);
}

Map<String, dynamic> _$StanzaToJson(Stanza instance) =>
    <String, dynamic>{r'$t': instance.$t};
