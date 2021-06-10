import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_course/domain/core/value_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEmailAddress', () {
    group(
      'invalidEmails',
      () {
        final List<String> invalidInputs = [
          "",
          "123",
          "123@",
          "1234@com",
          "124dsf@sdf.",
        ];
        final expectsFailures = {
          for (var input in invalidInputs)
            input: Left(ValueFailure<String>.invalidEmail(failedValue: input))
        };

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validateEmailAddress(input);
            expect(result, expected);
          });
        });
      },
    );

    group(
      'validEmails',
      () {
        final validInputs = [
          "12@32.com",
          "1@2.c",
        ];
        final expectsValues = {
          for (var input in validInputs) input: Right(input)
        };

        expectsValues.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validateEmailAddress(input);
            expect(result, expected);
          });
        });
      },
    );
  });

  group('validatePassword', () {
    group(
      'invalidPasswords',
      () {
        final invalidInputs = [
          "",
          "123",
          "12334",
        ];
        // var expectsFailures = new Map.fromIterable(
        //   invalidInputs,
        //   key: (v) => v,
        //   value: (v) =>
        //       Left(ValueFailure<String>.shortPassword(failedValue: v)),
        // );

        final expectsFailures = {
          for (var input in invalidInputs)
            input: Left(ValueFailure<String>.shortPassword(failedValue: input))
        };

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validatePassword(input);
            expect(result, expected);
          });
        });
      },
    );

    group(
      'validPasswords',
      () {
        final List<String> validInputs = [
          "123456",
          "ds.fjx#",
        ];
        final expectsValues = {
          for (var input in validInputs) input: Right(input)
        };

        expectsValues.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validatePassword(input);
            expect(result, expected);
          });
        });
      },
    );
  });
}
