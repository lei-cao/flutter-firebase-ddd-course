import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_course/domain/core/value_validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

import 'testing_utils.dart';

void main() {
  group('validateMaxStringLength', () {
    group(
      'invalidInputs',
      () {
        final List<LengthTest<String>> invalidInputs = [
          LengthTest(input: "", max: -1),
          LengthTest(input: "a", max: 0),
          LengthTest(input: "abc", max: 2),
          LengthTest(input: "10", max: 1),
        ];
        final expectsFailures = {
          for (var input in invalidInputs)
            input: Left(ValueFailure<String>.exceedingLength(
                failedValue: input.input, max: input.max))
        };

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validateMaxStringLength(input.input, input.max);
            expect(result, expected);
          });
        });
      },
    );

    group(
      'validInputs',
      () {
        final List<LengthTest<String>> invalidInputs = [
          LengthTest(input: "", max: 0),
          LengthTest(input: "", max: 1),
          LengthTest(input: "abc", max: 10),
          LengthTest(input: "10", max: 2),
        ];
        final expectsFailures = {
          for (var input in invalidInputs) input: right(input.input)
        };

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validateMaxStringLength(input.input, input.max);
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

  group('validateSingleLine', () {
    group(
      'invalidInputs',
      () {
        final List<String> invalidInputs = [
          """
          
          """,
          """o
          """,
          """
          x
          """,
          """
          
          d""",
        ];
        final expectsFailures = {
          for (var input in invalidInputs)
            input: Left(ValueFailure<String>.multiline(failedValue: input))
        };

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validateSingleLine(input);
            expect(result, expected);
          });
        });
      },
    );

    group(
      'validInputs',
      () {
        final List<String> invalidInputs = [
          """
          """,
          """o """,
          "",
          "1123",
        ];
        final expectsFailures = {
          for (var input in invalidInputs) input: right(input)
        };

        expectsFailures.forEach((input, expected) {
          test("$input -> $expected", () {
            final result = validateSingleLine(input);
            expect(result, expected);
          });
        });
      },
    );

    group('validateMaxListLength', () {
      group(
        'invalidInputs',
        () {
          final List<LengthTest<KtList<String>>> invalidInputs = [
            LengthTest(input: KtList.of("123"), max: -1),
            LengthTest(input: KtList.of("123"), max: 0),
            LengthTest(input: KtList.of("123", "222", "345"), max: 2),
          ];
          final expectsFailures = {
            for (var input in invalidInputs)
              input: Left(ValueFailure<KtList<String>>.listTooLong(
                  failedValue: input.input, max: input.max))
          };

          expectsFailures.forEach((input, expected) {
            test("$input -> $expected", () {
              final result = validateMaxListLength(input.input, input.max);
              expect(result, expected);
            });
          });
        },
      );

      group(
        'validInputs',
        () {
          final List<LengthTest<String>> invalidInputs = [
            LengthTest(input: "", max: 0),
            LengthTest(input: "", max: 1),
            LengthTest(input: "abc", max: 10),
            LengthTest(input: "10", max: 2),
          ];
          final expectsFailures = {
            for (var input in invalidInputs) input: right(input.input)
          };

          expectsFailures.forEach((input, expected) {
            test("$input -> $expected", () {
              final result = validateMaxStringLength(input.input, input.max);
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
