import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:http/src/client.dart';
import 'calendar_tools.dart';
import 'settings_provider.dart';


class GoogleSignInButton extends StatefulWidget {

  final Function(GoogleSignInAccount?) onSignIn;

  const GoogleSignInButton({super.key, required this.onSignIn});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}
class _GoogleSignInButtonState extends State<GoogleSignInButton> {

  final SharedPreferencesManager _prefs = SharedPreferencesManager();

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
       // print('Current user in auth button: $_currentUser');
        _prefs.setUser(_currentUser);
       // if(_currentUser != null) {
          widget.onSignIn(_currentUser);
      //  }
      });
    });
    // Attempt to sign in silently upon app start.
  //  _googleSignIn.signInSilently();
  }
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // You can now use _currentUser to access user details.
     // if (_currentUser != null) {
        widget.onSignIn(_currentUser);
    //  }
    } catch (error) {
      print('Sign in failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: $error'),
        ),
      );
    }
  }
  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    await _prefs.clearUser();
    widget.onSignIn(null);
  }


  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ListTile(
              leading: GoogleUserCircleAvatar(identity: _currentUser!),
              title: Text(_currentUser!.displayName ?? ''),
              subtitle: Text(_currentUser!.email),
            ),
          ),
          ElevatedButton(
            onPressed: _handleSignOut, //need to update shared prefs 
            child: const Text('Sign Out'),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: (
          _handleSignIn
          ),
        child: const Text('Sign in with Google'),
      );
    }
  }
 
}