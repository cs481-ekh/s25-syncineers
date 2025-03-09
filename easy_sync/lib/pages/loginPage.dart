import 'package:easy_sync/tools/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_sync/tools/auth_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_sync/tools/calendar_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
 

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final SharedPreferencesManager _prefs = SharedPreferencesManager();

  //  final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
  // );

  GoogleSignInAccount? _currentUser;
  
  //store local value for shared preferences
  //String _email = ''; 
  String _cal = '';
  List<String> _calList = [];
 // late GoogleSignInAccount _currentUser;


  //store local values for user data
  String _displayName = 'displayName';
  String _email = 'email';
  String _id = 'id';
  String _photoUrl = 'photoUrl';
  String _serverAuthCode = 'serverAuthCode';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  //load changes in shared preferences
  void _loadSettings() async  {
    print('Loading settings');
    final userValues = await _prefs.getUserValues();
    final calendar = await _prefs.getSelectedCal();
    final calendarList = await _prefs.getCalendarListKey();

    // final userValues = await _prefs.getUserValues();
    // final displayName = userValues['displayName'] ?? '';
    // final email = userValues['email'] ?? '';
    // final id = userValues['id'] ?? '';
    // final photoUrl = userValues['photoUrl'] ?? '';
    // final serverAuthCode = userValues['serverAuthCode'] ?? '';

    
      setState(() {

        _displayName =  userValues['displayName'] ?? '';
        _email =  userValues['email'] ?? '';
        _id =  userValues['id'] ?? '';
        _photoUrl =  userValues['photoUrl'] ?? '';
        _serverAuthCode = userValues['serverAuthCode'] ?? '';

        _cal = calendar;
        _calList = calendarList;
      //  _calList = List<String>.from(calendarList as Iterable<dynamic>);
      });

      if (_currentUser != null) {
      await getCalendarList(_currentUser!);
      final updatedCalendarList = await _prefs.getCalendarListKey();
      setState(() {
        _calList = updatedCalendarList;
      });
    }
    }
    

  void _handleSignIn(GoogleSignInAccount? account) {
    setState(() {
      _currentUser = account;
   //   if (account != null) {
        _loadSettings();
   //   }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('login Page'),
          GoogleSignInButton(onSignIn: _handleSignIn,),

          ElevatedButton(
            onPressed: () async {
              if(_currentUser != null) {
                final cal = await _prefs.getSelectedCal();
                createEvent(_currentUser!, await _prefs.getCalendarID(cal), "Event Title", "Event Description", 
                "My house", "2025-03-08T17:00", "2025-03-08T18:00", "America/Denver", ['RRULE:FREQ=WEEKLY;BYDAY=MO,WE;UNTIL=20250315T000000Z']);
              }
              else {
                print('No user signed in');
              }
            },
            child: const Text('Create test event'),
          ),
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