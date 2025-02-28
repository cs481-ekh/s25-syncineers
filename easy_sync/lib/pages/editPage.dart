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

    return QuestionWidget(questionToAnswer: questionToAnswer, selectableAnswers: list);
  }

}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.questionToAnswer,
    required this.selectableAnswers,
  });

  final String questionToAnswer;
  final List<String> selectableAnswers;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<String> selectedAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.questionToAnswer),
          Expanded(
            child: ListView.builder(
                itemCount: selectedAnswers.length,
                itemBuilder: (context, index) {
                  ///TODO put varables here, maybe
            
                  return ListTile(
                      title: Text(selectedAnswers[index]),
                      onTap: () async {
                        setState(() {
                          selectedAnswers.removeAt(index);
                        });
                      });
                }),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.selectableAnswers.length,
                itemBuilder: (context, index) {
                  ///TODO put varables here, maybe
            
                  return ListTile(
                      title: Text(widget.selectableAnswers[index]),
                      onTap: () async {
                        setState(() {
                          selectedAnswers.add(widget.selectableAnswers[index]);
                        });
                      });
                }),
          ),
        ],
      ),
    );
  }
}
