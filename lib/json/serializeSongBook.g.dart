// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeSongBook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongBooksContainer _$SongBooksContainerFromJson(Map<String, dynamic> json) {
  return new SongBooksContainer(
      json['book'] == null ? null : _decodeSongBook(json['book']));
}

abstract class _$SongBooksContainerSerializerMixin {
  List<SongBook> get books;
  Map<String, dynamic> toJson() => <String, dynamic>{'book': books};
}

SongBook _$SongBookFromJson(Map<String, dynamic> json) {
  return new SongBook(
      json['language'] as String,
      json['id'] as String,
      json['title'] == null ? null : _asAttribute(json['title']),
      json['song'] == null ? null : _decodeSongs(json['song']));
}

abstract class _$SongBookSerializerMixin {
  String get language;
  String get id;
  String get title;
  List<Song> get songs;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'id': id,
        'title': title,
        'song': songs
      };
}

Song _$SongFromJson(Map<String, dynamic> json) {
  return new Song(
      json['number'] == null ? null : _asAttribute(json['number']),
      json['title'] == null ? null : _asAttribute(json['title']),
      json['subtitle'] == null ? null : _asAttribute(json['subtitle']),
      json['verse'] == null ? null : _decodeVerse(json['verse']),
      json['refrain'] == null
          ? null
          : new Refrain.fromJson(json['refrain'] as Map<String, dynamic>));
}

abstract class _$SongSerializerMixin {
  String get number;
  String get title;
  String get subtitle;
  List<Verse> get verses;
  Refrain get refrain;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'number': number,
        'title': title,
        'subtitle': subtitle,
        'verse': verses,
        'refrain': refrain
      };
}

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return new Verse(
      json['stanza'] == null ? null : _decodeStanza(json['stanza']));
}

abstract class _$VerseSerializerMixin {
  List<Stanza> get stanzas;
  Map<String, dynamic> toJson() => <String, dynamic>{'stanza': stanzas};
}

Refrain _$RefrainFromJson(Map<String, dynamic> json) {
  return new Refrain(
      json['stanza'] == null ? null : _decodeStanza(json['stanza']),
      json['afterVerse'] == null ? null : _asInt(json['afterVerse']));
}

abstract class _$RefrainSerializerMixin {
  int get afterVerse;
  List<Stanza> get stanzas;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'afterVerse': afterVerse, 'stanza': stanzas};
}

Stanza _$StanzaFromJson(Map<String, dynamic> json) {
  return new Stanza(json[r'$t'] as String);
}

abstract class _$StanzaSerializerMixin {
  String get $t;
  Map<String, dynamic> toJson() => <String, dynamic>{r'$t': $t};
}
