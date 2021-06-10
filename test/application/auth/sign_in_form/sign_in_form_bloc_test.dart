import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_firebase_ddd_course/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/i_auth_facade.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/value_objects.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthFacade extends Mock implements IAuthFacade {}

void main() {
  late SignInFormBloc bloc;
  late MockIAuthFacade mockIAuthFacade;

  final initialState = SignInFormState(
    emailAddress: EmailAddress(''),
    password: Password(''),
    authFailureOrSuccessOption: none(),
    isSubmitting: false,
    showErrorMessages: false,
  );

  setUp(() {
    mockIAuthFacade = MockIAuthFacade();
    bloc = SignInFormBloc(mockIAuthFacade);
  });
  test('initialState should be empty', () {
    // assert
    expect(bloc.state, equals(initialState));
  });

  group('emailChanged', () {
    const String newEmail = 'new emailStr';
    blocTest<SignInFormBloc, SignInFormState>(
      'should change email',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) => {bloc.add(const SignInFormEvent.emailChanged(newEmail))},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(newEmail),
          password: Password(''),
          isSubmitting: false,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        )
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should clear authFailureOrSuccessOption after change email',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      seed: () => SignInFormState(
        emailAddress: EmailAddress(''),
        password: Password(''),
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption:
            some(const Left(AuthFailure.cancelledByUser())),
      ),
      act: (bloc) => {bloc.add(const SignInFormEvent.emailChanged(newEmail))},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(newEmail),
          password: Password(''),
          isSubmitting: false,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
      ],
    );
  });

  group('passwordChanged', () {
    const String newPassword = 'new password';
    blocTest<SignInFormBloc, SignInFormState>(
      'should clear authFailureOrSuccessOption after change password',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      seed: () => SignInFormState(
        emailAddress: EmailAddress(''),
        password: Password(''),
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption:
            some(const Left(AuthFailure.cancelledByUser())),
      ),
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.passwordChanged(newPassword))},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(''),
          password: Password(newPassword),
          isSubmitting: false,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
      ],
    );
  });

  group('signInWithGooglePressed', () {
    blocTest<SignInFormBloc, SignInFormState>(
      'should call signInWithGoogle',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.signInWithGooglePressed())},
      verify: (_) {
        verify(() => mockIAuthFacade.signInWithGoogle());
      },
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should signInWithGoogle successfully',
      build: () {
        when(() => mockIAuthFacade.signInWithGoogle())
            .thenAnswer((_) async => const Right(unit));
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) => {bloc.add(const SignInFormEvent.signInWithGooglePressed())},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(''),
          password: Password(''),
          isSubmitting: true,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState(
          emailAddress: EmailAddress(''),
          password: Password(''),
          isSubmitting: false,
          showErrorMessages: false,
          authFailureOrSuccessOption: some(const Right(unit)),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should signInWithGoogle with cancelledByUser failure',
      build: () {
        when(() => mockIAuthFacade.signInWithGoogle())
            .thenAnswer((_) async => const Left(AuthFailure.cancelledByUser()));
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) => {bloc.add(const SignInFormEvent.signInWithGooglePressed())},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(''),
          password: Password(''),
          isSubmitting: true,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState(
          emailAddress: EmailAddress(''),
          password: Password(''),
          isSubmitting: false,
          showErrorMessages: false,
          authFailureOrSuccessOption: some(const Left(AuthFailure.cancelledByUser())),
        ),
      ],
    );
  });

  group('registerWithEmailAndPasswordPressed', () {
    const validEmail = 'emailStr@ok.com';
    const validPass = 'longpass';
    blocTest<SignInFormBloc, SignInFormState>(
      'should not call registerWithEmailAndPassword when email or password is not valid',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.registerWithEmailAndPasswordPressed())},
      verify: (_) {
        verifyNever(() => mockIAuthFacade.registerWithEmailAndPassword(
            emailAddress: EmailAddress('any'), password: Password('any')));
      },
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should call registerWithEmailAndPassword when email and password are valid',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) => {
        bloc
          ..add(const SignInFormEvent.emailChanged(validEmail))
          ..add(const SignInFormEvent.passwordChanged(validPass))
          ..add(const SignInFormEvent.registerWithEmailAndPasswordPressed())
      },
      verify: (_) {
        verify(() => mockIAuthFacade.registerWithEmailAndPassword(
            emailAddress: EmailAddress(validEmail),
            password: Password(validPass))).called(1);
      },
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should registerWithEmailAndPassword successfully',
      build: () {
        when(() => mockIAuthFacade.registerWithEmailAndPassword(
                emailAddress: EmailAddress(validEmail),
                password: Password(validPass)))
            .thenAnswer((_) async => const Right(unit));
        return SignInFormBloc(mockIAuthFacade);
      },
      seed: () => SignInFormState(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPass),
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      ),
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.registerWithEmailAndPasswordPressed())},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: true,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: false,
          // @todo should we still show error message when succeed?
          // Should show success message instead.
          showErrorMessages: true,
          authFailureOrSuccessOption: some(const Right(unit)),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should registerWithEmailAndPassword with failure and show error messages',
      build: () {
        when(() => mockIAuthFacade.registerWithEmailAndPassword(
                emailAddress: EmailAddress(validEmail),
                password: Password(validPass)))
            .thenAnswer((_) async =>
                const Left(AuthFailure.invalidEmailAndPasswordCombination()));
        return SignInFormBloc(mockIAuthFacade);
      },
      seed: () => SignInFormState(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPass),
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      ),
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.registerWithEmailAndPasswordPressed())},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: true,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption:
              some(const Left(AuthFailure.invalidEmailAndPasswordCombination())),
        ),
      ],
    );
  });

  group('signInWithEmailAndPasswordPressed', () {
    const validEmail = 'emailStr@ok.com';
    const validPass = 'longpass';
    blocTest<SignInFormBloc, SignInFormState>(
      'should not call signInWithEmailAndPassword when email or password is not valid',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.signInWithEmailAndPasswordPressed())},
      verify: (_) {
        verifyNever(() => mockIAuthFacade.signInWithEmailAndPassword(
            emailAddress: EmailAddress('any'), password: Password('any')));
      },
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should call signInWithEmailAndPassword when email and password are valid',
      build: () {
        return SignInFormBloc(mockIAuthFacade);
      },
      act: (bloc) => {
        bloc
          ..add(const SignInFormEvent.emailChanged(validEmail))
          ..add(const SignInFormEvent.passwordChanged(validPass))
          ..add(const SignInFormEvent.signInWithEmailAndPasswordPressed())
      },
      verify: (_) {
        verify(() => mockIAuthFacade.signInWithEmailAndPassword(
            emailAddress: EmailAddress(validEmail),
            password: Password(validPass))).called(1);
      },
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should signInWithEmailAndPassword successfully',
      build: () {
        when(() => mockIAuthFacade.signInWithEmailAndPassword(
                emailAddress: EmailAddress(validEmail),
                password: Password(validPass)))
            .thenAnswer((_) async => const Right(unit));
        return SignInFormBloc(mockIAuthFacade);
      },
      seed: () => SignInFormState(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPass),
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      ),
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.signInWithEmailAndPasswordPressed())},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: true,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: false,
          // @todo should we still show error message when succeed?
          // Should show success message instead.
          showErrorMessages: true,
          authFailureOrSuccessOption: some(const Right(unit)),
        ),
      ],
    );

    blocTest<SignInFormBloc, SignInFormState>(
      'should signInWithEmailAndPassword with failure and show error messages',
      build: () {
        when(() => mockIAuthFacade.signInWithEmailAndPassword(
                emailAddress: EmailAddress(validEmail),
                password: Password(validPass)))
            .thenAnswer((_) async =>
                const Left(AuthFailure.invalidEmailAndPasswordCombination()));
        return SignInFormBloc(mockIAuthFacade);
      },
      seed: () => SignInFormState(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPass),
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      ),
      act: (bloc) =>
          {bloc.add(const SignInFormEvent.signInWithEmailAndPasswordPressed())},
      expect: () => <SignInFormState>[
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: true,
          showErrorMessages: false,
          authFailureOrSuccessOption: none(),
        ),
        SignInFormState(
          emailAddress: EmailAddress(validEmail),
          password: Password(validPass),
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption:
              some(const Left(AuthFailure.invalidEmailAndPasswordCombination())),
        ),
      ],
    );
  });
}
