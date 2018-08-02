import 'package:json_annotation/json_annotation.dart';

part 'serializeSongBook.g.dart';

@JsonSerializable()
class SongBooksContainer extends Object with _$SongBooksContainerSerializerMixin {
  @JsonKey(fromJson: _decodeSongBook, name:'book')
  final List<SongBook> books;

  SongBooksContainer(
      this.books,
      );

  factory SongBooksContainer.fromJson(Map<String, dynamic> json) => _$SongBooksContainerFromJson(json);
}

@JsonSerializable()
class SongBook extends Object with _$SongBookSerializerMixin {
  final String language;
  final String id;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(name: "song", fromJson: _decodeSongs)
  final List<Song> songs;

  SongBook(
      this.language,
      this.id,
      this.title,
      this.songs,
      );
  factory SongBook.fromJson(Map<String, dynamic> json) => _$SongBookFromJson(json);
}

@JsonSerializable()
class Song extends Object with _$SongSerializerMixin {

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String number;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String title;

  @JsonKey(nullable: true, fromJson: _asAttribute)
  final String subtitle;

  @JsonKey(name: "verse", fromJson: _decodeVerse)
  final List<Verse> verses;

  @JsonKey(nullable: true,)
  final Refrain refrain;

  Song(
      this.number,
      this.title,
      this.subtitle,
      this.verses,
      this.refrain,
      );

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

}

@JsonSerializable()
class Verse extends Object with _$VerseSerializerMixin {

  @JsonKey(name: "stanza", nullable: true, fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  Verse(
      this.stanzas,
      );

  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);

}

@JsonSerializable()
class Refrain extends Object with _$RefrainSerializerMixin {

  @JsonKey(name: "stanza", nullable: true, fromJson: _decodeStanza)
  final List<Stanza> stanzas;

  Refrain(
      this.stanzas,
      );

  factory Refrain.fromJson(Map<String, dynamic> json) => _$RefrainFromJson(json);
}



@JsonSerializable()
class Stanza extends Object with _$StanzaSerializerMixin {
  final String $t;
  String get text => clean(this.$t);

  Stanza(this.$t);

  factory Stanza.fromJson(Map<String, dynamic> json) => _$StanzaFromJson(json);
}


String clean(String s) => s?.replaceAll(new RegExp(r"\\r\\n+ *|\\"), '');

_decodeSongBook(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];

  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new SongBook.fromJson(e as Map<String, dynamic>))
      ?.toList();

}

_decodeSongs(itemOrList){
  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Song.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodeVerse(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Verse.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

_decodeStanza(itemOrList){

  if (itemOrList == null){
    return null;
  }

  List<dynamic> list = [];
  if (['List<dynamic>', '_GrowableList<dynamic>'].contains(itemOrList.runtimeType.toString())){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Stanza.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

String _asAttribute(item){
  try {
    return clean(item[r'$t']);
  } catch (e){
    print(e);
    print("Error serializing PrayerBooks in _asAttribute function");
    print(item.toString());
    return null;
  }
}
