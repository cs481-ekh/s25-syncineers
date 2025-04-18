import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/question_widget.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final Dataset table;
  final Map<String, QuestionAndAnswers> questions; 

  const EditPage({super.key, required this.table, required this.questions});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int questionIndex = 0;
  late List<String> questionKeys = widget.questions.keys.toList();

  @override
  Widget build(BuildContext context) {
    if (questionIndex < 0) {
      questionIndex = 0;
    }

    return Frame(
      // title: "Edit Page",
      onNextPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage(widget.table.getEvents(widget.questions))));
      },
      child: (questionIndex >= widget.questions.length)
          ? questionsComplete()
          : askCurrentQuestion(),
    );
  }

  Column askCurrentQuestion() {
    return Column(
      children: [
        Expanded(
          child: QuestionWidget(
            questionAndAnswerIndices: widget.questions[questionKeys[questionIndex]]!,
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
                      questionIndex = widget.questions.length - 1;
                    });
                  },
                  child: const Text("Previous question")),
            ),
          ],
        ),
        const Expanded(
            child: Text("That was the last question. You can move on to the next page.")),
      ],
    );
  }
}

class QuestionAndAnswers {
  String question;
  List<int> answerIndices;

  QuestionAndAnswers(this.question) : answerIndices = [];

  QuestionAndAnswers.withAnswers(this.question, this.answerIndices);

  void resetAnswers() {
    answerIndices.clear();
  }
}