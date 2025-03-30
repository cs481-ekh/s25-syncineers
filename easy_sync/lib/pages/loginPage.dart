import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_sync/tools/auth_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_sync/tools/calendar_tools.dart';
import 'package:easy_sync/tools/event_struct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
 
 final List<EventStruct> events;

  const LoginPage(this.events, {super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final SharedPreferencesManager _prefs = SharedPreferencesManager();

  GoogleSignInAccount? _currentUser;
  
  String _cal = ''; //selected calendar
  List<String> _calList = []; //list of user's calendars

  //store local values for user data
  String _displayName = 'displayName';
  String _email = 'email';
  String _id = 'id';
  String _photoUrl = 'photoUrl';
  String _serverAuthCode = 'serverAuthCode';

  @override
  void initState() {
    super.initState();
    _prefs.clearUser();
    _loadSettings();
  }

  //load changes in shared preferences
  void _loadSettings() async  {


    final userValues = await _prefs.getUserValues();
    final calendar = await _prefs.getSelectedCal();
    final calendarList = await _prefs.getCalendarListKey();
    
      setState(() {

        _displayName =  userValues['displayName'] ?? '';
        _email =  userValues['email'] ?? '';
        _id =  userValues['id'] ?? '';
        _photoUrl =  userValues['photoUrl'] ?? '';
        _serverAuthCode = userValues['serverAuthCode'] ?? '';

        _cal = calendar;
        _calList = calendarList;
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
    return Frame(
      title: 'Login Page',
      onNextPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No next page')),
        );
      },
      nextColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Center(child: GoogleSignInButton(onSignIn: _handleSignIn))),
              Expanded(
                child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if(_currentUser != null) {
                      final cal = await _prefs.getSelectedCal();
                      final event = EventStruct(
                        summary: "Event Title", 
                        description: "Event Description", 
                        location: "My house", 
                        startTime: "2025-03-10T17:00", 
                        endTime: "2025-03-10T18:00", 
                        timezone: "America/Denver", 
                        recurrenceRules: ['RRULE:FREQ=WEEKLY;BYDAY=MO,WE;UNTIL=20250315T000000Z']);
                      final event1 = EventStruct(
                        summary: "Testing", 
                        description: "Event Description", 
                        location: "My house", 
                        startTime: "2025-03-10T18:00", 
                        endTime: "2025-03-10T19:00", 
                        timezone: "America/Denver", 
                        recurrenceRules: ['RRULE:FREQ=WEEKLY;BYDAY=TU,TH;UNTIL=20250315T000000Z']);
                      final event2 = EventStruct(
                        summary: "Hello there", 
                        description: "Event Description", 
                        location: "My house", 
                        startTime: "2025-03-10T19:00", 
                        endTime: "2025-03-10T20:00", 
                        timezone: "America/Denver", 
                        recurrenceRules: ['RRULE:FREQ=WEEKLY;BYDAY=F;UNTIL=20250315T000000Z']);
                      
                      final eventList = [event, event1, event2];
                      //createEvent(_currentUser!, await _prefs.getCalendarID(cal), event);
                      createMultipleEvents(_currentUser!, await _prefs.getCalendarID(cal), eventList);
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No user signed in')),
                      );
                    }
                  },
                  child: const Text('Create Events'),
                ),
                            ),
              ),
              ]
            ),
            const SizedBox(height: 20),

            _cal.isNotEmpty ? 
              Text("Current Calendar: $_cal", style: const TextStyle(fontSize: 16)) 
              : const Text("No calendar selected", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 10),
            
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: _calList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(_calList[index]),
                      onTap: () {
                        _prefs.setSelectedCal(_calList[index]);
                        _loadSettings();
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            
          ],
        ),  
             
          
        )

      );
  }
}