import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<ListElement>.generate(
        20, (index) => ListElement(
        "Title $index", "Description $index")
    ),
  ));
}

class MyApp extends StatelessWidget {

  final List<ListElement> items;

  MyApp({Key key, @required this.items}): super(key: key);

  @override
  Widget build(BuildContext context) {

    final title = "Git repos";

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
            itemCount: items.length,

            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: item.buildTitle(context),
                subtitle: item.buildDescription(context),
              );
            }),
      ),
    );

  }

}

class ListElement {
    final String title;
    final String description;

  ListElement(this.title, this.description);

  Widget buildTitle(BuildContext context) => Text(title);
  Widget buildDescription(BuildContext context) => Text(description);
}

