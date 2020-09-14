import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_math/problems.dart';

void main() {
  test('2 + 3', () {
    final p1 = ArithmeticProblem(2, Op.plus, 3);
    expect(p1.answer, 5);
    expect(ArithmeticProblem(5, Op.minus, 3), p1.inverse());
    expect(p1.inverse().answer, 2);
    expect(p1.inverse().inverse(), p1);
  });

  test('2 * 3', () {
    final p1 = ArithmeticProblem(2, Op.times, 3);
    expect(p1.answer, 6);
    expect(ArithmeticProblem(6, Op.divide, 3), p1.inverse());
    expect(p1.inverse().answer, 2);
    expect(p1.inverse().inverse(), p1);
  });

  test('Problems, addition', () {
    testQuiz(Op.plus, [1, 1, 2, 2, 2, 4, 4, 3, 0, 3],
        [Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.incorrect, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct]);
  });

  test('Problems, subtraction', () {
    testQuiz(Op.minus, [1, 0, 2, 0, 2, 1, 2, 2, 0, 1],
        [Outcome.correct, Outcome.correct, Outcome.incorrect, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct]);
  });

  test('Problems, multiplication', () {
    testQuiz(Op.times, [0, 0, 1, 0, 0, 2, 4, 2, 0], [Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct]);
  });

  test('Problems, division', () {
    testQuiz(Op.divide, [1, 2, 0, 1, 2, 0], [Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct, Outcome.correct]);
  });
}

void testQuiz(Op op, List<int> answers, List<Outcome> expected) {
  Quiz probs = Quiz(op, 2, new Random(2));
  print("$probs");
  for (var i = 0; i < answers.length; i++) {
    print("${probs.current()} returns ${answers[i]} ?= ${probs.current().answer}; ${expected[i]}");
    expect(probs.enterResponse(answers[i]), expected[i]);
  }
  expect(probs.finished(), true);
}