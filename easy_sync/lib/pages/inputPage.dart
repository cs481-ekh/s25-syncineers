import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class InputPage extends StatefulWidget {
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? filePath;

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['csv', 'xls', 'xlsx']
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
      });
    }
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: getFile, 
          icon: const Icon(Icons.file_open, color: Colors.blue, size: 100.0),
        ),
        const SizedBox(height: 20,),
        if (filePath != null)
          Text(
            'Selected file:\n${filePath!}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blue
            ),
          )
      ],
    );
  }
}