import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailAddress', () {
    group(
      'invalidEmails',
      () {
        final invalidInputs = [
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
            final result = EmailAddress(input).value;
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
            final result = EmailAddress(input).value;
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

        final expectsFailures = {
          for (var input in invalidInputs)
            input: Left(ValueFailure<String>.shortPassword(failedValue: input))
        };


        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = Password(input).value;
            expect(result, expected);
          });
        });
      },
    );

    group(
      'validPasswords',
      () {
        final validInputs = [
          "123456",
          "ds.fjx#",
        ];
        final expectsValues = {
          for (var input in validInputs) input: Right(input)
        };

        expectsValues.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = Password(input).value;
            expect(result, expected);
          });
        });
      },
    );
  });
}
