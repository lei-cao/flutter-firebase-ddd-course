import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_course/domain/core/value_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEmailAddress', () {
    group(
      'invalidEmails',
      () {
        var invalidInputs = [
          "",
          "123",
          "123@",
          "1234@com",
          "124dsf@sdf.",
        ];
        var expectsFailures = new Map.fromIterable(
          invalidInputs,
          key: (v) => v,
          value: (v) => Left(ValueFailure<String>.invalidEmail(failedValue: v)),
        );

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
        var invalidInputs = [
          "12@32.com",
          "1@2.c",
        ];
        var expectsFailures = new Map.fromIterable(
          invalidInputs,
          key: (v) => v,
          value: (v) => Right(v),
        );

        expectsFailures.forEach((input, expected) {
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
        var invalidInputs = [
          "",
          "123",
          "12334",
        ];
        var expectsFailures = new Map.fromIterable(
          invalidInputs,
          key: (v) => v,
          value: (v) => Left(ValueFailure<String>.shortPassword(failedValue: v)),
        );

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
        var invalidInputs = [
          "123456",
          "ds.fjx#",
        ];
        var expectsFailures = new Map.fromIterable(
          invalidInputs,
          key: (v) => v,
          value: (v) => Right(v),
        );

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validatePassword(input);
            expect(result, expected);
          });
        });
      },
    );
  });
}
