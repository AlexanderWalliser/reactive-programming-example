// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDoEvent _$ToDoEventFromJson(Map<String, dynamic> json) {
  return ToDoEvent()
    ..changeTyp = _$enumDecodeNullable(_$ChangeTypEnumMap, json['changeTyp'])
    ..id = json['id'] as int
    ..text = json['text'] as String;
}

Map<String, dynamic> _$ToDoEventToJson(ToDoEvent instance) => <String, dynamic>{
      'changeTyp': _$ChangeTypEnumMap[instance.changeTyp],
      'id': instance.id,
      'text': instance.text,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ChangeTypEnumMap = {
  ChangeTyp.CREATE: 'CREATE',
  ChangeTyp.UPDATE: 'UPDATE',
  ChangeTyp.DELETE: 'DELETE',
};
