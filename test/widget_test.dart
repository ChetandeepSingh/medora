import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medora/main.dart';  // Update this with your actual entry point

void main() {
  testWidgets('Check if login screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Login'), findsOneWidget);  // Adjust based on your UI
  });
}
