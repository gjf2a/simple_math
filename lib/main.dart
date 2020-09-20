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

  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline4;
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        backgroundColor: pickBackground(),
        body: Center(child: _screen()));
  }

  Color pickBackground() {
    if (_screen == quizScreen) {
      return _lastCorrect ? Colors.green : Colors.red;
    } else {
      return Colors.white;
    }
  }

  Widget setup() {
    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        radio("+", Op.plus),
        radio("-", Op.minus),
        radio("x", Op.times),
        radio("/", Op.divide),
        numericalEntry(200, "Maximum", (String value) { }),
        RaisedButton(child: Text("Start", style: _ts), onPressed: () {_start(_controller.text);}),
      ],
    );
  }

  Widget quizScreen() {
    _controller.clear();
    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${_problems.current()} = ", style: _ts),
            numericalEntry(200, "answer", _check),
          ],),
        _restartButton()
      ],
    );
  }

  Widget numericalEntry(double width, String label, void Function(String) onSubmitted) {
    return SizedBox(width: width, child: TextField(controller: _controller, style: _ts,
      keyboardType: TextInputType.number, onSubmitted: onSubmitted,
        decoration: InputDecoration(labelText: label)));
  }

  Widget radio(String label, Op value) {
    return ListTile( title: Text(label, style: _ts),
        leading: Radio(groupValue: _selected, value: value, onChanged: (o) {setState(() {
          _selected = value;});}),
        );
  }

  Widget done() {
    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Congratulations! All answers correct.", style: _ts),
        _restartButton(),
      ],
    );
  }

  Widget _restartButton() {
    return RaisedButton(onPressed: _restart, child: Text("Restart", style: _ts,));
  }

  void _processNumberEntry(String value, void Function(int) processor) {
    try {
      processor(int.parse(value));
    } on FormatException {
      print("Threw an exception...");
    }
  }

  void _start(String value) {
    _processNumberEntry(value, (v) {
      setState(() {
        _lastMax = v;
        _lastCorrect = true;
        _problems = Quiz(_selected, _lastMax, _rng);
        _screen = quizScreen;
      });
    });
  }

  void _check(String answer) {
    _processNumberEntry(answer, (target) {
      setState(() {
        Outcome result = _problems.enterResponse(target);
        _lastCorrect = (result == Outcome.correct);
        if (_problems.finished()) {
          _screen = done;
        }
      });
    });
  }

  void _restart() {
    setState(() {
      _resetController();
      _screen = setup;
    });
  }
}