import 'package:easy_sync/pages/landingPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:flutter/material.dart';
import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/pages/inputPage.dart';
import 'package:easy_sync/pages/editPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LandingPage(),
        '/input': (context) => InputPage(),
        '/edit': (context) => EditPage(table: Dataset([["col1","col2","col3"],["example11","example12","example13"],["example21","example22","example23"]]), questions: {"random question":QuestionAndAnswers("This is a developmental test question. If you are read this something went wrong.")}),
        '/login': (context) => LoginPage(const []),
      }
    );
  }
}
