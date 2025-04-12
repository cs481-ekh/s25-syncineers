import 'dart:math';

import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_sync/tools/auth_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_sync/tools/calendar_tools.dart';
import 'package:easy_sync/tools/event_struct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, List<EventStruct>> findEventLocations(List<EventStruct> list) {
  return Map.fromIterable(
    list.map((element) => element.location).toSet(),
    value: (location) => list.where((element) => element.location == location).toList(),
  );
}

class LoginPage extends StatefulWidget {
 
 final List<EventStruct> events;
 late Map<String,List<EventStruct>> locationEventLists;
 late List<String> locations;
 late int selectedLocationIndex;

  LoginPage(this.events, {super.key}) {
    locationEventLists = findEventLocations(events);
    locations = locationEventLists.keys.toList();
    selectedLocationIndex = -1;
  }

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
                      final bool confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Event'),
                            content: const Text('Do you want to create this event?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // User cancels
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // User confirms
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed && widget.selectedLocationIndex != -1) {
                        final cal = await _prefs.getSelectedCal();
                       
                        //createEvent(_currentUser!, await _prefs.getCalendarID(cal), event);
                        createMultipleEvents(_currentUser!, await _prefs.getCalendarID(cal), widget.locationEventLists[widget.locations[widget.selectedLocationIndex]]!);
                      }
                    } else {
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
            Row(
              children: [
                _cal.isNotEmpty ? //display current calendar text
                  Expanded(
                    child: Center(
                      child: Text(
                        "Current Calendar: $_cal", 
                        style: const TextStyle(
                          fontSize: 16
                        ), 
                        textAlign: TextAlign.center,)
                      )
                    ) 
                  : const Expanded(
                    child: Center(
                      child: Text(
                        "No calendar selected", 
                        style: TextStyle(
                          fontSize: 16
                        ),
                        textAlign: TextAlign.center
                      )
                    )
                  ),

                widget.selectedLocationIndex == -1 ? // display desired event location to upload to
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No event location selected", 
                        style: TextStyle(
                          fontSize: 16
                        ),
                        textAlign: TextAlign.center
                      )
                    )
                  ) 
                  : Expanded(
                    child: Center(
                      child: Text(
                        "Current event location: ${widget.locations[widget.selectedLocationIndex]}", 
                        style: const TextStyle(
                          fontSize: 16
                        ),
                        textAlign: TextAlign.center
                      )
                    )
                  ),
              ]
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
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
                  const SizedBox(width: 10), //space between listviews
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                    itemCount: widget.locations.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(widget.locations[index]),
                          subtitle: Text(widget.locationEventLists[widget.locations[index]]!.map((element) => element.summary).join(", "), style: const TextStyle(fontSize: 10),),
                          onTap: () {
                            setState(() {
                              widget.selectedLocationIndex = index;
                            });
                          },
                        ),
                      );
                    },
                    ),
                  )
                ]
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse("http://calendar.google.com"))) {
                    await launchUrl(Uri.parse("https://calendar.google.com"));
                  } else {
                    print("Error opening Google Calendar");
                  }
                }, 
                child: const Text("Open Google Calendar")
              ),
            ),
          ],
        ),  
      )
    );
  }
}