import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  //await longCalculationAsync();
  //await longCalculationReactive();

  streamExample();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
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
  print("Task finished with: " + (await longTask()).toString());
}

Future longCalculationReactive() async {
  longTask().then((value) => print("Task finished with: " + value.toString()));
}

/*
Mistake 1
Future<int> calculateLongTask() async{
  longTask().then((value) => return value);
}

 */
/*
Mistake 2
Future<int> calculateLongTask() async{
  return await longTask().then((value) => value + 3);
}

 */
/*
Mistake 3
Future calculateLongTask() async{
  longTask().then((value) => print(someMoreCalculations(value)));
}

int someMoreCalculations(int value){
  for (var i = 0; i < 1000000000; ++i) {
    value+= i;
  }
  return value;
}
 */

Stream<int> importantInformationStream() {
  StreamController<int> controller;
  Timer timer;
  int counter = 0;

  tick(_) {
    counter++;
    controller.add(counter);
    if (counter == 5) {
      timer?.cancel();
      controller?.close();
    }
  }

  onStart() {
    timer = Timer.periodic(Duration(seconds: 1), tick);
  }

  onCancel() {
    timer?.cancel();
    controller?.close();
  }

  controller =
      StreamController.broadcast(onCancel: onCancel, onListen: onStart);
  return controller.stream;
}

void importantInformationHandler() {
  Timer timer;
  int counter = 0;
  tick(_) {
    counter++;
    print("Service 1 uses information " + counter.toString());
    if (counter % 2 == 0) {
      print("Service 2 only uses even information " + counter.toString());
    }
    if (counter == 5) {
      print("Service 3 only cares about the last information " +
          counter.toString());
      timer.cancel();
    }
  }

  timer = Timer.periodic(Duration(seconds: 1), tick);
}

Future streamExample() async {
  var importantInformation =
      importantInformationStream(); // Reactive, Declarative

  importantInformation.listen(
      (event) => print("Listener 1 uses information " + event.toString()));

  importantInformation.where((event) => event % 2 == 0).listen((event) =>
      print("Listener 2 only uses even information " + event.toString()));

  importantInformation.last.then((value) => print(
      "Listener 3 only cares about the last information " + value.toString()));

  await importantInformation
      .last; // await stream so both examples don't run at the same time

  importantInformationHandler(); //Imperative
}