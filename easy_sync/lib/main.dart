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
        '/': (context) => const Frame(title: 'login', child: LoginPage()),
        '/input': (context) => const Frame(title: 'input', child: InputPage()),
        '/edit': (context) => const Frame(title: 'edit', child: EditPage()),
      }
    );
  }
}
