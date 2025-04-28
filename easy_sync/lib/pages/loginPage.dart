import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_sync/tools/auth_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_sync/tools/calendar_tools.dart';
import 'package:easy_sync/tools/event_struct.dart';
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
 late Set<String> descriptionSkipSet;

  LoginPage(this.events, {super.key}) {
    locationEventLists = findEventLocations(events);
    locations = locationEventLists.keys.toList();
    locations.sort();
    descriptionSkipSet = {"All classes", "All undergraduate level classes", "All graduate level classes"};
    locations = ["All classes", "All undergraduate level classes", "All graduate level classes"] + locations;
    locationEventLists.addAll({
      "All classes": events,
      "All undergraduate level classes": events.where((element) => !element.isGraduateLevel).toList(),
      "All graduate level classes": events.where((element) => element.isGraduateLevel).toList(),
    });
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

  bool isUploading = false;
  double uploadPercentage = 0;

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
        _loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((isUploading)) {
      return Stack(children: [
        loginMainPage(context),
        const ModalBarrier(dismissible: false,),
        Container(color: const Color.fromARGB(67, 67, 67, 67),),
        Center(child: CircularProgressIndicator(value: uploadPercentage))
      ],);
    } else {
      return loginMainPage(context);
    }
  }

  Frame loginMainPage(BuildContext context) {
    return Frame(
    nextColor: Colors.grey,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children:[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Center(child: GoogleSignInButton(onSignIn: _handleSignIn))),
                  Expanded(
                  child: Center(
                    child: FilledButton(
                      onPressed: () async {
                        final cal = await _prefs.getSelectedCal();
          
                        if (!context.mounted) {
                          return;
                        }
                        
                        if(_currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No user signed in',
                              style: GoogleFonts.titilliumWeb(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                          );
                        } else if (cal == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No calendar selected',
                              style: GoogleFonts.titilliumWeb(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                          );
                        } else if (widget.selectedLocationIndex == -1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No location group selected',
                              style: GoogleFonts.titilliumWeb(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                          );
                        } else {
                          final bool confirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Event Creation',
                                  style: GoogleFonts.titilliumWeb(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text('Do you want to create these events?',
                                  style: GoogleFonts.titilliumWeb(
                                    fontSize: 16,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // User cancels
                                    },
                                    child: Text('Cancel',
                                      style: GoogleFonts.titilliumWeb(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true); // User confirms
                                    },
                                    child: Text('Confirm',
                                      style: GoogleFonts.titilliumWeb(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
          
                          if (confirmed) {
                            startFunction() {
                              isUploading = true;
                              uploadPercentage = 0;
                              setState(() {});
                            }
                            updateFunction(int progress, int total) {
                              uploadPercentage = progress / total;
                              setState(() {});
                            }
                            endFunction() {
                              isUploading = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Events uploaded',
                                    style: GoogleFonts.titilliumWeb(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  )
                                ),
                              );
                              setState(() {});
                            }
          
                            //createEvent(_currentUser!, await _prefs.getCalendarID(cal), event);
                            createMultipleEvents(_currentUser!, await _prefs.getCalendarID(cal), widget.locationEventLists[widget.locations[widget.selectedLocationIndex]]!, startFunction, updateFunction, endFunction);
                          }
                        }
                      },
                      child: Text('Create Events',
                        style: GoogleFonts.titilliumWeb(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                ]
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  //display currently selected calendar
                  Expanded(
                    child: Center(
                      child: Text( _cal.isNotEmpty ? "Current Calendar: $_cal" : "No calendar selected", 
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 16
                        ), 
                        textAlign: TextAlign.center
                      )
                    )
                  ), 
                  //display currently selected event location group
                  Expanded(
                    child: Center(
                      child: Text((widget.selectedLocationIndex == -1) ? "No event location selected" : 
                        "Current event location: ${widget.locations[widget.selectedLocationIndex]}", 
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 16
                        ),
                        textAlign: TextAlign.center
                      )
                    )
                  )
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
                            title: Text(_calList[index],
                              style: GoogleFonts.titilliumWeb(
                                fontSize: 16,
                              ),
                            ),
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
                            title: Text(widget.locations[index],
                              style: GoogleFonts.titilliumWeb(
                                fontSize: 16,
                              ),
                            ),
                            subtitle: (widget.descriptionSkipSet.contains(widget.locations[index])) ? null : Text(widget.locationEventLists[widget.locations[index]]!.map((element) => element.summary).join(", "), style: const TextStyle(fontSize: 10),),
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
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: FilledButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final TextEditingController controller = TextEditingController();
                              bool isLoading = false;
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  title: Text('Create New Calendar Set',
                                    style: GoogleFonts.titilliumWeb(
                                      fontSize: 24,
                                    ),
                                  ),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter calendar set name',
                                    ),
                                  ),
                                  actions: [
                                    isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Cancel',
                                            style: GoogleFonts.titilliumWeb(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final String calendarSetName = controller.text.trim();
                                            if (calendarSetName.isNotEmpty) {
                                              if (_currentUser != null) {
                                                setState(() {
                                                isLoading = true; // Show loading indicator
                                              });
                                                await addCalendarToList(_currentUser!, calendarSetName);
                                                
                                                Navigator.of(context).pop();
                                                
                                                setState(() {
                                                  _loadSettings();
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('No user signed in',
                                                    style: GoogleFonts.titilliumWeb(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  )),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Calendar set name cannot be empty',
                                                  style: GoogleFonts.titilliumWeb(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                )),
                                              );
                                            }
                                          },
                                          child: Text('Create',
                                            style: GoogleFonts.titilliumWeb(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                                }
                              );
                            },
                          );
                        },
                        child: Text("Create new calendar set",
                          style: GoogleFonts.titilliumWeb(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FilledButton(
                        onPressed: () async {
                          if (await canLaunchUrl(Uri.parse("http://calendar.google.com"))) {
                            await launchUrl(Uri.parse("https://calendar.google.com"));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error opening Google Calendar',
                              style: GoogleFonts.titilliumWeb(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                          );
                          }
                        }, 
                        child: Text("Open Google Calendar",
                          style: GoogleFonts.titilliumWeb(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 32,
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 800,
                        child: Image.asset(
                          "assets/loginInstruction.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: Navigator.of(context).pop, 
                          child: const Text(
                            "Close",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontFamily: 'Helvetica'
                            ),
                          )
                        )
                      ],
                    );
                  }
                );
              }, 
              icon: const Icon(Icons.info)
            ),
          )
        ]
      ),  
    )
  );
  }
}