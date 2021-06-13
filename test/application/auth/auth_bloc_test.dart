import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/application/auth/auth_bloc.dart';
import 'package:flutter_firebase_ddd_course/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/user.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_course/domain/core/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthFacade extends Mock implements IAuthFacade {}

void main() {
  late AuthBloc bloc;
  late MockIAuthFacade mockIAuthFacade;

  setUp(() {
    mockIAuthFacade = MockIAuthFacade();
    bloc = AuthBloc(mockIAuthFacade);
  });
  test('initialState should be empty', () {
    // assert
    expect(bloc.state, equals(const AuthState.initial()));
  });

  group('authCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'should authenticate user',
      build: () {
        when(
              () => mockIAuthFacade.getSignedInUser(),
        ).thenAnswer(
              (_) async => Future.value(
            some(
              User(
                id: UniqueId.fromUniqueString('123'),
              ),
            ),
          ),
        );
        return AuthBloc(mockIAuthFacade);
      },
      act: (bloc) => {bloc.add(const AuthEvent.authCheckRequested())},
      expect: () => <AuthState>[const AuthState.authenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should unauthenticate the user',
      build: () {
        when(
              () => mockIAuthFacade.getSignedInUser(),
        ).thenAnswer(
              (_) async => Future.value(
            none(),
          ),
        );
        return AuthBloc(mockIAuthFacade);
      },
      act: (bloc) => {bloc.add(const AuthEvent.authCheckRequested())},
      expect: () => <AuthState>[const AuthState.unauthenticated()],
    );

  });

  group('signOut', () {
    blocTest<AuthBloc, AuthState>(
      'should authenticate the user',
      build: () {
        when(
              () => mockIAuthFacade.signOut(),
        ).thenAnswer(
              (_) async => Future.value(),
        );
        return AuthBloc(mockIAuthFacade);
      },
      act: (bloc) => {bloc.add(const AuthEvent.signedOut())},
      expect: () => <AuthState>[const AuthState.unauthenticated()],
    );

  });

}
