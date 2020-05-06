// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeSongBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongBooksContainer _$SongBooksContainerFromJson(Map<String, dynamic> json) {
  return SongBooksContainer(
    _decodeSongBook(json['book']),
  );
}

SongBook _$SongBookFromJson(Map<String, dynamic> json) {
  return SongBook(
    json['language'] as String,
    json['id'] as String,
    _asAttribute(json['title']),
    _decodeSongs(json['song']),
  );
}

Song _$SongFromJson(Map<String, dynamic> json) {
  return Song(
    _asAttribute(json['number']),
    _asAttribute(json['title']),
    _asAttribute(json['subtitle']),
    _decodeVerse(json['verse']),
    json['refrain'] == null
        ? null
        : Refrain.fromJson(json['refrain'] as Map<String, dynamic>),
  );
}

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return Verse(
    _decodeStanza(json['stanza']),
  );
}

Refrain _$RefrainFromJson(Map<String, dynamic> json) {
  return Refrain(
    _decodeStanza(json['stanza']),
    _asInt(json['afterVerse']),
  );
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return Stanza(
    json[r'$t'] as String,
  );
}
