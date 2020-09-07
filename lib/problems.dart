import 'dart:math';

class Quiz {
  List<ArithmeticProblem> _problems = List();
  List<ArithmeticProblem> _incorrect = List();
  Random _random;

  Quiz(Op op, int max, this._random) {
      for (int x = 0; x <= max; x++) {
        for (int y = 0; y <= max; y++) {
          ArithmeticProblem p = _makeFrom(x, y, op);
          if (p.valid) {
            _problems.add(p);
          }
        }
      }
      _problems.shuffle(_random);
  }

  ArithmeticProblem _makeFrom(int x, int y, Op op) {
    if (op == Op.minus || op == Op.divide) {
      return ArithmeticProblem(x, inv(op), y).inverse();
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
    if (_op == Op.plus) {
      _result = _x + _y;
    } else if (this._op == Op.minus) {
      _result = _x - _y;
    } else if (_op == Op.times) {
      _result = _x * _y;
    } else if (_y != 0) {
      _result = _x ~/ _y;
    } else {
      _valid = false;
    }
    _hash = toString().hashCode;
  }

  ArithmeticProblem inverse() => ArithmeticProblem(_result, inv(_op), _y);

  int get answer => _result;

  bool get valid => _valid;

  bool operator ==(o) => o is ArithmeticProblem && _x == o._x && _y == o._y && _op == o._op;

  int get hashCode => _hash;

  String toString() {
    String symbol = _op == Op.plus ? "+" : _op == Op.minus ? "-" : _op == Op.times ? "x" : "/";
    return "$_x $symbol $_y";
  }
}

enum Op {
  plus,
  minus,
  times,
  divide
}

Op inv(Op o) => o == Op.plus ? Op.minus : o == Op.minus ? Op.plus : o == Op.times ? Op.divide : Op.times;