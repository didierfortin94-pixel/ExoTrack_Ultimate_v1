import 'package:coachpulse/features/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login form renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
