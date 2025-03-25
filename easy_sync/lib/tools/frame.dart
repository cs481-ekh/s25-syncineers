import 'package:flutter/material.dart';

class Frame extends StatefulWidget {
  final Widget child;
  final String title;
  final VoidCallback? onNextPressed;
  final Color? nextColor;
  final Color? prevColor;


  const Frame({
    super.key,
    required this.title,
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
      appBar: AppBar(
        title: Text(widget.title),
  
      ),
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
                  child: const Text('Previous Page'),
                ),
                ElevatedButton(
                  onPressed: widget.onNextPressed, // Use the callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.nextColor,
                  ),
                  child: const Text('Next Page'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}