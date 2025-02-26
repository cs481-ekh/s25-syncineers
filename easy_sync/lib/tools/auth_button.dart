import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:http/src/client.dart';
import 'calendar_tools.dart';


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
            onPressed: () async {
              if(_currentUser != null) {
                await getCalendarList(_currentUser!);
              }
              else {
                print('No user signed in');
              }
            },
            child: const Text('Get Calendar List'),
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
 
}