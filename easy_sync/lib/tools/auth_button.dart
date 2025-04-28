import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'settings_provider.dart';


class GoogleSignInButton extends StatefulWidget {

  final Function(GoogleSignInAccount?) onSignIn;

  const GoogleSignInButton({super.key, required this.onSignIn});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}
class _GoogleSignInButtonState extends State<GoogleSignInButton> {

  final SharedPreferencesManager _prefs = SharedPreferencesManager();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
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
        
        if (account != null) {
          _prefs.setUser(account);
        } else {
        // If account is null, clear the user data
          _prefs.clearUser();
        }
        widget.onSignIn(_currentUser);
      });
    });
  }
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
        widget.onSignIn(_currentUser);
    } catch (error) {
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
          FilledButton(
            onPressed: _handleSignOut,
            child: Text('Sign Out',
              style: GoogleFonts.titilliumWeb(
                color: Colors.white,
                fontSize: 16,
              )
            )
          ),
        ],
      );
    } else {
      return FilledButton(
        onPressed: (
          _handleSignIn
          ),
        child: Text('Sign in with Google',
          style: GoogleFonts.titilliumWeb(
            color: Colors.white,
            fontSize: 16,
          )
        )
      );
    }
  }
 
}