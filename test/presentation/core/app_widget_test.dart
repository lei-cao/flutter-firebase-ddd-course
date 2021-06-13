import 'package:flutter_firebase_ddd_course/injection.dart';
import 'package:flutter_firebase_ddd_course/presentation/core/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  setUp(() {
    configureInjection(Environment.test);
  });
  testWidgets('AppWidget should run', (WidgetTester tester) async {
    await tester.pumpWidget(AppWidget());
  });
}