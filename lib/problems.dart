import 'dart:math';

enum Op {
  plus,
  minus,
  times,
  divide
}

class OpData {
  int Function(int,int) _op;
  Op _inverse;
  String _symbol;

  OpData(this._op, this._inverse, this._symbol);

  int Function(int,int) get op => _op;
  Op get inverse => _inverse;
  String get symbol => _symbol;
}

Map<Op,OpData> opData = {
  Op.plus: OpData((a, b) => a + b, Op.minus, "+"),
  Op.minus: OpData((a, b) => a - b, Op.plus, "-"),
  Op.times: OpData((a, b) => a * b, Op.divide, "x"),
  Op.divide: OpData((a, b) => a ~/ b, Op.times, "/")
};

class Quiz {
  List<ArithmeticProblem> _problems = List();
  List<ArithmeticProblem> _incorrect = List();
  Random _random;

  Quiz(Op op, int max, this._random) {
      for (int x = 0; x <= max; x++) {
        for (int y = 0; y <= max; y++) {
          _addValidProblem(_makeFrom(x, y, op));
        }
      }
      _problems.shuffle(_random);
  }

  void _addValidProblem(ArithmeticProblem p) {
    if (p.valid) {
      _problems.add(p);
    }
  }

  ArithmeticProblem _makeFrom(int x, int y, Op op) {
    if (op == Op.minus || op == Op.divide) {
      return ArithmeticProblem(x, opData[op].inverse, y).inverse();
    } else {
      return ArithmeticProblem(x, op, y);
    }
  }

  bool finished() => _problems.isEmpty && _incorrect.isEmpty;

  ArithmeticProblem current() {
    if (_problems.isEmpty) {
      _problems = _incorrect;
      _incorrect = List();
      _problems.shuffle(_random);
    }
    return _problems.last;
  }

  Outcome enterResponse(int response) {
    ArithmeticProblem p = _problems.removeLast();
    if (p.answer == response) {
      return Outcome.correct;
    } else {
      _incorrect.add(p);
      return Outcome.incorrect;
    }
  }

  String toString() => 'Problems:${_problems.toString()}; Incorrect:${_incorrect.toString()}';
}

enum Outcome {
  correct,
  incorrect
}

class ArithmeticProblem {
  int _x;
  Op _op;
  int _y;
  int _result;
  int _hash;
  bool _valid = true;

  ArithmeticProblem(this._x, this._op, this._y) {
    _valid = _y != 0 || _op != Op.divide;
    if (_valid) {
      _result = opData[_op].op(_x, _y);
    }
    _hash = toString().hashCode;
  }

  ArithmeticProblem inverse() => ArithmeticProblem(_result, opData[_op].inverse, _y);

  int get answer => _result;

  bool get valid => _valid;

  bool operator ==(o) => o is ArithmeticProblem && _x == o._x && _y == o._y && _op == o._op;

  int get hashCode => _hash;

  String toString() {
    return "$_x ${opData[_op].symbol} $_y";
  }
}
