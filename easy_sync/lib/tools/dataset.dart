import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/event_struct.dart';
import 'package:easy_sync/tools/parsing_tools.dart';

class Dataset {
  List<List<String>> information;
  int exampleIndex = 1;
  final ParsingTools parser = ParsingTools();

  Dataset(this.information);

  int numColumns() {
    if (information.isEmpty) {
      return 0;
    }

    return information[0].length;
  }

  List<String> getColumnsFromRow(int row, List<int> columns) {
    List<String> output = [];

    for (var column in columns) {
      output.add(information[row][column]);
    }

    return output;
  }

  List<EventStruct> getEvents(Map<String, QuestionAndAnswers> input) {
    List<EventStruct> output = [];

    for (var i = 1; i < information.length; i++) {
      Map<String, List<String>> answers = input.map((key, value) =>
          MapEntry(key, getColumnsFromRow(i, value.answerIndices)));

      output.add(EventStruct(
        summary: parser.parseSummary(answers["summary"]!),
        description: parser.parseDescription(answers["description"]!),
        location: parser.parseLocation(answers["location"]!),
        startTime: parser.parseTime([answers["first day"]!, answers["startTime"]!, answers["recurrenceRules"]!], true),
        endTime: parser.parseTime([answers["first day"]!, answers["startTime"]!, answers["recurrenceRules"]!], false),
        timezone: parser.parseTimezone([]),
        recurrenceRules: parser.parseRecurrenceRules([answers["recurrenceRules"]!, answers["last day"]!]),
        isGraduateLevel: parser.parseGraduateLevel(answers["catalog number"]!),
      ));
    }

    return output;
  }

  String getTitle(int index) {
    if (information.isEmpty || index < 0 || index >= information[0].length) {
      return "";
    }

    return information[0][index];
  }

  String getExample(int index) {
    if (information.length <= exampleIndex ||
        index < 0 ||
        index >= information[exampleIndex].length) {
      return "";
    }

    return information[exampleIndex][index];
  }

  void nextExample() {
    if (information.isEmpty || information.length <= 2) {
      return;
    }
    exampleIndex++;
    if (exampleIndex >= information.length) {
      exampleIndex = 1;
    }
  }

  void previousExample() {
    if (information.isEmpty || information.length <= 2) {
      return;
    }
    exampleIndex--;
    if (exampleIndex < 1) {
      exampleIndex = information.length - 1;
    }
  }
}