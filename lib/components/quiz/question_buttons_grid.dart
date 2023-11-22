import 'package:flutter/material.dart';

class QuizQuestionButtons extends StatelessWidget {
  const QuizQuestionButtons({
    super.key,
    required this.currentQSubject,
    required this.questionButtons,
    required this.changeQuestion,
    required this.questionStatus,
  });

  final List questionButtons;
  final String currentQSubject;
  final void Function(int) changeQuestion;
  final Map questionStatus;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: .90,
      ),
      padding: const EdgeInsets.all(15),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: questionButtons
          .where(
            (e) => e['question_sub_category'] == currentQSubject,
          )
          .length,
      itemBuilder: (BuildContext ctx, index) {
        return TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
            backgroundColor: questionStatus[questionButtons
                        .where((e) =>
                            e['question_sub_category'] == currentQSubject)
                        .toList()[index]["question_no"]
                        .toString()] ==
                    "Attempted"
                ? Colors.black
                : Colors.white,
            foregroundColor: questionStatus[questionButtons
                        .where((e) =>
                            e['question_sub_category'] == currentQSubject)
                        .toList()[index]["question_no"]
                        .toString()] ==
                    "Attempted"
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            changeQuestion(
              questionButtons
                  .where((e) => e['question_sub_category'] == currentQSubject)
                  .toList()[index]["question_no"],
            );
          },
          child: Text(
            questionButtons
                .where((e) => e['question_sub_category'] == currentQSubject)
                .toList()[index]["question_no"]
                .toString(),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }
}
