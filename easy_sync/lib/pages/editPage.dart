import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  late final dataset table;

  EditPage(List<List<String>> table, {super.key}) {
    this.table = dataset(table);
  }

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int questionIndex = 0;

  List<String> questions = [
    "How is each event title constructed",
    "Where is the Location",
    "Which column contains the first day",
    "Which column contains the last day",
    "Which column contains the start time",
    "Which column contains the end time",
    "Which column contains which days of the week are repeated",
  ];

  @override
  Widget build(BuildContext context) {
    // Theme.of(context);
    return QuestionWidget(
        questionToAnswer: questions[questionIndex],
        selectableAnswers: widget.table);
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.questionToAnswer,
    required this.selectableAnswers,
  });

  final String questionToAnswer;
  final dataset selectableAnswers;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class dataset {
  List<List<String>> information;
  int exampleIndex = 1;
  int numQuestions = 0;

  dataset(this.information);

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

class _QuestionWidgetState extends State<QuestionWidget> {
  List<int> selectedAnswerIndices = [];
  // TODO there probably is a better way of doing this.
  Color cardShade = const Color.fromARGB(1, 126, 126, 126);

  @override
  Widget build(BuildContext context) {
    String example = "";
    for (var index in selectedAnswerIndices) {
      example += "${widget.selectableAnswers.getExample(index)} ";
    }

    return Card(
      child: Column(
        children: [
          Text(widget.questionToAnswer),
          Row(
            children: [
              FilledButton(
                  onPressed: () {
                    setState(() {
                      widget.selectableAnswers.previousExample();
                    });
                  },
                  child: const Text("Previous example")),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Example output: $example"),
              )),
              FilledButton(
                  onPressed: () {
                    setState(() {
                      widget.selectableAnswers.nextExample();
                    });
                  },
                  child: const Text("Next example")),
            ],
          ),
          Expanded(
            child: Card(
              color: cardShade,
              child: ListView.builder(
                  itemCount: selectedAnswerIndices.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(widget.selectableAnswers
                            .getTitle(selectedAnswerIndices[index])),
                        onTap: () async {
                          setState(() {
                            selectedAnswerIndices.removeAt(index);
                          });
                        });
                  }),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              color: cardShade,
              child: ListView.builder(
                  itemCount: widget.selectableAnswers.information.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                            "${widget.selectableAnswers.getTitle(index)} | ${widget.selectableAnswers.getExample(index)}"),
                        onTap: () async {
                          setState(() {
                            selectedAnswerIndices.add(index);
                          });
                        });
                  }),
            ),
          ),
          TextButton(
              onPressed: () {
                /**TODO send information off to context when pressed */
              },
              child: const Text("Answer question")),
        ],
      ),
    );
  }
}
