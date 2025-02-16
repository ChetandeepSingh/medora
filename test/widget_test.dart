import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medora/main.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    // Build the Medora app
    await tester.pumpWidget(const MedoraApp());

    // Verify that there is an email and password field
    expect(find.byType(TextField), findsNWidgets(2)); // ✅ Find exactly 2 text fields

    // Verify that the login button exists
    expect(find.widgetWithText(ElevatedButton, "Login"), findsOneWidget); // ✅ Find login button
  });
}