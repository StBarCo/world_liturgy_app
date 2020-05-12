// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializeCalendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarScaffold _$CalendarScaffoldFromJson(Map<String, dynamic> json) {
  return CalendarScaffold(
    _asAttribute(json['type']),
    _decodeSeason(json['structure']),
    _decodeHolyDays(json['holy_days']),
  );
}

HolyDays _$HolyDaysFromJson(Map<String, dynamic> json) {
  return HolyDays(
    (json['holy_day'] as List)
        ?.map((e) =>
            e == null ? null : HolyDay.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Season _$SeasonFromJson(Map<String, dynamic> json) {
  return Season(
    _asAttribute(json['id']),
    _asAttribute(json['type']),
    _asAttribute(json['color']),
    _asAttribute(json['week_order']),
    _asIntAttribute(json['start_week']),
    _asIntAttribute(json['end_week']),
    _asIntAttribute(json['length']),
    _asAttribute(json['length_unit']),
    json['start_date'] == null
        ? null
        : Date.fromJson(json['start_date'] as Map<String, dynamic>),
    json['end_date'] == null
        ? null
        : Date.fromJson(json['end_date'] as Map<String, dynamic>),
    _asAttribute(json['weeks_disappear_at']),
    _asIntAttribute(json['number_weeks_stuck_to_end']),
  );
}

HolyDay _$HolyDayFromJson(Map<String, dynamic> json) {
  return HolyDay(
    _asAttribute(json['id']),
    _asAttribute(json['type']),
    _asAttribute(json['color']),
    json['date'] == null
        ? null
        : Date.fromJson(json['date'] as Map<String, dynamic>),
    _asAttribute(json['optional_celebration_sunday']),
    _asAttribute(json['overlapsAnyDay']),
  );
}

Date _$DateFromJson(Map<String, dynamic> json) {
  return Date(
    _asIntAttribute(json['day']),
    _asIntAttribute(json['month']),
    _asIntAttribute(json['days_after']),
    _asIntAttribute(json['days_before']),
    _asAttribute(json['special']),
    _asAttribute(json['type']),
  )..exactDay = json['exactDay'] == null
      ? null
      : DateTime.parse(json['exactDay'] as String);
}
