import 'package:easy_sync/pages/loginPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:easy_sync/tools/frame.dart';
import 'package:easy_sync/tools/question_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        if (questionIndex >= widget.questions.length) {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              LoginPage(widget.table.getEvents(widget.questions)),
          ),
          );
        } else {
          // Do nothing or show a message if needed
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please complete all questions before proceeding."),
          ),
          );
        }
      },
      child: Padding(
      padding: const EdgeInsets.all(8.0),
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
        ),
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
            Expanded(
              child: Center(
                child: previousQuestion(),
              ),
            ),
            // const SizedBox(width: 75,),
            Expanded(
              child: Center(
                child: nextQuestion(),
              ),
            )
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
          child: Text(
            "Next question",
            style: GoogleFonts.titilliumWeb(
              color: Colors.white,
              fontSize: 16,
            ),
          )//),
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
          child: Text(
            "Previous question",
            style: GoogleFonts.titilliumWeb(
              color: Colors.white,
              fontSize: 16,
            ),
          )//),
    );
  }

  Column questionsComplete() {
    return Column(
      children: [
        const Spacer(flex: 1),
        Text("If you wish to change you answers, use the buttons below.",
          style: GoogleFonts.titilliumWeb(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Expanded(
              child: Center(
                child: FilledButton(
                    onPressed: () {
                      setState(() {
                        questionIndex = 0;
                      });
                    },
                    child: Text("First question",
                        style: GoogleFonts.titilliumWeb(
                          color: Colors.white,
                          fontSize: 16,
                        ))),
              ),
            ),
            Expanded(
              child: Center(
                child: FilledButton(
                    onPressed: () {
                      setState(() {
                        questionIndex = widget.questions.length - 1;
                      });
                    },
                    child: Text("Previous question",
                        style: GoogleFonts.titilliumWeb(
                          color: Colors.white,
                          fontSize: 16,
                        ))),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Expanded(
          child: Text("That was the last question. You can move on to the next page.",
            style: GoogleFonts.titilliumWeb(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          )
        ),
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