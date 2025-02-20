import 'package:flutter/material.dart';

class Frame extends StatefulWidget {
  final Widget child;
  final String title;

  const Frame({super.key, required this.title, required this.child});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // actions: [
        //   IconButton(
        //     onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
        //     icon: const Icon(Icons.home),
        //   ),
        // ],
      ),
      //used to display add button throughout all pages
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/input'),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/edit'),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
   );
  }
}