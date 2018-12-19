// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeSongBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongBooksContainer _$SongBooksContainerFromJson(Map<String, dynamic> json) {
  return SongBooksContainer(
      json['book'] == null ? null : _decodeSongBook(json['book']));
}

SongBook _$SongBookFromJson(Map<String, dynamic> json) {
  return SongBook(
      json['language'] as String,
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['song'] == null ? null : _decodeSongs(json['song']));
}

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

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return Verse(json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

Refrain _$RefrainFromJson(Map<String, dynamic> json) {
  return Refrain(json['stanza'] == null ? null : _decodeStanza(json['stanza']),
      json['afterVerse'] == null ? null : _asInt(json['afterVerse']));
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return Stanza(json[r'$t'] as String);
}
