import 'package:easy_sync/tools/frame.dart';
import 'package:flutter/material.dart';
import 'tools/auth_button.dart';
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
        '/': (context) => InputPage(),
        '/edit': (context) => EditPage(const [["col1","col2","col3"],["example11","example12","example13"],["example21","example22","example23"]]),
        '/login': (context) => LoginPage(const []),
      }
    );
  }
}
