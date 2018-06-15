import 'package:json_annotation/json_annotation.dart';

part 'serializeCalendar.g.dart';

@JsonSerializable()
class CalendarScaffold extends Object with _$CalendarScaffoldSerializerMixin {
  @JsonKey(fromJson: _asAttribute)
  final String type;
  @JsonKey( fromJson: _decodeSeason)
  final List<Season> structure;

  @JsonKey(name:'holy_days', fromJson: _decodeHolyDays)
  final List<HolyDay> holyDays;
//  @JsonKey(name:'festivals_and_feasts')
//  final List<FestivalsAndFeasts> festivalsAndFeasts;

  CalendarScaffold(
      this.type,
      this.structure,
      this.holyDays,
      );

  factory CalendarScaffold.fromJson(Map<String, dynamic> json) => _$CalendarScaffoldFromJson(json);
}

//@JsonSerializable()
//class Structure extends Object with _$StructureSerializerMixin {
//  @JsonKey(name:'season', fromJson: _decodeSeason)
//  final List<Season> seasons;
//
//  Structure(this.seasons);
//
//  factory Structure.fromJson(Map<String, dynamic> json) => _$StructureFromJson(json);
//}

@JsonSerializable()
class HolyDays extends Object with _$HolyDaysSerializerMixin {
  @JsonKey(name:'holy_day')
  final List<HolyDay> holyDay;

  HolyDays(this.holyDay);

  factory HolyDays.fromJson(Map<String, dynamic> json) => _$HolyDaysFromJson(json);
}

@JsonSerializable()
class Season extends Object with _$SeasonSerializerMixin {

  @JsonKey(fromJson: _asAttribute)
  final String id ;
  @JsonKey(fromJson: _asAttribute)
  final String type;
  @JsonKey(fromJson: _asAttribute)
  final String color;
  @JsonKey(name:'week_order',fromJson: _asAttribute)
  final String weekOrder;

  @JsonKey(name:'start_week', fromJson: _asIntAttribute)
  final int startWeek;

  @JsonKey(name:'end_week', fromJson: _asIntAttribute)
  final int endWeek;

  @JsonKey(fromJson: _asIntAttribute)
  final int length;

  @JsonKey(name:'length_unit', fromJson: _asAttribute )
  final String lengthUnit;

  @JsonKey(name:'start_date')
  final Date startDate;

  @JsonKey(name:'end_date')
  final Date endDate;

  @JsonKey(name: 'weeks_disappear_at', fromJson: _asAttribute)
  final String weeksDisappearAt;

  @JsonKey(name:'number_weeks_stuck_to_end', fromJson: _asIntAttribute)
  final int numberWeeksStucktoEnd;

  Season(
      this.id,
      this.type,
      this.color,
      this.weekOrder,
      this.startWeek,
      this.endWeek,
      this.length,
      this.lengthUnit,
      this.startDate,
      this.endDate,
      this.weeksDisappearAt,
      this.numberWeeksStucktoEnd,
      );

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);




}

@JsonSerializable()
class HolyDay extends Object with _$HolyDaySerializerMixin {

  @JsonKey(fromJson: _asAttribute)
  final String id ;
  @JsonKey(fromJson: _asAttribute)
  final String type;
  @JsonKey(fromJson: _asAttribute)
  final String color;

  @JsonKey(fromJson: _asIntAttribute)
  final int length;

  @JsonKey(name:'length_unit', fromJson: _asAttribute )
  final String lengthUnit;

  @JsonKey(name:'date')
  final Date date;

  @JsonKey(name:'optional_celebration_sunday', fromJson: _asAttribute)
  final String optionalCelebrationSunday;

  HolyDay(
      this.id,
      this.type,
      this.color,
      this.date,
      this.length,
      this.lengthUnit,
      this.optionalCelebrationSunday
      );

  factory HolyDay.fromJson(Map<String, dynamic> json) => _$HolyDayFromJson(json);
}

@JsonSerializable()
class Date extends Object with _$DateSerializerMixin {
  @JsonKey(fromJson: _asIntAttribute)
  final int month;
  @JsonKey(fromJson: _asIntAttribute)
  final int day;

  @JsonKey(name: 'days_before', fromJson: _asIntAttribute)
  final int daysBefore;

  @JsonKey(name: 'days_after', fromJson: _asIntAttribute)
  final int daysAfter;

  @JsonKey(fromJson: _asAttribute)
  final String special;

  @JsonKey(fromJson: _asAttribute)
  final String type;

  Date(
      this.day,
      this.month,
      this.daysAfter,
      this.daysBefore,
      this.special,
      this.type,
  );

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json) ;
}


String clean(String s) => s?.replaceAll(new RegExp(r"\\r\\n+ *|\\"), '');


List<dynamic> _decodeSeason(itemOrList){
  List<dynamic> list = [];
  if (itemOrList == null){
    return null;
  }
  if (itemOrList.runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>'){
    list = itemOrList['season'];
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Season.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

List<dynamic> _decodeHolyDays(itemOrList){
  List<dynamic> list = [];
  if (itemOrList == null){
    return null;
  }
  if (itemOrList.runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>'){
    list = itemOrList['holy_day'];
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new HolyDay.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

String _asAttribute(item){
  return item[r'$t'];
}

int _asIntAttribute(item){
  return int.parse(item[r'$t']);
}