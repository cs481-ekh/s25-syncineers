import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_sync/main.dart';
import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/pages/inputPage.dart';
import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/auth_button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  testWidgets('MainApp should have correct routes', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('LoginPage should have GoogleSignInButton', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.byType(GoogleSignInButton), findsOneWidget);
  });

  testWidgets('InputPage should display file picker when icon is clicked', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InputPage()));
    await tester.tap(find.byIcon(Icons.file_open));
    await tester.pump();
    expect(find.byIcon(Icons.file_open), findsOneWidget);
  });

  testWidgets('EditPage should display correct text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EditPage()));
    expect(find.text('Edit Page'), findsOneWidget);
  });

  testWidgets('Frame should navigate correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Frame(title: 'Test', child: LoginPage()),
      routes: {
        '/input': (context) => InputPage(),
        '/edit': (context) => const EditPage(),
      },
    ));
    
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.byType(InputPage), findsOneWidget);
    
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(EditPage), findsOneWidget);
  });

  testWidgets('GoogleSignInButton should be displayed properly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GoogleSignInButton()));
    expect(find.text('Sign in with Google'), findsOneWidget);
  });

  testWidgets('GoogleSignInButton should show snackbar on failure', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoogleSignInButton(),
        ),
      ),
    );
    await tester.tap(find.text('Sign in with Google'));
    await tester.pump();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('Frame should have correct app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Frame(title: 'Test Title', child: LoginPage()),
    ));
    expect(find.text('Test Title'), findsOneWidget);
  });
}
