import 'package:flutter_firebase_ddd_course/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  String toString() {
    const explanation =
        'Encountered a ValueFailure at an unrecoverable point. Terminting.';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}
