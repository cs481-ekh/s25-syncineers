import 'package:easy_sync/pages/inputPage.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Frame(
      title: "Landing",
      onNextPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InputPage())),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 175,
            ),
            Text(
              "EasySync",
              style: GoogleFonts.titilliumWeb(
                color: Colors.green,
                fontSize: 72,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Text(
              "The Google Calendar uploader"
            ),
            const SizedBox(height: 25,),
            const Text(
              "This program takes in CSV, XLS, and XLSX files and parses their data, then uploading it to Google Calendar"
            ),
            const SizedBox(height: 100,),
            Tooltip(
              message: "This website was created for a\n"
                      "Boise State University\n" 
                      "Computer Science Senior Design Project by\n" 
                      "Aidan Flinn\n" 
                      "Ethan Barnes\n" 
                      "Tyler Pierce\n" 
                      "For information about sponsoring a project go to\n" 
                      "https://www.boisestate.edu/coen-cs/community/cs481-senior-design-project",
              child: Image.asset(
                "assets/sdp-logo.png",
                width: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}