import 'package:flutter/material.dart';
import 'tools/auth_button.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GoogleSignInButton(),
    );
  }
}
