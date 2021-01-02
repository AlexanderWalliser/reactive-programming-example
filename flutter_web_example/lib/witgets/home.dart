import 'package:flutter/material.dart';
import 'package:flutter_web_example/entities/to_do.dart';
import 'package:flutter_web_example/models/to_do_model.dart';
import 'package:flutter_web_example/witgets/to_do_list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Consumer<ToDoModel>(builder: (context, toDoModel, child) {
          return ToDoList(toDoModel.toDos);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:() => createDialog().then(
          (value) {
            if (value != null) {
              Provider.of<ToDoModel>(context, listen: false).create(ToDo(text: value));
            }
          },
        ),
      ),
    );
  }

  Future createDialog() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController text;
        return AlertDialog(
          title: Text("Create new ToDo"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: text = new TextEditingController(),
                  decoration: InputDecoration(
                    hintText: "ToDo",
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
