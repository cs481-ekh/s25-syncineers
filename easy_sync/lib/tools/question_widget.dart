import 'package:easy_sync/pages/editPage.dart';
import 'package:easy_sync/tools/dataset.dart';
import 'package:flutter/material.dart';

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