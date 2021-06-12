import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_ddd_course/domain/core/errors.dart';
import 'package:uuid/uuid.dart';
import 'failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  T getOrCrash() => value.fold((f) => throw UnexpectedValueError(f), id);

  bool isValid() => value.isRight();

  @override
  String toString() => 'Value($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}


class UniqueId extends ValueObject<String> {
    @override
    final Either<ValueFailure<String>, String> value;

    factory UniqueId() {
        return UniqueId._(
          right(const Uuid().v1()),
        );
    }

    factory UniqueId.fromUniqueString(String uniqueId) {
      return UniqueId._(
        right(uniqueId),
      );
    }

    const UniqueId._(this.value);
}