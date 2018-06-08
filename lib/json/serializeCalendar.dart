import 'package:json_annotation/json_annotation.dart';

part 'serializeCalendar.g.dart';

@JsonSerializable()
class CalendarScaffold extends Object with _$CalendarScaffoldSerializerMixin {
  final String type;
  final Structure structure;

//  @JsonKey(name:'festivals_and_feasts')
//  final List<FestivalsAndFeasts> festivalsAndFeasts;

  CalendarScaffold(
      this.type,
      this.structure,
      );

  factory CalendarScaffold.fromJson(Map<String, dynamic> json) => _$CalendarScaffoldFromJson(json);
}

@JsonSerializable()
class Structure extends Object with _$StructureSerializerMixin {
  @JsonKey(name: 'christmas_cycle', fromJson: _decodeSeason )
  final List<Season> christmasCycle;
  @JsonKey(name: 'easter_cycle', fromJson: _decodeSeason )
  final List<Season> easterCycle;
  @JsonKey(name: 'ordinary_cycle', fromJson: _decodeSeason )
  final List<Season> ordinaryCycle;

  Structure(
      this.christmasCycle,
      this.easterCycle,
      this.ordinaryCycle,
      );
  factory Structure.fromJson(Map<String, dynamic> json) => _$StructureFromJson(json);

}

@JsonSerializable()
class Season extends Object with _$SeasonSerializerMixin {

  final String id;
  final String type;
  final String color;
  final int order;

  @JsonKey(name:'start_week')
  final int startWeek;

  @JsonKey(name:'end_week')
  final int endWeek;

  final int length;

  @JsonKey(name:'length_unit')
  final String lengthUnit;

  @JsonKey(name:'start_date')
  final Date startDate;

  @JsonKey(name:'end_date')
  final Date endDate;

  @JsonKey(name: 'flexible_at')
  final String flexibleAt;

  @JsonKey(name:'number_weeks_stuck_to_end')
  final int numberWeeksStucktoEnd;

  Season(
      this.id,
      this.type,
      this.color,
      this.order,
      this.startWeek,
      this.endWeek,
      this.length,
      this.lengthUnit,
      this.startDate,
      this.endDate,
      this.flexibleAt,
      this.numberWeeksStucktoEnd,
      );

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
}

@JsonSerializable()
class Date extends Object with _$DateSerializerMixin {
  final int month;
  final int day;

  Date(
      this.day,
      this.month,
  );

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json) ;
}


String clean(String s) => s?.replaceAll(new RegExp(r"\\r\\n+ *|\\"), '');


List<dynamic> _decodeSeason(itemOrList){
  List<dynamic> list = [];
  if (itemOrList == null){
    return null;
  }
  if (itemOrList.runtimeType.toString() == 'List<dynamic>'){
    list = itemOrList;
  }else{
    list.add(itemOrList);
  }

  return list.map((e) =>
  e == null ? null : new Season.fromJson(e as Map<String, dynamic>))
      ?.toList();
}