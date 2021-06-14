import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';
import 'package:flutter_firebase_ddd_course/domain/notes/note.dart';
import 'package:flutter_firebase_ddd_course/domain/notes/todo_item.dart';
import 'package:flutter_firebase_ddd_course/domain/notes/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group(
    'invalid Note',
    () {
      test("should return failure for empty() body", () {
        final Note note = Note.empty();
        expect(note.failureOption,
            const Some(ValueFailure<String>.empty(failedValue: "")));
      });

      test("should return failure for empty() for some todo item's name", () {
        final todoItems =
            KtList.of(TodoItem.empty().copyWith(name: TodoName('')));
        final Note note =
            Note.empty().copyWith(body: NoteBody('l'), todos: List3(todoItems));
        expect(note.failureOption,
            const Some(ValueFailure<String>.empty(failedValue: "")));
      });
    },
  );

  group(
    'valid Note',
    () {
      test("should return None() failureOption", () {
        final todoItems =
            KtList.of(TodoItem.empty().copyWith(name: TodoName('x')));
        final Note note =
            Note.empty().copyWith(body: NoteBody('l'), todos: List3(todoItems));
        expect(note.failureOption, const None());
      });
    },
  );
}
