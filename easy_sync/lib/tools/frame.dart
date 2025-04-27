import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Frame extends StatefulWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onNextPressed;
  final Color? nextColor;
  final Color? prevColor;


  const Frame({
    super.key,
    this.title,
    required this.child,
    this.onNextPressed,
    this.nextColor = Colors.blue,
    this.prevColor = Colors.blue,
  });

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title ?? ""),
      // ),
      //used to display add button throughout all pages
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60, 
            color: Colors.grey[200], 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: Navigator.canPop(context) ? () => Navigator.pop(context) : null, // Use the callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.prevColor,
                  ),
                  child: Text(
                    'Previous Page',
                    style: GoogleFonts.titilliumWeb(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  key: const Key('next_button'),
                  onPressed: widget.onNextPressed, // Use the callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.nextColor,
                  ),
                  child: Text(
                    'Next Page',
                    style: GoogleFonts.titilliumWeb(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}