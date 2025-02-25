import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:http/src/client.dart';


class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}
class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/calendar',
    ],
  );
  GoogleSignInAccount? _currentUser;
  @override
  void initState() {
    super.initState();
    // Listen for changes to the current user.
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    // Attempt to sign in silently upon app start.
    _googleSignIn.signInSilently();
  }
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // You can now use _currentUser to access user details.
    } catch (error) {
      print('Sign in failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: $error'),
        ),
      );
    }
  }
  Future<void> _handleSignOut() => _googleSignIn.disconnect();
  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return Column(
        children: [
          ListTile(
           // leading: GoogleUserCircleAvatar(identity: _currentUser!),
            title: Text(_currentUser!.displayName ?? ''),
            subtitle: Text(_currentUser!.email),
          ),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: getCalendarList,
            child: Text('Get Calendar List'),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: (
          _handleSignIn

          ),
        child: Text('Sign in with Google'),
      );
    }
  }

  Future<void> getCalendarList() async {
    if (_currentUser == null) {
      print("User not signed in");
      return;
    }
    
    try {
      final GoogleSignInAuthentication googleAuth = await _currentUser!.authentication;

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

      print('Calendar List:'); 
      for (var item in calendarList.items ?? []) {
        print('${item.summary} (${item.id})');
      }
      client.close();
    } catch (e) {
      print('Failed to get calendar list: $e');

    
    }
  }
  
}