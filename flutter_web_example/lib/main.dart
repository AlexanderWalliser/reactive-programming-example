import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_example/models/to_do_model.dart';
import 'package:flutter_web_example/witgets/home.dart';
import 'package:provider/provider.dart';

void main() async {
  await longCalculationReactive();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ToDoModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reactive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Reactive Demo'),
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
