
import 'dart:convert';

import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? filePath;
  List<List<String>> rows = [[]];
  List<String> columnNames = [];

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
        rows = parseCSV(contents);
      }
    }
  }

  List<List<String>> parseCSV(String fileContents) {
    List<List<String>> rows = fileContents.trim().split('\n').map((line) => line.split(',')).toList();
    columnNames = rows[0];
    print("\n$columnNames");
    return rows;
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
              if (rows.isNotEmpty)
              Container(
                  child: SingleChildScrollView(
                    child: Text(
                      rows[0].toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Frame(title: 'edit', child: EditPage(rows))));
                }, 
                child: const Text("Edit data")
              )
            ],
          )
        ),
      ],
    );
  }
}