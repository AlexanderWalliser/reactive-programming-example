import 'package:flutter_web_example/entities/change_typ.dart';
import 'package:json_annotation/json_annotation.dart';

part 'to_do_event.g.dart';

@JsonSerializable()
class ToDoEvent{
  ChangeType changeType;
  int id;
  String text;
  ToDoEvent();
  factory ToDoEvent.fromJson(Map<String, dynamic> json) => _$ToDoEventFromJson(json);
  Map<String, dynamic> toJson() => _$ToDoEventToJson(this);
}