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
      onNextPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage(widget.table.getEvents(widget.questions))));
      },
      child: Stack(
        children: [
          (questionIndex >= widget.questions.length)
            ? questionsComplete()
            : askCurrentQuestion(),
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
                          "assets/Instruction2.png",
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
      )
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            previousQuestion(),
            const SizedBox(width: 75,),
            nextQuestion(),
          ],
        ),
      ],
    );
  }

  /* Expanded */ nextQuestion() {
    return /* Expanded(
      child: */ FilledButton(
          onPressed: () {
            setState(() {
              questionIndex++;
            });
          },
          child: const Text("Next question")//),
    );
  }

  /* Expanded */ previousQuestion() {
    return /* Expanded(
      child: */ FilledButton(
          onPressed: () {
            setState(() {
              questionIndex--;
            });
          },
          child: const Text("Previous question") //),
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