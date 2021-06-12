import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/auth_failure.dart';
import 'package:flutter_firebase_ddd_course/domain/auth/user.dart' as user;
import 'package:flutter_firebase_ddd_course/domain/auth/value_objects.dart';
import 'package:flutter_firebase_ddd_course/domain/core/errors.dart';
import 'package:flutter_firebase_ddd_course/domain/core/value_objects.dart';
import 'package:flutter_firebase_ddd_course/infrastructure/auth/firebase_auth_facade.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements firebase.User {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FirebaseAuthFacade firebaseAuthFacade;
  late MockUserCredential mockUserCredential;
  late MockFirebaseUser mockFirebaseUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockFirebaseUser = MockFirebaseUser();
    firebaseAuthFacade = FirebaseAuthFacade(mockFirebaseAuth, mockGoogleSignIn);
  });

  const validEmail = 'email@gmail.com';
  const validPassword = 'somepass';

  group('getSignedInUser', () {
    test(
      'should return a valid User',
      () async {
        // arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(() => mockFirebaseUser.uid).thenReturn('test-uid');
        // act
        final result = await firebaseAuthFacade.getSignedInUser();
        // assert
        expect(
          result,
          equals(
            some(
              user.User(
                id: UniqueId.fromUniqueString('test-uid'),
              ),
            ),
          ),
        );
      },
    );
    test(
      'should return none',
      () async {
        // arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);
        // act
        final result = await firebaseAuthFacade.getSignedInUser();
        // assert
        expect(
          result,
          equals(
            none(),
          ),
        );
      },
    );
  });

  group('registerWithEmailAndPassword', () {
    setUp(() {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: validEmail,
            password: validPassword,
          )).thenAnswer((_) async => mockUserCredential);
    });
    test(
      'should throw a UnexpectedValueError when the email is not valid',
      () async {
        // act
        final call = firebaseAuthFacade.registerWithEmailAndPassword;
        // assert
        expect(
          () => call(
            emailAddress: EmailAddress('i'),
            password: Password(validPassword),
          ),
          throwsA(
            const TypeMatcher<UnexpectedValueError>(),
          ),
        );
      },
    );
    test(
      'should throw a UnexpectedValueError when the password is not valid',
      () async {
        // act
        final call = firebaseAuthFacade.registerWithEmailAndPassword;
        // assert
        expect(
          () => call(
            emailAddress: EmailAddress(validEmail),
            password: Password('1'),
          ),
          throwsA(
            const TypeMatcher<UnexpectedValueError>(),
          ),
        );
      },
    );
    test('should call firebaseAuth.createUserWithEmailAndPassword', () async {
      // act
      firebaseAuthFacade.registerWithEmailAndPassword(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPassword),
      );
      // verify
      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: validEmail,
          password: validPassword,
        ),
      );
    });
    test('should return emailAlreadyInUse', () async {
      // arrange
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: validEmail,
          password: validPassword,
        ),
      ).thenAnswer(
        (_) async => throw PlatformException(code: 'email-already-in-use'),
      );
      // act
      final result = await firebaseAuthFacade.registerWithEmailAndPassword(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPassword),
      );
      // verify
      expect(
        result,
        equals(const Left(AuthFailure.emailAlreadyInUse())),
      );
    });
    test('should return serverError', () async {
      // arrange
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: validEmail,
          password: validPassword,
        ),
      ).thenAnswer(
        (_) async => throw PlatformException(code: 'some-other-code'),
      );
      // act
      final result = await firebaseAuthFacade.registerWithEmailAndPassword(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPassword),
      );
      // verify
      expect(
        result,
        equals(const Left(AuthFailure.serverError())),
      );
    });
  });

  group('signInWithEmailAndPassword', () {
    setUp(() {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: validEmail,
            password: validPassword,
          )).thenAnswer((_) async => mockUserCredential);
    });
    test('should call firebaseAuth.signInWithEmailAndPassword', () async {
      // act
      firebaseAuthFacade.signInWithEmailAndPassword(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPassword),
      );
      // verify
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: validEmail,
          password: validPassword,
        ),
      );
    });
    test('should return invalidEmailAndPasswordCombination', () async {
      // arrange
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: validEmail,
          password: validPassword,
        ),
      ).thenAnswer(
        (_) async => throw PlatformException(code: 'user-not-found'),
      );
      // act
      final result = await firebaseAuthFacade.signInWithEmailAndPassword(
        emailAddress: EmailAddress(validEmail),
        password: Password(validPassword),
      );
      // verify
      expect(
        result,
        equals(const Left(AuthFailure.invalidEmailAndPasswordCombination())),
      );
    });
  });

  group('signInWithGoogle', () {
    setUp(() {});
    test('should call firebaseAuth.signInWithCredential', () async {
      // @todo
    });
  });

  group('signOut', () {
    setUp(() {
      when(
        () => mockFirebaseAuth.signOut(),
      ).thenAnswer(
        (_) async => Future.value(),
      );
      when(
        () => mockGoogleSignIn.signOut(),
      ).thenAnswer(
        (_) async => Future.value(),
      );
    });
    test('should call firebaseAuth.signOut', () async {
      // act
      await firebaseAuthFacade.signOut();
      // verify
      verify(
        () => mockFirebaseAuth.signOut(),
      );
    });
    test('should call google.signOut', () async {
      // act
      await firebaseAuthFacade.signOut();
      // verify
      verify(
        () => mockGoogleSignIn.signOut(),
      );
    });
  });
}
