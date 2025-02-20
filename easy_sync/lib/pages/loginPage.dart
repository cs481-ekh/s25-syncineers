import 'package:flutter/material.dart';
import 'package:easy_sync/tools/auth_button.dart';

class LoginPage extends StatefulWidget {
 

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('login Page'),
          GoogleSignInButton(),
        ],
      ),
    );
  }
}