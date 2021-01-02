import 'package:flutter/material.dart';
import 'package:flutter_web_example/entities/to_do.dart';
import 'package:flutter_web_example/models/to_do_model.dart';
import 'package:provider/provider.dart';

class ToDoList extends StatefulWidget {
  final List<ToDo> toDos;

  ToDoList(this.toDos);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.toDos.length,
      itemBuilder: (context, index) {
        final ToDo item = widget.toDos[index];

        return Dismissible(
          key: Key(item.id.toString()),
          onDismissed: (direction) {
            setState(() {
              widget.toDos.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("ToDo \"${item.text}\" dismissed"),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Provider.of<ToDoModel>(context, listen: false).delete(item);
          },
          background: Container(color: Colors.red),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 7),
            title: Text(item.text),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editDialog(item.text).then(
                (value) {
                  if (value != null) {
                    item.text = value;
                    Provider.of<ToDoModel>(context, listen: false).update(item);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future editDialog(String toDoText) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController text;
        return AlertDialog(
          title: Text("Change text from " + toDoText + "?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: text = new TextEditingController(),
                  decoration: InputDecoration(
                    hintText: toDoText,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(text.text);
              },
            ),
          ],
        );
      },
    );
  }
}
