
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? filePath;
  String? fileContents;

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['csv', 'xls', 'xlsx']
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
      });
      if (result.files.single.bytes != null) {
        String contents = utf8.decode(result.files.single.bytes!);
        print(contents);
        fileContents = contents;
      }
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
        SizedBox(
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'File Contents:\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              Expanded( // Ensures SingleChildScrollView takes available space
                child: Container(
                  child: SingleChildScrollView(
                    child: Text(
                      fileContents ?? 'No File Selected',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ],
    );
  }
}