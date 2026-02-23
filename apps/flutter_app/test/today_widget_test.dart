import 'package:coachpulse/features/today/today_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('today page shows session card', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TodayPage()));
    expect(find.textContaining('60 min'), findsOneWidget);
  });
}
