import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthFacade extends Mock implements IAuthFacade {}

void main() {
  late SignInFormBloc bloc;
  late MockIAuthFacade mockIAuthFacade;
  setUp(() {
    mockIAuthFacade = MockIAuthFacade();
    bloc = SignInFormBloc(mockIAuthFacade);
  });
  test('initialState should be empty', () {
    // arrange
    final initialState = SignInFormState(
      emailAddress: EmailAddress(''),
      password: Password(''),
      authFailureOrSuccess: none(),
      isSubmitting: false,
      showErrorMessages: false,
    );
    // assert
    expect(bloc.state, equals(initialState));
  });
}
