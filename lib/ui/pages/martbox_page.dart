import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MartBoxPage extends StatefulWidget {
  final String text;

  MartBoxPage({this.text}) : super();

  @override
  createState() => new HomeState();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Text('Martbox: $text'),
  //     ),
  //   );
  // }
}

class HomeState extends State<MartBoxPage> {
  ScrollController controller;
  final _All = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _All.addAll(generateWordPairs().take(20));
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    setState(() {
      isLoading = !isLoading;
      fetchData();
    });
  }

  fetchData() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, onResponse);
  }

  void onResponse() {
    setState(() {
      isLoading = !isLoading;
      _All.addAll(generateWordPairs().take(20));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildSuggestions(),
          _loader(),
        ],
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new Column(
      children: <Widget>[
        new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: new Icon(
            alreadySaved ? Icons.check : Icons.check,
            color: alreadySaved ? Colors.deepOrange : null,
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              } else {
                _saved.add(pair);
              }
            });
          },
        ),
        new Divider(),
      ],
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        controller: controller,
        itemCount: _All.length,
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          return _buildRow(_All[i]);
        });
  }

  Widget _loader() {
    return isLoading
        ? new Align(
            child: new Container(
              color: Colors.white,
              width: double.infinity,
              height: 70.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(
                      child: new SpinKitThreeBounce(size: 30.0, color: Colors.yellow[700],
                  ),
                ),
              ),
            ),
            alignment: FractionalOffset.bottomCenter,
          )
        : new SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}
