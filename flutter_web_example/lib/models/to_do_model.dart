import 'package:flutter/material.dart';
import 'package:flutter_web_example/entities/change_typ.dart';
import 'package:flutter_web_example/entities/to_do.dart';
import 'package:flutter_web_example/services/event_service.dart';
import 'package:flutter_web_example/services/to_do_service.dart';

class ToDoModel extends ChangeNotifier {
  List<ToDo> _toDos;

  List<ToDo> get toDos {
    return _toDos.toList();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ToDoModel() : _toDos = [] {
    load();
    EventService.connect().stream.listen((event) {
      print(event.toString());

      if(event.changeTyp == ChangeTyp.CREATE){
        _toDos.add(new ToDo(id: event.id,text: event.text));
        notify();
      }
      else if(event.changeTyp == ChangeTyp.UPDATE){
        var toDo = _toDos.firstWhere((e) => e.id == event.id);
        toDo.id = event.id;
        toDo.text = event.text;
        notify();
      }
      else if(event.changeTyp == ChangeTyp.DELETE){
        _toDos.removeWhere((e) => e.id == event.id);
        notify();
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
