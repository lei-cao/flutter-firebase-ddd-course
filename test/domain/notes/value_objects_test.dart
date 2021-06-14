import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_course/domain/notes/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

import '../core/testing_utils.dart';

void main() {
  group('NoteBody', () {
    group(
      'invalid NoteBody',
      () {
        test("should return empty failure", () {
          expect(NoteBody("").value,
              const Left(ValueFailure<String>.empty(failedValue: "")));
        });

        test("should return exceeding 1000 length failure", () {
          String input = "a";
          for (int i = 0; i < 10; i++) {
            input = input + input;
          }
          input = input.substring(0, 1001);
          expect(
              NoteBody(input).value,
              Left(ValueFailure<String>.exceedingLength(
                  failedValue: input, max: 1000)));
        });
      },
    );

    group(
      'valid NoteBody',
      () {
        test("should return valid NoteBody", () {
          expect(
            NoteBody("1").value,
            const Right("1"),
          );
        });

        test("should return valid 1000 length NoteBody", () {
          String input = "a";
          for (int i = 0; i < 10; i++) {
            input = input + input;
          }
          input = input.substring(0, 1000);
          expect(NoteBody(input).value, Right(input));
        });
      },
    );
  });

  group('TodoName', () {
    group(
      'invalid TodoName',
      () {
        test("should return empty failure", () {
          expect(TodoName("").value,
              const Left(ValueFailure<String>.empty(failedValue: "")));
        });

        test("should return exceeding 30 length failure", () {
          String input = "a";
          for (int i = 0; i < 5; i++) {
            input = input + input;
          }
          input = input.substring(0, 31);
          expect(
              TodoName(input).value,
              Left(ValueFailure<String>.exceedingLength(
                  failedValue: input, max: 30)));
        });

        test("should return multiline failure", () {
          String input = """a
              """;
          for (int i = 0; i < 5; i++) {
            input = input + input;
          }
          input = input.substring(0, 30);
          expect(TodoName(input).value,
              Left(ValueFailure<String>.multiline(failedValue: input)));
        });
      },
    );

    group(
      'valid TodoName',
      () {
        test("should return valid TodoName", () {
          expect(
            TodoName("1").value,
            const Right("1"),
          );
        });

        test("should return valid 30 length TodoName", () {
          String input = "a";
          for (int i = 0; i < 10; i++) {
            input = input + input;
          }
          input = input.substring(0, 30);
          expect(TodoName(input).value, Right(input));
        });
      },
    );
  });

  group('List3', () {
    group('invalid List3', () {
      test("should return exceeding 3 list length failure", () {
        KtList<String> input = KtList.of("1", "2", "3", "4");
        expect(
            List3(input).value,
            Left(ValueFailure<KtList<String>>.listTooLong(
                failedValue: input, max: 3)));
      });
    });

    group(
      'valid List3',
      () {
        test("should return valid empty list", () {
          KtList<String> input = KtList.of();
          List3 list = List3(input);
          expect(list.value, Right(input));
          expect(list.length, 0);
        });
        test("should return valid max list", () {
          KtList<String> input = KtList.of("1", "2", "3");
          List3 list = List3(input);
          expect(list.value, Right(input));
          expect(list.length, 3);
          expect(list.isFull, true);
        });
      },
    );
  });
}
