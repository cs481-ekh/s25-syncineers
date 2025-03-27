import 'package:easy_sync/tools/event_struct.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  late final Dataset table;

  EditPage(List<List<String>> table, {super.key}) {
    this.table = Dataset(table);
  }

  @override
  _EditPageState createState() => _EditPageState();
}

class QuestionAndAnswers {
  String question;
  List<int> answerIndices;

  QuestionAndAnswers(this.question) : answerIndices = [];
}

class _EditPageState extends State<EditPage> {
  int questionIndex = 0;

  Map<String,QuestionAndAnswers> questions = {
    "summary" : QuestionAndAnswers("How is each event title constructed"),
    "location" : QuestionAndAnswers("Where is the Location"),
    "first day" : QuestionAndAnswers("Which column contains the first day"),
    "last day" : QuestionAndAnswers("Which column contains the last day"),
    "startTime" : QuestionAndAnswers("Which column contains the start time"),
    "endTime" : QuestionAndAnswers("Which column contains the end time"),
    "recurrenceRules" : QuestionAndAnswers("Which column contains which days of the week are repeated"),
  };

  late List<String> questionKeys;

  @override
  Widget build(BuildContext context) {
    questionKeys = questions.keys.toList();

    if (questionIndex < 0) {
      questionIndex = 0;
    }

    if (questionIndex >= questions.length) {
      return const Text(
          "TODO build page to allow the user to review the decisions made, restart to the beginning or go back to the previous question if needed, but if they are happy allow them to move on to the next page which will ask which calendars locations go to.");
    } else {
      return Frame(
        title: "Edit Page",
        onNextPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        child: Column(
          children: [
            Expanded(
              child: QuestionWidget(
                questionAndAnswerIndices: questions[questionKeys[questionIndex]],
                selectableAnswers: widget.table,
                callBackFunction: () {
                  setState(() {});
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          questionIndex--;
                        });
                      },
                      child: const Text("Previous question")),
                ),
                Expanded(
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          questionIndex++;
                        });
                      },
                      child: const Text("Next question")),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class Dataset {
  List<List<String>> information;
  int exampleIndex = 1;

  Dataset(this.information);

  int numColumns() {
    if (information.isEmpty) {
      return 0;
    }

    return information[0].length;
  }

  List<String> getColumnsFromRow(int row, List<int> columns) {
    return [];// TODO fixme
  }

  List<EventStruct> getEvents(Map<String, QuestionAndAnswers> input) {
    List<EventStruct> output = [];

    for (var i = 1; i < information.length; i++) {
      output.add(EventStruct(
        summary: parseSummary(getColumnsFromRow(i, input["summary"]!.answerIndices)),
        description: parseDescription(getColumnsFromRow(i, input["description"]!.answerIndices)),
        location: parseLocation(getColumnsFromRow(i, input["location"]!.answerIndices)),
        startTime: parseStartTime(getColumnsFromRow(i, input["startTime"]!.answerIndices)),
        endTime: parseEndTime(getColumnsFromRow(i, input["endTime"]!.answerIndices)),
        timezone: parseTimezone(getColumnsFromRow(i, input["timezone"]!.answerIndices)),
        recurrenceRules: parseRecurrenceRules(getColumnsFromRow(i, input["recurrenceRules"]!.answerIndices)),
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

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.questionAndAnswerIndices,
    required this.selectableAnswers,
    required this.callBackFunction,
  });

  final Function() callBackFunction;
  final QuestionAndAnswers questionAndAnswerIndices;
  final Dataset selectableAnswers;

  final Color cardShade = const Color.fromARGB(1, 126, 126, 126);

  @override
  Widget build(BuildContext context) {
    String example = "";
    for (var index in questionAndAnswerIndices.answerIndices) {
      example += "${selectableAnswers.getExample(index)} ";
    }

    return Card(
      child: Column(
        children: [
          Text(questionAndAnswerIndices.question),
          Row(
            children: [
              FilledButton(
                  onPressed: () {
                    selectableAnswers.previousExample();
                    callBackFunction();
                  },
                  child: const Text("Previous example")),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Example output: $example"),
              )),
              FilledButton(
                  onPressed: () {
                    callBackFunction();
                    selectableAnswers.nextExample();
                  },
                  child: const Text("Next example")),
            ],
          ),
          Expanded(
            child: Card(
              color: cardShade,
              child: ListView.builder(
                  itemCount: questionAndAnswerIndices.answerIndices.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(selectableAnswers.getTitle(
                            questionAndAnswerIndices.answerIndices[index])),
                        onTap: () async {
                          questionAndAnswerIndices.answerIndices
                              .removeAt(index);
                          callBackFunction();
                        });
                  }),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              color: cardShade,
              child: ListView.builder(
                  itemCount: selectableAnswers.numColumns(),
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                            "${selectableAnswers.getTitle(index)} | ${selectableAnswers.getExample(index)}"),
                        onTap: () async {
                          questionAndAnswerIndices.answerIndices.add(index);
                          callBackFunction();
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}


String parseSummary(List<String> input) {
  // TODO fixme
  return "fixme";
}

String parseDescription(List<String> input) {
  // TODO fixme
  return "fixme";
}

String parseLocation(List<String> input) {
  // TODO fixme
  return "fixme";
}

String parseStartTime(List<String> input) {
  // TODO fixme
  return "fixme";
}

String parseEndTime(List<String> input) {
  // TODO fixme
  return "fixme";
}

String parseTimezone(List<String> input) {
  // TODO fixme
  return "fixme";
}

List<String> parseRecurrenceRules(List<String> input) {
  // TODO fixme
  return ["fixme"];
}
