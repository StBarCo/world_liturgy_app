// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeCalendar.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

CalendarScaffold _$CalendarScaffoldFromJson(Map<String, dynamic> json) =>
    new CalendarScaffold(
        json['type'] == null ? null : _asAttribute(json['type']),
        json['structure'] == null ? null : _decodeSeason(json['structure']),
        json['holy_days'] == null ? null : _decodeHolyDays(json['holy_days']));

abstract class _$CalendarScaffoldSerializerMixin {
  String get type;
  List<Season> get structure;
  List<HolyDay> get holyDays;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'structure': structure,
        'holy_days': holyDays
      };
}

HolyDays _$HolyDaysFromJson(Map<String, dynamic> json) =>
    new HolyDays((json['holy_day'] as List)
        ?.map((e) =>
            e == null ? null : new HolyDay.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$HolyDaysSerializerMixin {
  List<HolyDay> get holyDay;
  Map<String, dynamic> toJson() => <String, dynamic>{'holy_day': holyDay};
}

Season _$SeasonFromJson(Map<String, dynamic> json) => new Season(
    json['id'] == null ? null : _asAttribute(json['id']),
    json['type'] == null ? null : _asAttribute(json['type']),
    json['color'] == null ? null : _asAttribute(json['color']),
    json['week_order'] == null ? null : _asAttribute(json['week_order']),
    json['start_week'] == null ? null : _asIntAttribute(json['start_week']),
    json['end_week'] == null ? null : _asIntAttribute(json['end_week']),
    json['length'] == null ? null : _asIntAttribute(json['length']),
    json['length_unit'] == null ? null : _asAttribute(json['length_unit']),
    json['start_date'] == null
        ? null
        : new Date.fromJson(json['start_date'] as Map<String, dynamic>),
    json['end_date'] == null
        ? null
        : new Date.fromJson(json['end_date'] as Map<String, dynamic>),
    json['weeks_disappear_at'] == null
        ? null
        : _asAttribute(json['weeks_disappear_at']),
    json['number_weeks_stuck_to_end'] == null
        ? null
        : _asIntAttribute(json['number_weeks_stuck_to_end']));

abstract class _$SeasonSerializerMixin {
  String get id;
  String get type;
  String get color;
  String get weekOrder;
  int get startWeek;
  int get endWeek;
  int get length;
  String get lengthUnit;
  Date get startDate;
  Date get endDate;
  String get weeksDisappearAt;
  int get numberWeeksStucktoEnd;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'color': color,
        'week_order': weekOrder,
        'start_week': startWeek,
        'end_week': endWeek,
        'length': length,
        'length_unit': lengthUnit,
        'start_date': startDate,
        'end_date': endDate,
        'weeks_disappear_at': weeksDisappearAt,
        'number_weeks_stuck_to_end': numberWeeksStucktoEnd
      };
}

HolyDay _$HolyDayFromJson(Map<String, dynamic> json) => new HolyDay(
    json['id'] == null ? null : _asAttribute(json['id']),
    json['type'] == null ? null : _asAttribute(json['type']),
    json['color'] == null ? null : _asAttribute(json['color']),
    json['date'] == null
        ? null
        : new Date.fromJson(json['date'] as Map<String, dynamic>),
    json['length'] == null ? null : _asIntAttribute(json['length']),
    json['length_unit'] == null ? null : _asAttribute(json['length_unit']),
    json['optional_celebration_sunday'] == null
        ? null
        : _asAttribute(json['optional_celebration_sunday']));

abstract class _$HolyDaySerializerMixin {
  String get id;
  String get type;
  String get color;
  int get length;
  String get lengthUnit;
  Date get date;
  String get optionalCelebrationSunday;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'color': color,
        'length': length,
        'length_unit': lengthUnit,
        'date': date,
        'optional_celebration_sunday': optionalCelebrationSunday
      };
}

Date _$DateFromJson(Map<String, dynamic> json) => new Date(
    json['day'] == null ? null : _asIntAttribute(json['day']),
    json['month'] == null ? null : _asIntAttribute(json['month']),
    json['days_after'] == null ? null : _asIntAttribute(json['days_after']),
    json['days_before'] == null ? null : _asIntAttribute(json['days_before']),
    json['special'] == null ? null : _asAttribute(json['special']),
    json['type'] == null ? null : _asAttribute(json['type']));

abstract class _$DateSerializerMixin {
  int get month;
  int get day;
  int get daysBefore;
  int get daysAfter;
  String get special;
  String get type;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'month': month,
        'day': day,
        'days_before': daysBefore,
        'days_after': daysAfter,
        'special': special,
        'type': type
      };
}
