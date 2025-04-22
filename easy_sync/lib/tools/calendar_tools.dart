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
      // _prefs.setUserCalendarSets(calendarList.items?.toString());

      for (var item in calendarList.items ?? []) {
        calendarSummaries.add(item.summary!);
        calendarIds.add(item.id!);
      }

      _prefs.setUserCalendarSets(calendarIds,calendarSummaries);

      // final calendarOut = await _prefs.getCalendarList();
      // print('calendar type: ${calendarOut.runtimeType}');

      client.close();
    } catch (e) {
      print('Failed to get calendar list: $e');

    
    }
  }

  void createEvent(GoogleSignInAccount currentUser, String calendarId, EventStruct details) async {
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

    final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);
   // const String calendarId = 'c_27cf9ebd1940281735b50fe02d1e3cb2e722d537fe981b4304582abb27563bd1@group.calendar.google.com'; 
    await calendarApi.events.insert(event, calendarId);

    client.close();
    } catch (e) {
      print('Failed to create event: $e event:$details');
    }
  }

  void createMultipleEvents(GoogleSignInAccount currentUser, String calendarId, List<EventStruct> events) async {
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

       // await calendarApi.events.insert(event, calendarId);
        createEvent(currentUser, calendarId, val);
        print('Event added: ${event.summary}');

        await Future.delayed(const Duration(milliseconds: 270)); // Adjust delay as needed
      }

      client.close();
    } catch (e) {
      print('Failed to create events: $e');
    }
  }

  void addCalendarToList(GoogleSignInAccount currentUser, String calendarName) async {
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

      print('Created new calendar with ID: ${createdCalendar.id}');

      client.close();
    } catch (e) {
      print('Failed to add calendar to list: $e');
    }
  }