// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeCalendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarScaffold _$CalendarScaffoldFromJson(Map<String, dynamic> json) {
  return CalendarScaffold(
      json['type'] == null ? null : _asAttribute(json['type']),
      json['structure'] == null ? null : _decodeSeason(json['structure']),
      json['holy_days'] == null ? null : _decodeHolyDays(json['holy_days']));
}

Map<String, dynamic> _$CalendarScaffoldToJson(CalendarScaffold instance) =>
    <String, dynamic>{
      'type': instance.type,
      'structure': instance.structure,
      'holy_days': instance.holyDays
    };

HolyDays _$HolyDaysFromJson(Map<String, dynamic> json) {
  return HolyDays((json['holy_day'] as List)
      ?.map(
          (e) => e == null ? null : HolyDay.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$HolyDaysToJson(HolyDays instance) =>
    <String, dynamic>{'holy_day': instance.holyDay};

Season _$SeasonFromJson(Map<String, dynamic> json) {
  return Season(
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
          : Date.fromJson(json['start_date'] as Map<String, dynamic>),
      json['end_date'] == null
          ? null
          : Date.fromJson(json['end_date'] as Map<String, dynamic>),
      json['weeks_disappear_at'] == null
          ? null
          : _asAttribute(json['weeks_disappear_at']),
      json['number_weeks_stuck_to_end'] == null
          ? null
          : _asIntAttribute(json['number_weeks_stuck_to_end']));
}

Map<String, dynamic> _$SeasonToJson(Season instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'color': instance.color,
      'week_order': instance.weekOrder,
      'start_week': instance.startWeek,
      'end_week': instance.endWeek,
      'length': instance.length,
      'length_unit': instance.lengthUnit,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'weeks_disappear_at': instance.weeksDisappearAt,
      'number_weeks_stuck_to_end': instance.numberWeeksStucktoEnd
    };

HolyDay _$HolyDayFromJson(Map<String, dynamic> json) {
  return HolyDay(
      json['id'] == null ? null : _asAttribute(json['id']),
      json['type'] == null ? null : _asAttribute(json['type']),
      json['color'] == null ? null : _asAttribute(json['color']),
      json['date'] == null
          ? null
          : Date.fromJson(json['date'] as Map<String, dynamic>),
      json['length'] == null ? null : _asIntAttribute(json['length']),
      json['length_unit'] == null ? null : _asAttribute(json['length_unit']),
      json['optional_celebration_sunday'] == null
          ? null
          : _asAttribute(json['optional_celebration_sunday']));
}

Map<String, dynamic> _$HolyDayToJson(HolyDay instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'color': instance.color,
      'length': instance.length,
      'length_unit': instance.lengthUnit,
      'date': instance.date,
      'optional_celebration_sunday': instance.optionalCelebrationSunday
    };

Date _$DateFromJson(Map<String, dynamic> json) {
  return Date(
      json['day'] == null ? null : _asIntAttribute(json['day']),
      json['month'] == null ? null : _asIntAttribute(json['month']),
      json['days_after'] == null ? null : _asIntAttribute(json['days_after']),
      json['days_before'] == null ? null : _asIntAttribute(json['days_before']),
      json['special'] == null ? null : _asAttribute(json['special']),
      json['type'] == null ? null : _asAttribute(json['type']));
}

Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
      'month': instance.month,
      'day': instance.day,
      'days_before': instance.daysBefore,
      'days_after': instance.daysAfter,
      'special': instance.special,
      'type': instance.type
    };
