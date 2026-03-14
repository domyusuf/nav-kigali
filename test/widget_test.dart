import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav_kigali/main.dart';

void main() {
  testWidgets('App basic load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NavKigaliApp());

    // Basic check - since Firebase is not initialized in test environment,
    // we just check if the app starts.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
