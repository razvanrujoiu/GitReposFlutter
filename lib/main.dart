import 'package:flutter/material.dart';
import 'package:gitrepos/RepositoryWidget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    RepositoryWidget.tag: (context) => RepositoryWidget(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Recipe Finder',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryWidget(),
      routes: routes,
    );
  }
}