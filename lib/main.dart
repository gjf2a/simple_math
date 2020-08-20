import 'package:flutter/material.dart';
import 'dart:math';

import 'package:simple_math/problems.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Quizzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  AppState _state = AppState.setup;
  Problems _problems;
  Random _rng = new Random();
  TextEditingController _controller;
  TextStyle _ts;
  Op _selected = Op.plus;
  bool _lastCorrect = true;

  void initState() {
    super.initState();
    _controller = TextEditingController(text: '12');
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check(String answer) {
    try {
      var target = int.parse(answer);
      setState(() {
        var result = _problems.enterResponse(target);
        _lastCorrect = (result == Outcome.correct);
        if (_problems.finished()) {
          _state = AppState.done;
        }
      });
    } on FormatException {

    }
  }

  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline4;
    if (_state == AppState.quiz) {
      return quizScreen();
    } else if (_state == AppState.setup) {
      return setup();
    } else {
      return done();
    }
  }

  Widget quizScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: _lastCorrect ? Colors.green : Colors.red,
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_problems.current().toString() + " = ", style: _ts),
                SizedBox(width: 100, child: TextField(controller: _controller,style: _ts, keyboardType: TextInputType.number,
                    onSubmitted: (String value) {_check(value); _controller.clear();})),
              ],),
            RaisedButton(child: Text("Restart", style: _ts), onPressed: () {setState(() {
              _state = AppState.setup;
            });},)
          ],
        ),
      ),
    );
  }

  Widget setup() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            radio("+", Op.plus),
            radio("-", Op.minus),
            radio("x", Op.times),
            radio("/", Op.divide),
            SizedBox(width: 100, child: TextField(controller: _controller,style: _ts, keyboardType: TextInputType.number,
                onSubmitted: (String value) {_start(value); _controller.clear();})),
          ],
        ),
      ),
    );
  }

  Widget radio(String label, Op value) {
    return Row( mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [Radio(groupValue: _selected, value: value, onChanged: (o) {setState(() {
          print("$value");_selected = value;});}),
        Text(label, style: _ts)]);
  }

  void _start(String value) {
    try {
      var target = int.parse(value);
      print("target: $target; _selected: $_selected");
      setState(() {
        print("setting state");
        _problems = Problems(_selected, target, _rng);
        print("created _problems");
        _state = AppState.quiz;
        print("_state: $_state");
      });
    } on FormatException {
      print("Threw an exception...");
    }
  }

  Widget done() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Congratulations! All answers correct.", style: _ts),
            RaisedButton(onPressed: () {setState(() {
              _state = AppState.setup;
            });}, child: Text("Restart", style: _ts,)),
          ],
        ),
      ),
    );
  }
}

enum AppState {
  setup,
  quiz,
  done
}