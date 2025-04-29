import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'settings_provider.dart';
import 'event_struct.dart';


  final SharedPreferencesManager _prefs = SharedPreferencesManager();

  Future<void> getCalendarList(GoogleSignInAccount currentUser) async {
    
    try {
      final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

      final auth.AccessCredentials credentials = auth.AccessCredentials(
        auth.AccessToken("Bearer", googleAuth.accessToken!, DateTime.now().toUtc()),
        googleAuth.idToken,
        ['https://www.googleapis.com/auth/calendar'],
      );

      final auth.AuthClient client = auth.authenticatedClient(
        http.Client(),
        credentials,
      );

      final calendar.CalendarList calendarList = await calendar.CalendarApi(client).calendarList.list();

      List<String> calendarIds = [];
      List<String> calendarSummaries = [];

      for (var item in calendarList.items ?? []) {
        calendarSummaries.add(item.summary!);
        calendarIds.add(item.id!);
      }

      // combine names and IDs into collection, making sure the names and IDs are in the same order
      List<MapEntry<String, String>> combinedList = [];
      for (int i = 0; i < calendarSummaries.length; i++) {
        combinedList.add(MapEntry(calendarSummaries[i], calendarIds[i]));
      }

      // sort the lists alphabetically
      combinedList.sort((a, b) => a.key.compareTo(b.key));

      // back to lists
      calendarSummaries = combinedList.map((entry) => entry.key).toList();
      calendarIds = combinedList.map((entry) => entry.value).toList();

      // save the sorted lists
      _prefs.setUserCalendarSets(calendarIds,calendarSummaries);

      client.close();
    } catch (e) {
      print('Failed to get calendar list: $e');
    }
  }

  void createEvent(calendar.CalendarApi calendarApi, String calendarId, EventStruct details) async {
   try {

      // final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

      // final auth.AccessCredentials credentials = auth.AccessCredentials(
      //   auth.AccessToken("Bearer", googleAuth.accessToken!, DateTime.now().toUtc().add(const Duration(minutes: 30))), //DateTime.now().toUtc()),
      //   googleAuth.idToken,
      //   ['https://www.googleapis.com/auth/calendar'],
      // );

      // final auth.AuthClient client = auth.authenticatedClient(
      //   http.Client(),
      //   credentials,
      // );

      final calendar.Event event = calendar.Event(
      summary: details.summary,
      location: details.location,
      description: details.description,
      start: calendar.EventDateTime(
        dateTime: DateTime.parse(details.startTime),
        timeZone: details.timezone,
      ),
      end: calendar.EventDateTime(
        dateTime: DateTime.parse(details.endTime),
        timeZone: details.timezone,
      ),
      recurrence: details.recurrenceRules,
    );

   // final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);
    await calendarApi.events.insert(event, calendarId);

    // client.close();
    } catch (e) {
      print('Failed to create event: $e event:$details');
    }
  }

  void createMultipleEvents(GoogleSignInAccount currentUser, String calendarId, List<EventStruct> events, Function() startFunction, Function(int asdfl, int asdfkj) updateFunction, Function() endFunction) async {
    startFunction();
    
    try {
      final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

      final auth.AccessCredentials credentials = auth.AccessCredentials(
        auth.AccessToken("Bearer", googleAuth.accessToken!, DateTime.now().toUtc().add(const Duration(minutes: 30))), //DateTime.now().toUtc()),
        googleAuth.idToken,
        ['https://www.googleapis.com/auth/calendar'],
      );

      final auth.AuthClient client = auth.authenticatedClient(
        http.Client(),
        credentials,
      );

      final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);
      int eventCounter = 0;

      for (var val in events) {
        final calendar.Event event = calendar.Event(
          summary: val.summary,
          description: val.description,
          location: val.location,
          start: calendar.EventDateTime(
            dateTime: DateTime.parse(val.startTime),
            timeZone: val.timezone,
          ),
          end: calendar.EventDateTime(
            dateTime: DateTime.parse(val.endTime),
            timeZone: val.timezone,
          ),
          recurrence: val.recurrenceRules,
        );

        createEvent(calendarApi, calendarId, val);

        updateFunction(++eventCounter,events.length);

        await Future.delayed(const Duration(milliseconds: 270)); // Adjust delay as needed
      }

      client.close();
    } catch (e) {
      print('Failed to create events: $e');
    }

    endFunction();
  }

  Future<void> addCalendarToList(GoogleSignInAccount currentUser, String calendarName) async {
    try {
      final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

      final auth.AccessCredentials credentials = auth.AccessCredentials(
        auth.AccessToken("Bearer", googleAuth.accessToken!, DateTime.now().toUtc()),
        googleAuth.idToken,
        ['https://www.googleapis.com/auth/calendar'],
      );

      final auth.AuthClient client = auth.authenticatedClient(
        http.Client(),
        credentials,
      );

      final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);

      final newCalendar = calendar.Calendar(summary: calendarName);

      final createdCalendar = await calendarApi.calendars.insert(newCalendar);
    
      // save the updated list back to SharedPreferences
      await _prefs.addCalendarSetToList(calendarName, createdCalendar.id!);
      
      List<String> calendarNames = await _prefs.getCalendarListKey(); // retrieve the names list
      List<String> calendarIds = await _prefs.getCalendarIDList(); // retrieve the IDs list

      // combine names and IDs into collection, making sure the names and IDs are in the same order
      List<MapEntry<String, String>> combinedList = [];
      for (int i = 0; i < calendarNames.length; i++) {
        combinedList.add(MapEntry(calendarNames[i], calendarIds[i]));
      }

      // sort the lists alphabetically
      combinedList.sort((a, b) => a.key.compareTo(b.key));

      // back to lists
      calendarNames = combinedList.map((entry) => entry.key).toList();
      calendarIds = combinedList.map((entry) => entry.value).toList();

      // save the sorted lists
      await _prefs.setUserCalendarSets(calendarIds, calendarNames);


      client.close();
    } catch (e) {
      print('Failed to add calendar to list: $e');
    }
  }