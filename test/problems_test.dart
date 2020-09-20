import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_math/problems.dart';

void main() {
  test('2 + 3', () {
    basicTest(Op.plus, 2, 3, 5);
  });

  test('2 * 3', () {
    basicTest(Op.times, 2, 3, 6);
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

void basicTest(Op op, int operand1, int operand2, int expectedValue) {
  ArithmeticProblem p1 = ArithmeticProblem(operand1, op, operand2);
  expect(p1.answer, expectedValue);
  expect(ArithmeticProblem(expectedValue, opData[op].inverse, operand2), p1.inverse());
  expect(p1.inverse().answer, operand1);
  expect(p1.inverse().inverse(), p1);
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