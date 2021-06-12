import 'package:flutter/material.dart';
import 'package:flutter_firebase_ddd_course/injection.dart';
import 'package:flutter_firebase_ddd_course/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  late Widget signInPage;
  setUpAll(() {
    configureInjection(Environment.test);
    signInPage = const MaterialApp(
      title: 'Test APp',
      home: SignInPage(),
    );
  });
  tearDownAll(() {
    getIt.reset(dispose: true);
  });
  testWidgets('SignInPage has a title', (WidgetTester tester) async {
    await tester.pumpWidget(signInPage);
    final titleFinder = find.text('Sign In');
    expect(titleFinder, findsOneWidget);
  });
  group('email', () {
    testWidgets('SignInPage has an email label', (WidgetTester tester) async {
      await tester.pumpWidget(signInPage);
      final titleFinder = find.text('Email');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('should validate email', (WidgetTester tester) async {
      await tester.pumpWidget(signInPage);
      final emailTextField = find.widgetWithText(TextField, 'Email');

      await tester.enterText(emailTextField, 'hi');
      await tester.pump();

      // invalid email
      Finder invalidEmailFinder = find.text('Invalid Email');
      expect(invalidEmailFinder, findsOneWidget);

      await tester.enterText(emailTextField, 'hi@ok.com');
      await tester.pump();

      invalidEmailFinder = find.text('Invalid Email');
      expect(invalidEmailFinder, findsNothing);
    });
  });

  group('password', () {
    testWidgets('SignInPage has a password label', (WidgetTester tester) async {
      await tester.pumpWidget(signInPage);
      final titleFinder = find.text('Password');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('should validate password', (WidgetTester tester) async {
      await tester.pumpWidget(signInPage);
      final passwordTextField = find.widgetWithText(TextField, 'Password');

      await tester.enterText(passwordTextField, 'hi');
      await tester.pump();

      // invalid email
      Finder invalidPasswordFinder = find.text('Invalid Password');
      expect(invalidPasswordFinder, findsOneWidget);

      await tester.enterText(passwordTextField, 'himypass');
      await tester.pump();

      invalidPasswordFinder = find.text('Invalid Password');
      expect(invalidPasswordFinder, findsNothing);
    });
  });


  testWidgets('SignInPage has a sign in button', (WidgetTester tester) async {
    await tester.pumpWidget(signInPage);
    final titleFinder = find.text('SIGN IN');
    expect(titleFinder, findsOneWidget);
  });
  testWidgets('SignInPage has a register button', (WidgetTester tester) async {
    await tester.pumpWidget(signInPage);
    final titleFinder = find.text('REGISTER');
    expect(titleFinder, findsOneWidget);
  });
  testWidgets('SignInPage has a google sign in button', (WidgetTester tester) async {
    await tester.pumpWidget(signInPage);
    final titleFinder = find.text('SIGN IN WITH GOOGLE');
    expect(titleFinder, findsOneWidget);
  });
}
