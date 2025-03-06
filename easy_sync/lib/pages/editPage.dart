import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {

  const EditPage(List<List<String>> rows, {super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    var questionToAnswer = 'What is the title of the events';
    var list = [
      questionAnswer("Subject", "GEOG"),
      questionAnswer("Descr", "Introduction to Geography"),
      questionAnswer("Course ID", "102477"),
      questionAnswer("Room", "BLDR205"),
      questionAnswer("Meeting Dates", "03/10/2025-05/02/2025"),
    ];

    return QuestionWidget(
        questionToAnswer: questionToAnswer, selectableAnswers: list);
  }
}

class questionAnswer {
  late String title;
  late String example;

  questionAnswer(this.title, this.example);
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.questionToAnswer,
    required this.selectableAnswers,
  });

  final String questionToAnswer;
  final List<questionAnswer> selectableAnswers;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<questionAnswer> selectedAnswers = [];
  // TODO there probably is a better way of doing this.
  Color cardShade = const Color.fromARGB(1, 126, 126, 126);

  @override
  Widget build(BuildContext context) {
    String example = "";
    for (var answer in selectedAnswers) {
      example += "${answer.example} ";
    }

    return Card(
      child: Column(
        children: [
          Text(widget.questionToAnswer),
          Text("Example output: $example"),
          Expanded(
            child: Card(
              color: cardShade,
              child: ListView.builder(
                  itemCount: selectedAnswers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(selectedAnswers[index].title),
                        onTap: () async {
                          setState(() {
                            selectedAnswers.removeAt(index);
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
                  itemCount: widget.selectableAnswers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                            "${widget.selectableAnswers[index].title} | ${widget.selectableAnswers[index].example}"),
                        onTap: () async {
                          setState(() {
                            selectedAnswers
                                .add(widget.selectableAnswers[index]);
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
