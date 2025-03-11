import 'dart:typed_data';

import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/pages/inputPage.dart';
import 'package:easy_sync/pages/loginPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_sync/main.dart';

void main() {
  testWidgets('MainApp has routes and renders LoginPage, InputPage and EditPage', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MainApp());

    // Verify that the LoginPage widget is rendered
    expect(find.byType(LoginPage), findsOneWidget);
    
    // Test navigation to '/input' route
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(InputPage), findsOneWidget);

    // Test navigation to '/edit' route
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(EditPage), findsOneWidget);
  });

  testWidgets('EditPage renders question and selectable answers', (WidgetTester tester) async {
    // Mock input data for the EditPage
    var rows = [
      ['Subject', 'GEOG'],
      ['Descr', 'Introduction to Geography'],
    ];

    // Build the EditPage widget
    await tester.pumpWidget(MaterialApp(home: EditPage(rows)));

    // Verify that the question text is present
    expect(find.text('What is the title of the events'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets); // Verify selectable answers are displayed
  });

}