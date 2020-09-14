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
  Widget Function() _screen;
  Quiz _problems;
  Random _rng = new Random();
  TextEditingController _controller;
  TextStyle _ts;
  Op _selected = Op.plus;
  bool _lastCorrect = true;
  int _lastMax = 12;

  void initState() {
    super.initState();
    _resetController();
    _screen = setup;
  }

  void _resetController() {
    _controller = TextEditingController(text: '$_lastMax');
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
          _screen = done;
        }
      });
    } on FormatException {

    }
  }

  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline4;
    return _screen();
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
            ListTile(title: Text("Maximum", style: _ts), leading: SizedBox(width: 100, child: TextField(controller: _controller,style: _ts, keyboardType: TextInputType.number,))),
            RaisedButton(child: Text("Start", style: _ts), onPressed: () {_start(_controller.text);}),
          ],
        ),
      ),
    );
  }

  Widget quizScreen() {
    _controller.clear();
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
                    onSubmitted: (String value) {_check(value);})),
              ],),
            _restartButton()
          ],
        ),
      ),
    );
  }

  Widget radio(String label, Op value) {
    return ListTile( title: Text(label, style: _ts),
        leading: Radio(groupValue: _selected, value: value, onChanged: (o) {setState(() {
          print("$value");_selected = value;});}),
        );
  }

  void _start(String value) {
    try {
      _lastMax = int.parse(value);
      print("target: $_lastMax; _selected: $_selected");
      setState(() {
        print("setting state");
        _problems = Quiz(_selected, _lastMax, _rng);
        print("created _problems");
        _screen = quizScreen;
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
            _restartButton(),
          ],
        ),
      ),
    );
  }

  Widget _restartButton() {
    return RaisedButton(onPressed: () {_restart();}, child: Text("Restart", style: _ts,));
  }

  void _restart() {
    setState(() {
      _resetController();
      _screen = setup;
    });
  }
}