import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_course/domain/notes/todo_item.dart';
import 'package:flutter_firebase_ddd_course/domain/notes/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group(
    'invalid TodoItem',
    () {
      test("should return failure for empty() name", () {
        final TodoItem todo = TodoItem.empty();
        expect(todo.failureOption,
            const Some(ValueFailure<String>.empty(failedValue: "")));
      });
    },
  );

  group(
    'valid TodoItem',
    () {
      test("should return none() failure", () {
        final TodoItem todo = TodoItem.empty().copyWith(name: TodoName('lll'));
        expect(todo.failureOption, const None());
      });
    },
  );
}
