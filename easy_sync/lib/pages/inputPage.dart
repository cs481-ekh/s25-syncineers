
import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? fileName;
  String? fileExtension;
  List<List<String>> rows = [[]];
  List<String> columnNames = [];

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['csv', 'xls', 'xlsx']
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });

      Uint8List? fileBytes = result.files.single.bytes;
      
      if (fileBytes != null) {
        if (fileName!.endsWith('.csv')) {
          fileExtension = '.csv';
          String contents = utf8.decode(fileBytes);
          rows = parseCSV(contents);
        } else if (fileName!.endsWith('.xls')) {
          fileExtension = '.xls';
          String contents = utf8.decode(fileBytes);
          rows = parseXLS(contents);
        } else if (fileName!.endsWith('.xlsx')) {
          fileExtension = '.xlsx';
          rows = parseXLSX(fileBytes);
        }
      }
    }
  }

  // Parse CSV files
  List<List<String>> parseCSV(String fileContents) {
    List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContents);
    List<List<String>> rows = csvData.map((row) => row.map((e) => e.toString()).toList()).toList();
    columnNames = rows[0];
    print("\n$columnNames");
    return rows;
  }

  // Parse XLSX Files
  List<List<String>> parseXLSX(Uint8List bytes) {
    List<List<String>> data = [];

    if (fileName!.endsWith('.xlsx')) {
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

  // Parse XLS files
  List<List<String>> parseXLS(String fileContents) {
    List<List<String>> rows = fileContents.trim().split('\n').map((line) => line.trim().split('\t')).toList();
    columnNames = rows[0];
    print("\n$columnNames");
    return rows;
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
          if (fileName != null)
          SizedBox(
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'File uploaded: $fileName',
                  textAlign: TextAlign.center,
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