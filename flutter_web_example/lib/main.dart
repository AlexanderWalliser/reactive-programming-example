import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_example/models/to_do_model.dart';
import 'package:flutter_web_example/witgets/home.dart';
import 'package:provider/provider.dart';

void main() async {
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




