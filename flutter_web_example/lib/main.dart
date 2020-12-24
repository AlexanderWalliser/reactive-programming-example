import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_example/entities/to_do.dart';
import 'package:flutter_web_example/models/to_do_model.dart';
import 'package:provider/provider.dart';

void main() async {
  await longCalculationReactive();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToDoModel()),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Reactive Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Consumer<ToDoModel>(
          builder: (context, toDoModel, child) {
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (int i = 0; i < toDoModel.toDos.length; i++)
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 7),
                      title: Text(toDoModel.toDos[i].text),
                    ),
                  )
              ],
              padding: EdgeInsets.only(top: 0),
            );
          }),
    );
  }
}

class Calc {
  static Future<int> longCalculation(int start) async {
    int sum = start;
    for (int i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      print(sum += 1);
    }
    return sum;
  }
}

void sayHelloSync(String name) {
  String hello = "Hello $name!";
  print(hello);
}

Future sayHelloAsync(String name) async {
  Future futureHello = Future(() => "Hello $name!");
  print(await futureHello);
}

void sayHelloReactive(String name) {
  Future futureHello = Future(() => "Hello $name!");
  futureHello.then((value) => print(value));
}

Future<int> longTask() async {
  return compute(Calc.longCalculation, 0);
}

Future longCalculationAsync() async {
  print(await longTask());
}

Future longCalculationReactive() async {
  longTask().then((value) => print(value));
}
