import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  late Dataset table;
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String? fileName;
  String? fileExtension;
  bool useDefaults = true;
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

      widget.table = Dataset(rows);
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
    // List<List<String>> rows = fileContents.trim().split('\n').map((line) => line.trim().split('\t')).toList();

    List<List<String>> rows = fileContents.trim().split('\n').map((line) {
      return line.trim().split('\t').map((cell) {
        // try to parse cell as a double
        if (double.tryParse(cell) != null) { // Cell is a double value
          double doubleValue = double.parse(cell);
          return doubleValue == doubleValue.toInt() ? doubleValue.toInt().toString() : doubleValue.toString(); // If there are only zeroes after the decimal, they are removed, otherwise they are kept
        }
        return cell; // Cell is not a double value
      }).toList();
    }).toList(); 
    columnNames = rows[0];
    print("\n$columnNames");
    return rows;
  } 

  @override
  Widget build(BuildContext context) {
    final Map<String, QuestionAndAnswers> questions = {
      "summary": QuestionAndAnswers.withAnswers("How is each event title constructed", [0, 1, 7, 2]),
      "catalog number": QuestionAndAnswers.withAnswers("What is the catalog number", [1]),
      "location": QuestionAndAnswers.withAnswers("Where is the event Located", [19]),
      "description": QuestionAndAnswers.withAnswers("While not needed. If you want to add a description, then you can build one here.", []),
      "first day" : QuestionAndAnswers.withAnswers("Which column contains the first day", [14]),
      "last day" : QuestionAndAnswers.withAnswers("Which column contains the last day", [14]),
      "startTime" : QuestionAndAnswers.withAnswers("Which column contains the start time", [16]), 
      "endTime" : QuestionAndAnswers.withAnswers("Which column contains the end time", [16]),
      "recurrenceRules" : QuestionAndAnswers.withAnswers("Which column contains which days of the week are repeated", [16]),
    };

    return Frame(
      // title: 'Input',
      onNextPressed: () {
        if (fileName != null) {
          if (useDefaults) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(widget.table.getEvents(questions))));
          } else {
            questions.forEach((key, value) {value.resetAnswers();});
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(table: widget.table, questions: questions)));
          }
        } else {
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Missing File'),
                content: const Text('Please upload a file before continuing'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // User cancels
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            }
          );
        }
      },
      // prevColor: Colors.grey,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (fileName != null) const SizedBox(height: 50,),
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
                      const SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: useDefaults, 
                            onChanged: (bool? value) {
                              setState(() {
                                useDefaults = value!;
                              });
                              print("Use defaults: $useDefaults");
                            }
                          ),
                          const Text("Use defaults")
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 800,
                        child: Image.asset(
                          "assets/Instruction1.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: Navigator.of(context).pop, 
                          child: const Text(
                            "Close",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontFamily: 'Helvetica'
                            ),
                          )
                        )
                      ],
                    );
                  }
                );
              }, 
              icon: const Icon(Icons.info)
            ),
          )
        ]
      ),
    );
  }
}