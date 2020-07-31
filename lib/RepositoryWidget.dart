import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;


class RepositoryWidget extends StatefulWidget {

  static String tag = 'repository-page';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class _RepositoryWidget extends State<RepositoryWidget> {

  List<Repository> _items = new List();
  final subject = new PublishSubject<String>();

  bool _isLoading = false;

  TextEditingController textEditingController = TextEditingController(text: '');

  void _textChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _clearList();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _clearList();

    http
        .get("https://api.github.com/search/repositories?q=language:$text&order=desc&sort=stars")
        .then((response) => response.body)
        .then(json.decode)
        .then((map) => map['items'])
        .then((list) {
      list.forEach(_addItem);
    }).catchError(_onError).then((e){
        setState(() {
          _isLoading = false;
        });
    });
  }

  void _onError(dynamic d) {
    setState(() {
      _isLoading = false;
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  void _addItem(item) {
    setState(() {
      _items.add(Repository.fromJson(item));
    });
  }

  @override
  void initState() {
    super.initState();
    subject.stream
        .debounce(new Duration(milliseconds: 600))
        .listen(_textChanged);
  }

  clearData() {
    subject.add("");
    textEditingController.text="";
  }


  Widget _createSearchBar(BuildContext context) {
    return new Card(
      child: Row(
        children: <Widget>[
          new IconButton(icon: Icon(Icons.arrow_back), onPressed: () => clearData()),
          new Expanded(child: TextField(
            autofocus: true,
            controller: textEditingController,
            decoration: new InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.0),
              hintText: 'Search repositories here'
            ),
            onChanged: (string) => (subject.add(string)),
          )),
        ],
      ),
    );
  }

  Widget _createRepositoryItem(BuildContext context, Repository repository) {
    return new GestureDetector(
      onTap: () {

      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 80.0,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: _createRepositoryItemDescription(context, repository),
                  ),
                ),
              ],
            ),
          ),
          new Divider(height: 15.0, color: Colors.black,),
        ],
      ),
    );

  }

  Widget _createRepositoryItemDescription(BuildContext buildContext, Repository repository) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          repository.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.0,
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(600),
        child: const Text(''),
      ),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
        child: new Column(
          children: <Widget>[
            _createSearchBar(context),
            new Expanded(child: Card(
              child: _isLoading ? Container(
                child: Center(
                  child: CircularProgressIndicator()),
                  padding: EdgeInsets.all(16.0),
                ) :
              new ListView.builder(
                padding: new EdgeInsets.all(16.0),
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _createRepositoryItem(context, _items[index]);
                },
              ),
            )
            ),
          ],
        ),
      ),
      );
  }

}

class Repository {
  String name, description, stars;

  Repository({
    this.name,
    this.description,
    this.stars,
  });

  Repository.fromJson(dynamic repository) {
    try {
      this.name = repository['full_name'];
      this.description = repository['description'];
      this.stars = repository['stargazers_count'];
    } catch (e) {
      print('something happened' + e.toString());
    }
  }
}
