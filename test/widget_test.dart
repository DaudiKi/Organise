// This is a basic Flutter widget test for the ALU Student Platform app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:organise/main.dart';

void main() {
  testWidgets('App launches with dashboard', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AluStudentPlatformApp());

    // Verify that the app has a bottom navigation bar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify that we have the Dashboard, Assignments, and Schedule tabs
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches screens', (WidgetTester tester) async {
    await tester.pumpWidget(const AluStudentPlatformApp());

    // Initially on Dashboard
    expect(find.text("Today's Classes"), findsOneWidget);

    // Tap on Assignments tab
    await tester.tap(find.text('Assignments'));
    await tester.pumpAndSettle();

    // Verify we're on Assignments screen
    expect(find.text('Assignments Management'), findsOneWidget);

    // Tap on Schedule tab
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();

    // Verify we're on Schedule screen
    expect(find.text('Schedule Management'), findsOneWidget);
  });
}
