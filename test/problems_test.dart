import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_math/problems.dart';

void main() {
  test('2 + 3', () {
    final p1 = Problem(2, Op.plus, 3);
    expect(p1.answer, 5);
    expect(Problem(5, Op.minus, 3), p1.inverse());
    expect(p1.inverse().answer, 2);
    expect(p1.inverse().inverse(), p1);
  });

  test('2 * 3', () {
    final p1 = Problem(2, Op.times, 3);
    expect(p1.answer, 6);
    expect(Problem(6, Op.divide, 3), p1.inverse());
    expect(p1.inverse().answer, 2);
    expect(p1.inverse().inverse(), p1);
  });

  test('Problems, addition', () {
    Problems probs = Problems(Op.plus, 2, new Random(2));
    var answers = [1, 1, 2, 2, 2, 4, 4, 3, 0, 3];
    var expected = [Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.incorrect, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct];
    for (var i = 0; i < answers.length; i++) {
      print("${probs.current()} returns ${answers[i]} ?= ${probs.current().answer}; ${expected[i]}");
      expect(probs.enterResponse(answers[i]), expected[i]);
    }
    expect(probs.finished(), true);
  });

  test('Problems, subtraction', () {
    Problems probs = Problems(Op.minus, 2, new Random(2));
    var answers = [1, 0, 2, 0, 2, 1, 2, 2, 0, 1];
    var expected = [Outcome.correct, Outcome.correct, Outcome.incorrect, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct];
    for (var i = 0; i < answers.length; i++) {
      print("${probs.current()} returns ${answers[i]} ?= ${probs.current().answer}; ${expected[i]}");
      expect(probs.enterResponse(answers[i]), expected[i]);
    }
    expect(probs.finished(), true);
  });
}