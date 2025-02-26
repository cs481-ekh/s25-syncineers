import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var questionToAnswer = 'Some question statement';
    var list = [
      "Selectable 1",
      "Selectable 2",
      "Selectable 3",
      "Selectable 4",
      "Selectable 5",
    ];
    var list2 = [
      "Answer1",
      "Answer2",
      "Answer1",
      "Answer4",
    ];

    return QuestionWidget(theme, questionToAnswer, list2);
  }

  Center QuestionWidget(
      ThemeData theme, String questionToAnswer, List<String> listOfAnswers) {
    return Center(
      child: Card(
        child: Column(
          children: [
            Text(questionToAnswer),
            Column(
              children: [for (var element in listOfAnswers) Text(element)],
            )
          ],
        ),
      ),
    );
  }
}
