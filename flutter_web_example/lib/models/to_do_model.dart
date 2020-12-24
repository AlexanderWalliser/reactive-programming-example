import 'package:flutter/material.dart';
import 'package:flutter_web_example/entities/change_typ.dart';
import 'package:flutter_web_example/entities/to_do.dart';
import 'package:flutter_web_example/services/event_service.dart';
import 'package:flutter_web_example/services/to_do_service.dart';

class ToDoModel extends ChangeNotifier {
  List<ToDo> _toDos;

  List<ToDo> get toDos {
    load();
    return _toDos;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ToDoModel() : _toDos = [] {
    load();
    EventService.connect().stream.listen((event) {
      print(event.toString());

      if(event.changeType == ChangeType.create){
        _toDos.add(new ToDo(id: event.id,text: event.text));
      }
      else if(event.changeType == ChangeType.update){
        var toDo = _toDos.firstWhere((e) => e.id == event.id);
        toDo.id = event.id;
        toDo.text = event.text;
      }
      else if(event.changeType == ChangeType.delete){
        _toDos.removeWhere((e) => e.id == event.id);
      }
    });
  }

  Future load() async {
    if (!_isLoading) {
      _isLoading = true;
      return ToDoService.getToDos().then((loaded) {
        _toDos.clear();
        _toDos.addAll(loaded);
        notifyListeners();
        _isLoading = false;
      }).catchError((err) {
        _isLoading = false;
      });
    }
  }

  Future<bool> create(ToDo toDo) async{
    return ToDoService.create(toDo);
  }
  Future<bool> update(ToDo toDo) async{
    return ToDoService.update(toDo);
  }
  Future<bool> delete(ToDo toDo) async{
    return ToDoService.delete(toDo.id);
  }

  void notify() {
    notifyListeners();
  }
}
