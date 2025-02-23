import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class InputPage extends StatelessWidget {

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['.csv', '.xlsx']);

    if (result != null) {
      File file = File(result.files.first.path!);
    }
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: getFile, 
          icon: const Icon(Icons.file_open))
      ],
    );
  }
}