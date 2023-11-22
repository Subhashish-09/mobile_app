import 'package:flutter/material.dart';

class SolutionQuestionButtons extends StatelessWidget {
  const SolutionQuestionButtons({
    super.key,
    required this.currentQSubject,
    required this.questionButtons,
    required this.changeQuestion,
    required this.questionStatus,
  });

  final List questionButtons;
  final String currentQSubject;
  final void Function(int) changeQuestion;
  final Map<String, List> questionStatus;

  Color getColor(int number) {
    if (questionStatus['correct']!.contains(number.toString())) {
      return Colors.green;
    } else if (questionStatus['incorrect']!.contains(number.toString())) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

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
            backgroundColor: getColor(questionButtons
                .where((e) => e['question_sub_category'] == currentQSubject)
                .toList()[index]["question_no"]),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            changeQuestion(questionButtons
                .where((e) => e['question_sub_category'] == currentQSubject)
                .toList()[index]["question_no"]);
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
