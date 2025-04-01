import 'package:easy_sync/pages/loginPage.dart';
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

class _EditPageState extends State<EditPage> {
  final Map<String, QuestionAndAnswers> questions = {
    // "summary": QuestionAndAnswers("How is each event title constructed"),
    "location": QuestionAndAnswers("Where is the event Located"),
    "description": QuestionAndAnswers("While not needed. If you want to add a description, then you can build one here."),
    "first day" : QuestionAndAnswers("Which column contains the first day"),
    // "last day" : QuestionAndAnswers("Which column contains the last day"),
    "startTime" : QuestionAndAnswers("Which column contains the start time"), 
    // "endTime" : QuestionAndAnswers("Which column contains the end time"),
    // "recurrenceRules" : QuestionAndAnswers("Which column contains which days of the week are repeated"),
  };
  int questionIndex = 0;
  late List<String> questionKeys = questions.keys.toList();

  @override
  Widget build(BuildContext context) {
    if (questionIndex < 0) {
      questionIndex = 0;
    }

    return Frame(
      title: "Edit Page",
      onNextPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage(widget.table.getEvents(questions))));
      },
      child: (questionIndex >= questions.length)
          ? questionsComplete()
          : askCurrentQuestion(),
    );
  }

  Column askCurrentQuestion() {
    return Column(
      children: [
        Expanded(
          child: QuestionWidget(
            questionAndAnswerIndices: questions[questionKeys[questionIndex]]!,
            selectableAnswers: widget.table,
            callBackFunction: () {
              setState(() {});
            },
          ),
        ),
        Row(
          children: [
            previousQuestion(),
            nextQuestion(),
          ],
        ),
      ],
    );
  }

  Expanded nextQuestion() {
    return Expanded(
      child: FilledButton(
          onPressed: () {
            setState(() {
              questionIndex++;
            });
          },
          child: const Text("Next question")),
    );
  }

  Expanded previousQuestion() {
    return Expanded(
      child: FilledButton(
          onPressed: () {
            setState(() {
              questionIndex--;
            });
          },
          child: const Text("Previous question")),
    );
  }

  Column questionsComplete() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton(
                  onPressed: () {
                    setState(() {
                      questionIndex = 0;
                    });
                  },
                  child: const Text("First question")),
            ),
            Expanded(
              child: FilledButton(
                  onPressed: () {
                    setState(() {
                      questionIndex = questions.length - 1;
                    });
                  },
                  child: const Text("Previous question")),
            ),
          ],
        ),
        const Expanded(
            child: Text(
                "That was the last question. You can move on to the next page.")),
      ],
    );
  }
}

class QuestionAndAnswers {
  String question;
  List<int> answerIndices;

  QuestionAndAnswers(this.question) : answerIndices = [];
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
        summary: parseSummary([]),
        description: parseDescription(answers["description"]!),
        location: parseLocation(answers["location"]!),
        startTime: parseStartTime([answers["first day"]!, answers["startTime"]!]),
        endTime: parseEndTime([]),
        timezone: parseTimezone([]),
        recurrenceRules: parseRecurrenceRules([]),
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
    String example = questionAndAnswerIndices.answerIndices
        .map((index) => selectableAnswers.getExample(index))
        .join(" ");

    return Card(
      child: Column(
        children: [
          Text(questionAndAnswerIndices.question),
          Row(
            children: [
              previousExampleButton(),
              exampleText(example),
              nextExampleButton(),
            ],
          ),
          selectedAnswersWidget(),
          selectableAnswersWidget(),
        ],
      ),
    );
  }

  Expanded selectableAnswersWidget() {
    var flex = 2;
    var numColumns = selectableAnswers.numColumns();

    someText(index) => Text(
        "${selectableAnswers.getTitle(index)} | ${selectableAnswers.getExample(index)}");
    someAction(index) => questionAndAnswerIndices.answerIndices.add(index);

    return interactiveList(flex, numColumns, someText, someAction);
  }

  Expanded selectedAnswersWidget() {
    var flex = 1;
    var numColumns = questionAndAnswerIndices.answerIndices.length;

    someText(index) => Text(selectableAnswers
        .getTitle(questionAndAnswerIndices.answerIndices[index]));
    someAction(index) => questionAndAnswerIndices.answerIndices.removeAt(index);

    return interactiveList(flex, numColumns, someText, someAction);
  }

  Expanded interactiveList(int flexPower, int numColumns,
      Text Function(int) someText, void Function(int) someAction) {
    return Expanded(
      flex: flexPower,
      child: Card(
        color: cardShade,
        child: ListView.builder(
            itemCount: numColumns,
            itemBuilder: (context, index) {
              return ListTile(
                  title: someText(index),
                  onTap: () async {
                    someAction(index);
                    callBackFunction();
                  });
            }),
      ),
    );
  }

  FilledButton nextExampleButton() {
    return FilledButton(
        onPressed: () {
          callBackFunction();
          selectableAnswers.nextExample();
        },
        child: const Text("Next example"));
  }

  Expanded exampleText(String example) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Example output: $example"),
    ));
  }

  FilledButton previousExampleButton() {
    return FilledButton(
        onPressed: () {
          selectableAnswers.previousExample();
          callBackFunction();
        },
        child: const Text("Previous example"));
  }
}

String parseSummary(List<String> input) {
  // TODO fixme
  return "fixme";
}

String parseDescription(List<String> input) {
  return input.join(" ");
}

String parseLocation(List<String> input) {
  String output = input.isEmpty ? "no location given" : input.join(" ").trim();
  output = (output == "") ? "no location given" : output;
  print("output: $output");
  return output;
}

String parseStartTime(List<List<String>> input) {
  if (input.isEmpty) {
    return "";
  }
  String date = parseStartDate(input[0]);
  String output = "${date}T";

  if (input[1][0] == "") {
    return output;
  }
  List<String> timeStrings = input[1][0].trim().split('-').toList();
  String startTimeFull = timeStrings[0];
  List<String> timeParts = startTimeFull.trim().split(' ').toList();
  String startTimeShort = timeParts[0];
  String mornAft = timeParts[1];

  List<String> startTimeParts = startTimeShort.trim().split(':').toList();
  int hourInt = int.parse(startTimeParts[0]);
  String minute = startTimeParts[1];

  bool afternoon = mornAft == "pm";

  if (afternoon) {
    hourInt += 12;
  }
  String hour = "$hourInt";
  if (hourInt < 10) {
    hour = "0$hour";
  }

  output += "$hour:$minute";

  print("output: $output");
  return output;
}

String parseStartDate(List<String> input) {
  List<String> dates = input[0].trim().split('-');

  String startDate = dates[0];
  List<String> dateParts = startDate.trim().split('/').toList();

  String startMonth = dateParts[0];
  String startDay = dateParts[1];
  String startYear = dateParts[2];
  return "$startYear-$startMonth-$startDay";
}

// List<List<String>> getMeetingDays(int columnIndex) {
//     List<List<String>> recurringDaysRows = [[]];

//     for (int i = 0; i < information.length; i++) { // For each row/class
//       List<String> daysForRow = [];

//       if (columnIndex < information[i].length) {
//         String cellData = information[i][columnIndex];
//         if (cellData != "") {
//           List<String> parts = cellData.split(RegExp(r'[,\s/]')).map((e) => e.trim()).toList();
//           daysForRow.addAll(parts.where((day) => day.isNotEmpty));
//           recurringDaysRows.add(daysForRow);
//         } else {
//           recurringDaysRows.add([]);
//         }
//       }
//     }
//     return recurringDaysRows;
//   }

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
