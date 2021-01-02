import 'package:json_annotation/json_annotation.dart';

enum ChangeTyp {
  @JsonValue("CREATE")
  CREATE,
  @JsonValue("UPDATE")
  UPDATE,
  @JsonValue("DELETE")
  DELETE
}
