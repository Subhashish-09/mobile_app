import 'package:flutter/material.dart';

class QuizSubjectButtons extends StatelessWidget {
  const QuizSubjectButtons({
    super.key,
    required this.quizSubjects,
    required this.changeSubject,
    required this.currentSubject,
  });

  final List quizSubjects;
  final void Function(String, int) changeSubject;
  final String currentSubject;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final item in quizSubjects)
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              width: double.maxFinite,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: currentSubject == item['name']
                    ? Colors.blueGrey
                    : Colors.white,
              ),
              child: OutlinedButton(
                onPressed: () {
                  changeSubject(item['name'], item['initialQuestionNo']);
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                        currentSubject == item['name']
                            ? Colors.white
                            : Colors.black)),
                child: Text(
                  item['name'],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
