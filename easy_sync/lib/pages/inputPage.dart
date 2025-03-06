
import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:excel/excel.dart';
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
        filePath = result.files.single.name;
      });

      Uint8List? fileBytes = result.files.single.bytes;
      
      if (fileBytes != null) {
        if (filePath!.endsWith('.csv')) {
          String contents = utf8.decode(fileBytes);
          rows = parseCSV(contents);
        } else if (filePath!.endsWith('.xls')) {
          rows = [["IMPORTING XLS FILES UNSUPPORTED AT THIS TIME. XLSX FILES SUPPORTED"]];
          print("\nAction unsupported at this time.\n");
        } else if (filePath!.endsWith('.xlsx')) {
          rows = parseExcel(fileBytes);
        }
      }
    }
  }

  List<List<String>> parseCSV(String fileContents) {
    List<List<String>> rows = fileContents.trim().split('\n').map((line) => line.split(',')).toList();
    columnNames = rows[0];
    print("\n$columnNames");
    return rows;
  }

  List<List<String>> parseExcel(Uint8List bytes) {
    var excel = Excel.decodeBytes(bytes);
    List<List<String>> data = [];

    if (filePath!.endsWith('.xlsx')) {
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        data.add(row.map((cell) => cell?.value.toString() ?? "").toList());
      }
      break; // Only read the first sheet
    }
  } 
    columnNames = data.isNotEmpty ? data[0] : [];
    return data;
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                SingleChildScrollView(
                  child: Text(
                    rows.map((row) => row.join(', ')).join('\n'),
                    style: const TextStyle(fontSize: 14),
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
      ),
    );
  }
}