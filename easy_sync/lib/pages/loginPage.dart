import 'package:easy_sync/tools/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_sync/tools/auth_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
 

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final SharedPreferencesManager _prefs = SharedPreferencesManager();
  
  //store local value for shared preferences
  String _email = ''; 

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  //load changes in shared preferences
  void _loadSettings() async {

    final email = await _prefs.getEmailKey();

    setState(() {
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('login Page'),
          GoogleSignInButton(),
          Text(_email),
        ],
      ),
    );
  }
}