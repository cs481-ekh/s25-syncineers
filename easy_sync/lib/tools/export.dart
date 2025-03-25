import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart' as file_saver;
import 'package:flutter/material.dart';
import 'package:web/web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Export extends StatefulWidget {
  const Export({super.key});

  @override
  State<Export> createState() => _ExportState();
}

class _ExportState extends State<Export> {
  // TextEditingController fileNameController = TextEditingController();
  // // TextEditingController linkController = TextEditingController(
  // //     text: "https://i.pinimg.com/564x/80/d4/90/80d490f65d5e6132b2a6e3b5883785f3.jpg");
  // TextEditingController extController = TextEditingController(text: "jpg");

  @override
  void initState() {
    super.initState();
  }

  List<int>? getExcel() {
    final Excel excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet1'];
    sheetObject.insertColumn(0);
    for (int i = 1; i < 10; i++) {
      sheetObject.appendRow([TextCellValue(i.toString())]);
    }
    List<int>? sheets = excel.encode();
    return sheets;
  }

    Future<void> _exportFile() async {
    List<int>? fileBytes = getExcel();
    if (fileBytes != null) {
      Uint8List uint8List = Uint8List.fromList(fileBytes);
      await FileSaver.instance.saveFile(
        name: "exported_file",
        bytes: uint8List,
        ext: "xlsx",
        mimeType: file_saver.MimeType.MICROSOFTEXCEL,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            // TextField(
            //   controller: fileNameController,
            //   decoration: InputDecoration(
            //     labelText: 'File Name',
            //   ),
            // ),
            // TextField(
            //   controller: extController,
            //   decoration: InputDecoration(
            //     labelText: 'File Extension',
            //   ),
            // ),
            // const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportFile,
              child: const Text('Export File'),
            ),
          ],
        );
  }
}