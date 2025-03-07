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
  String _cal = '';
  List<String> _calList = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  //load changes in shared preferences
  void _loadSettings() async {

    final email = await _prefs.getEmailKey();
    final calendar = await _prefs.getSelectedCal();
    final calendarList = await _prefs.getCalendarListKey();

    setState(() {
      _email = email;
      _cal = calendar;
      _calList = List<String>.from(calendarList as Iterable<dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('login Page'),
          GoogleSignInButton(),
          Text("Current Email: $_email"),
          Text("Current Calendar: $_cal"),
          Expanded(
            child: ListView.builder(
              itemCount: _calList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_calList[index]),
                  onTap: () {
                    _prefs.setSelectedCal(_calList[index]);
                    _loadSettings();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}