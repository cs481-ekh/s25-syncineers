import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'settings_provider.dart';


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
      // _prefs.setUserCalendarSets(calendarList.items?.toString());

      print('Calendar List:'); 
      for (var item in calendarList.items ?? []) {
        print('${item.summary} (${item.id})');
        calendarIds.add(item.id!);
      }

      _prefs.setUserCalendarSets(calendarIds);

      final calendarOut = await _prefs.getCalendarList();
      print('calendar type: ${calendarOut.runtimeType}');

      client.close();
    } catch (e) {
      print('Failed to get calendar list: $e');

    
    }
  }

  void createEvent(GoogleSignInAccount currentUser) async {
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
      summary: 'New Event',
      description: 'A new event created from Flutter app',
      start: calendar.EventDateTime(
        dateTime: DateTime.now(),
        timeZone: 'GMT-7:00',
      ),
      end: calendar.EventDateTime(
        dateTime: DateTime.now().add(Duration(hours: 1)),
        timeZone: 'GMT-7:00',
      ),
    );

    final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);
    final String calendarId = 'primary'; // Use 'primary' for the primary calendar
    await calendarApi.events.insert(event, calendarId);

    print('Event created: ${event.summary}');

      client.close();
    } catch (e) {
      print('Failed to create event: $e');
    }
  }
 