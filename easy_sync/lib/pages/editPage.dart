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
  String key;
  String question;
  List<int> answerIndices;

  QuestionAndAnswers(this.key, this.question) : answerIndices = [];
}

class _EditPageState extends State<EditPage> {
  int questionIndex = 0;

  List<QuestionAndAnswers> questions = [
    QuestionAndAnswers("summaryColumns", "How is each event title constructed"),
    QuestionAndAnswers("locationColumns", "Where is the Location"),
    QuestionAndAnswers("", "Which column contains the first day"),
    QuestionAndAnswers("", "Which column contains the last day"),
    QuestionAndAnswers("startTimeColumns", "Which column contains the start time"),
    QuestionAndAnswers("endTimeColumns", "Which column contains the end time"),
    QuestionAndAnswers(
        "recurrenceColumns", "Which column contains which days of the week are repeated"),
  ];

  @override
  Widget build(BuildContext context) {
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
                questionAndAnswerIndices: questions[questionIndex],
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

  List<List<String>> getMeetingDays(int columnIndex) {
    List<List<String>> recurringDaysRows = [[]];

    for (int i = 0; i < information.length; i++) { // For each row/class
      List<String> daysForRow = [];

      if (columnIndex < information[i].length) {
        String cellData = information[i][columnIndex];
        if (cellData != "") {
          List<String> parts = cellData.split(RegExp(r'[,\s/]')).map((e) => e.trim()).toList();
          daysForRow.addAll(parts.where((day) => day.isNotEmpty));
          recurringDaysRows.add(daysForRow);
        } else {
          recurringDaysRows.add([]);
        }
      }
    }
    return recurringDaysRows;
  }

  List<String> getStartAndEndDate(int i, int columnIndex) {
    List<String> dates = information[i][columnIndex].trim().split('-');

    String startDate = dates[0];
    List<String> dateParts = startDate.trim().split('/');

    String startMonth = dateParts[0];
    String startDay = dateParts[1];
    String startYear = dateParts[2];

    String endDate = dates[1];
    dateParts = endDate.trim().split('/');

    String endMonth = dateParts[0];
    String endDay = dateParts[1];
    String endYear = dateParts[2];

    print("$startYear-$startMonth-$startDay, $endYear-$endMonth-$endDay");

    return ["$startYear-$startMonth-$startDay", "$endYear-$endMonth-$endDay"];
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
