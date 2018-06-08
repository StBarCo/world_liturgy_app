// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeCalendar.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

CalendarScaffold _$CalendarScaffoldFromJson(Map<String, dynamic> json) =>
    new CalendarScaffold(
        json['type'] as String,
        json['structure'] == null
            ? null
            : new Structure.fromJson(
                json['structure'] as Map<String, dynamic>));

abstract class _$CalendarScaffoldSerializerMixin {
  String get type;
  Structure get structure;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'type': type, 'structure': structure};
}

Structure _$StructureFromJson(Map<String, dynamic> json) => new Structure(
    json['christmas_cycle'] == null
        ? null
        : _decodeSeason(json['christmas_cycle']),
    json['easter_cycle'] == null ? null : _decodeSeason(json['easter_cycle']),
    json['ordinary_cycle'] == null
        ? null
        : _decodeSeason(json['ordinary_cycle']));

abstract class _$StructureSerializerMixin {
  List<Season> get christmasCycle;
  List<Season> get easterCycle;
  List<Season> get ordinaryCycle;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'christmas_cycle': christmasCycle,
        'easter_cycle': easterCycle,
        'ordinary_cycle': ordinaryCycle
      };
}

Season _$SeasonFromJson(Map<String, dynamic> json) => new Season(
    json['id'] as String,
    json['type'] as String,
    json['color'] as String,
    json['order'] as int,
    json['start_week'] as int,
    json['end_week'] as int,
    json['length'] as int,
    json['length_unit'] as String,
    json['start_date'] == null
        ? null
        : new Date.fromJson(json['start_date'] as Map<String, dynamic>),
    json['end_date'] == null
        ? null
        : new Date.fromJson(json['end_date'] as Map<String, dynamic>),
    json['flexible_at'] as String,
    json['number_weeks_stuck_to_end'] as int);

abstract class _$SeasonSerializerMixin {
  String get id;
  String get type;
  String get color;
  int get order;
  int get startWeek;
  int get endWeek;
  int get length;
  String get lengthUnit;
  Date get startDate;
  Date get endDate;
  String get flexibleAt;
  int get numberWeeksStucktoEnd;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'color': color,
        'order': order,
        'start_week': startWeek,
        'end_week': endWeek,
        'length': length,
        'length_unit': lengthUnit,
        'start_date': startDate,
        'end_date': endDate,
        'flexible_at': flexibleAt,
        'number_weeks_stuck_to_end': numberWeeksStucktoEnd
      };
}

Date _$DateFromJson(Map<String, dynamic> json) =>
    new Date(json['day'] as int, json['month'] as int);

abstract class _$DateSerializerMixin {
  int get month;
  int get day;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'month': month, 'day': day};
}
