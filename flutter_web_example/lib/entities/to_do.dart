import 'package:json_annotation/json_annotation.dart';

part 'to_do.g.dart';

@JsonSerializable()
class ToDo{
  int id;
  String text;

  ToDo({this.id,this.text});
  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);
  Map<String, dynamic> toJson() => _$ToDoToJson(this);
}