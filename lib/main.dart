import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Quizzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Math Quizzer'),
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
  int _correct = 0;
  int _incorrect = 0;
  int _x = 0;
  int _y = 0;
  Random _rng = new Random();
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
    _reset_nums();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reset_nums() {
    _x = _rng.nextInt(12) + 1;
    _y = _rng.nextInt(12) + 1;
  }

  void _check(String answer) {
    try {
      var target = int.parse(answer);
      setState(() {
        int total = _x + _y;
        if (total == target) {
          _correct += 1;
        } else {
          _incorrect += 1;
        }
        _reset_nums();
      });
    } on FormatException {

    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _ts = Theme.of(context).textTheme.headline4;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$_x + $_y = ', style: _ts),
                SizedBox(width: 100, child: TextField(controller: _controller,style: _ts,
                    onSubmitted: (String value) {_check(value); _controller.clear();})),
              ],),
            Text(
              'Correct: $_correct',style: _ts,
            ),
            Text(
              'Incorrect: $_incorrect',style: _ts,
            )
            ],
        ),
      ),
    );
  }
}
