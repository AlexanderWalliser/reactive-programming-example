import 'dart:convert';

import 'package:flutter_web_example/entities/to_do.dart';
import 'package:http/http.dart' as http;

class ToDoService {
  static String _connection = "http://localhost:8080/todos";

  static Future<List<ToDo>> getToDos() async {
    return http.get(_connection + "").then((response) {
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return Future.value(list.map((e) => ToDo.fromJson(e)).toList());
      } else {
        throw Exception('Failed to load homeStation');
      }
    });
  }

  static Future<bool> create(ToDo toDo) async {
    return http.post(_connection + "",
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(toDo.toJson())).then((response) {
      if (response.statusCode == 201) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    });
  }

  static Future<bool> update(ToDo toDo) async {
    return http.put(_connection + "/" + toDo.id.toString(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(toDo.toJson())).then((response) {
      if (response.statusCode == 200) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    });
  }
  static Future<bool> delete(int id) async {
    return http.delete(_connection + "/" + id.toString()).then((response) {
      if (response.statusCode == 204) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    });
  }
}
