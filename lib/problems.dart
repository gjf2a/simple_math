import 'dart:math';

class Problems {
  List<Problem> _problems = List();
  List<Problem> _incorrect = List();
  Random _random;

  Problems(Op op, int max, this._random) {
      for (var x = 0; x <= max; x++) {
        for (var y = 0; y <= max; y++) {
          if (op == Op.minus || op == Op.divide) {
            _problems.add(Problem(x, inv(op), y).inverse());
          } else {
            _problems.add(Problem(x, op, y));
          }
        }
      }
      _problems.shuffle(_random);
  }

  bool finished() => _problems.isEmpty && _incorrect.isEmpty;

  Problem current() {
    if (_problems.isEmpty) {
      _problems = _incorrect;
      _incorrect = List();
      _problems.shuffle(_random);
    }
    return _problems.last;
  }

  Outcome enterResponse(int response) {
    Problem p = _problems.removeLast();
    if (p.answer == response) {
      return Outcome.correct;
    } else {
      _incorrect.add(p);
      return Outcome.incorrect;
    }
  }

  String toString() => 'Problems:' + _problems.toString() + "; Incorrect:" + _incorrect.toString();
}

enum Outcome {
  correct,
  incorrect
}

class Problem {
  int _x;
  Op _op;
  int _y;
  int _result;
  int _hash;

  Problem(this._x, this._op, this._y) {
    if (_op == Op.plus) {
      _result = _x + _y;
    } else if (this._op == Op.minus) {
      _result = _x - _y;
    } else if (_op == Op.times) {
      _result = _x * _y;
    } else {
      _result = _x ~/ _y;
    }
    _hash = toString().hashCode;
  }

  Problem inverse() => Problem(_result, inv(_op), _y);

  int get answer => _result;

  bool operator ==(o) => o is Problem && _x == o._x && _y == o._y && _op == o._op;

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