import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Text(
              questionAndAnswerIndices.question,
              style: GoogleFonts.titilliumWeb(
                color: Colors.black,
                fontSize: 20,   
              ),
            ),
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
      ),
    );
  }

  Expanded selectableAnswersWidget() {
    var flex = 2;
    var numColumns = selectableAnswers.numColumns();

    someText(index) => Text(
        "${selectableAnswers.getTitle(index)} | ${selectableAnswers.getExample(index)}",
        style: GoogleFonts.titilliumWeb(
          color: Colors.black,
          fontSize: 16,
        )
      );
    someAction(index) => questionAndAnswerIndices.answerIndices.add(index);

    return interactiveList(flex, numColumns, someText, someAction);
  }

  Expanded selectedAnswersWidget() {
    var flex = 1;
    var numColumns = questionAndAnswerIndices.answerIndices.length;

    someText(index) => Text(selectableAnswers
        .getTitle(questionAndAnswerIndices.answerIndices[index]),
        style: GoogleFonts.titilliumWeb(
          color: Colors.black,
          fontSize: 16,
        )
      );
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
      child: Text(
        "Next example",
        style: GoogleFonts.titilliumWeb(
          color: Colors.white,
          fontSize: 16,
        )
      )
    );
  }

  Expanded exampleText(String example) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.titilliumWeb(
              color: Colors.black,
              fontSize: 16,
            ),
            children: [
              const TextSpan(
                text: "Example output: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: example,
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis, 
        ),
      ),
    );
  }

  FilledButton previousExampleButton() {
    return FilledButton(
      onPressed: () {
        selectableAnswers.previousExample();
        callBackFunction();
      },
      child: Text(
        "Previous example",
        style: GoogleFonts.titilliumWeb(
          color: Colors.white,
          fontSize: 16,
        )
      )
    );
  }
}