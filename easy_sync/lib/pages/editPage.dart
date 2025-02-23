import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: Card(
        color: theme.colorScheme.primary,
        child: Column(
          children: [
            Text("Some question statement"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Answer1"),
                Text("Answer2"),
                Text("Answer1"),
                Text("Answer4"),
              ],
            ),
            Column(
              children: [
                Text("Selectable 1"),
                Text("Selectable 2"),
                Text("Selectable 3"),
                Text("Selectable 4"),
                Text("Selectable 5"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
