import 'dart:typed_data';

import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/pages/inputPage.dart';
import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/pages/landingPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_sync/main.dart';

void main() {
  testWidgets('MainApp has routes and renders LandingPage and InputPage', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MainApp());

    // Verify that the LandingPage widget is rendered
    expect(find.byType(LandingPage), findsOneWidget);
    
    // Test navigation to '/input' route
    await tester.tap(find.byKey(const Key('next_button')));
    await tester.pumpAndSettle();
    expect(find.byType(InputPage), findsOneWidget);
  });

  testWidgets('EditPage renders question and selectable answers', (WidgetTester tester) async {
    // Mock input data for the EditPage
    final Map<String, QuestionAndAnswers> questions = {
      "summary": QuestionAndAnswers.withAnswers("How is each event title constructed", [0, 1, 7, 2]),
      "catalog number": QuestionAndAnswers.withAnswers("What is the catalog number", [1]),
      "location": QuestionAndAnswers.withAnswers("Where is the event Located", [19]),
      "description": QuestionAndAnswers.withAnswers("While not needed. If you want to add a description, then you can build one here.", []),
      "first day" : QuestionAndAnswers.withAnswers("Which column contains the first day", [14]),
      "last day" : QuestionAndAnswers.withAnswers("Which column contains the last day", [14]),
      "startTime" : QuestionAndAnswers.withAnswers("Which column contains the start time", [16]), 
      "endTime" : QuestionAndAnswers.withAnswers("Which column contains the end time", [16]),
      "recurrenceRules" : QuestionAndAnswers.withAnswers("Which column contains which days of the week are repeated", [16]),
    };
    var rows = [
      ['Subject', 'GEOG'],
      ['Descr', 'Introduction to Geography'],
    ];

    // Build the EditPage widget
    await tester.pumpWidget(MaterialApp(home: EditPage(table: Dataset(rows), questions: questions,)));

    // Verify that the question text is present
    expect(find.text('How is each event title constructed'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets); // Verify selectable answers are displayed
  });

}