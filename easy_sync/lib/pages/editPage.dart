import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:easy_sync/tools/event_struct.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/question_widget.dart';
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
    "summary": QuestionAndAnswers("How is each event title constructed"),
    "location": QuestionAndAnswers("Where is the event Located"),
    "description": QuestionAndAnswers("While not needed. If you want to add a description, then you can build one here."),
    "first day" : QuestionAndAnswers("Which column contains the first day"),
    "last day" : QuestionAndAnswers("Which column contains the last day"),
    "startTime" : QuestionAndAnswers("Which column contains the start time"), 
    "endTime" : QuestionAndAnswers("Which column contains the end time"),
    "recurrenceRules" : QuestionAndAnswers("Which column contains which days of the week are repeated"),
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

  QuestionAndAnswers.withAnswers(this.question, this.answerIndices);
}

String parseSummary(List<String> input) {
  String output = input.isEmpty ? "no title given" : input.join(" ").trim();
  output = (output == "") ? "no title given" : output;
  return output;
}

String parseDescription(List<String> input) {
  return input.join(" ");
}

String parseLocation(List<String> input) {
  String output = input.isEmpty ? "no location given" : input.join(" ").trim();
  output = (output == "") ? "no location given" : output;
  return output;
}

String parseTime(List<List<String>> input, bool start) {
  if (input.isEmpty) {
    return "";
  }
  String date = parseStartDate(input[0]);
  String output = "${date}T";

  if (input[1][0] == "") {
    //return output;
    return start ? "${output}00:00" : "${output}01:00"; // Default start and end time
  }

  List<String> timeList = input[1][0].trim().split('-').toList(); // [ "01:23 am" , "12:12 pm" ]
  if (start) { // Parse start time
    output += parseStartTime(timeList[0]); // output += parseStartTime("01:23 am")
  } else if (!start) { // Parse end time
    output += parseEndTime(timeList[1]); // output += parseEndTime("12:12 pm")
  }

  return output; // "12-25-2025T01:23"
}

String parseStartTime(String input) {

  if(input.isEmpty) {
    return "00:00"; // Default start time
  }

  List<String> timeParts = input.trim().split(' ').toList(); // [ "01:23" , "am" ]
  String timeShort = timeParts[0]; // "01:23"
  String mornAft = timeParts[1]; // "am"

  List<String> minHour = timeShort.trim().split(':').toList(); // [ "01" , "23" ]
  int hourInt = int.parse(minHour[0]); // 1
  String minute = minHour[1]; // 23

  bool afternoon = mornAft == "pm";

  if (afternoon && hourInt != 12) {
    hourInt += 12;
  }
  String hour = "$hourInt";
  if (hourInt < 10) {
    hour = "0$hour"; // "01"
  }

  return "$hour:$minute"; // "12-25-2025T" + "01:23" = "12-25-2025T01:23"
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

List<String> parseMeetingDays(String input) {
  if (input == "") {
    return [""];
  }
  List<String> output = RegExp(r'(Mo|Tu|We|Th|Fr|Sa|Su)', caseSensitive: false).allMatches(input).map((match) => match.group(0)!).toList();
  return output;
}
  

String parseEndTime(String input) {

  if(input.isEmpty) {
    return "01:00"; // Default end time
  }

  List<String> timeParts = input.trim().split(' ').toList(); // [ "12:12" , "pm" ]
  String timeShort = timeParts[0]; // "12:12"
  String mornAft = timeParts[1]; // "pm"

  List<String> minHour = timeShort.trim().split(':').toList(); // [ "12" , "12" ]
  int hourInt = int.parse(minHour[0]); // 12
  String minute = minHour[1]; // 12

  bool afternoon = mornAft == "pm";

  if (afternoon && hourInt != 12) {
    hourInt += 12; // 24
  }
  String hour = "$hourInt"; // "24"
  if (hourInt < 10) {
    hour = "0$hour"; 
  }

  return "$hour:$minute"; // "12-25-2025T" + "24:12" = "12-25-2025T24:12"
}

String parseEndDate(List<String> input) {
  List<String> dates = input[0].trim().split('-');

  String endDate = dates[1];
  List<String> dateParts = endDate.trim().split('/').toList();

  String month = dateParts[0];
  String day = dateParts[1];
  String year = dateParts[2];
  return "$year$month$day";
}

String parseTimezone(List<String> input) {
  // TODO potentially find a way to get timezone later, for now hard code Denver
  return "America/Denver";
}

List<String> parseRecurrenceRules(List<List<String>> input) {
  List<String> output = [];
  String rule = 'RRULE:FREQ=WEEKLY;BYDAY=';

  String meetingDays = parseMeetingDays(input[0][0]).join(',');
  if (meetingDays == "") {
    //return [];
    final endDate = parseEndDate(input[1]);
    return ['RRULE:FREQ=WEEKLY;BYDAY=Mo;UNTIL=${endDate}T235959Z'];
  }
  rule += meetingDays;
  rule += ';UNTIL=';
  rule += parseEndDate(input[1]);
  rule += "T235959Z";

  output.add(rule);
  return output;
}
