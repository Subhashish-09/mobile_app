import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class QuizSolutionCard extends StatelessWidget {
  const QuizSolutionCard({
    super.key,
    required this.questionNo,
    required this.question,
    required this.attemptedAnswer,
    required this.correctAnswer,
    required this.options,
    required this.solution,
    required this.isSolutionLoaded,
    required this.loadSolution,
    required this.responseType,
  });

  final int questionNo;
  final String question;
  final int attemptedAnswer;
  final int correctAnswer;
  final List options;
  final String solution;
  final bool isSolutionLoaded;
  final void Function() loadSolution;
  final String responseType;

  Color getRightColor(index) {
    return attemptedAnswer == index + 1
        ? attemptedAnswer == correctAnswer
            ? Colors.green
            : Colors.red
        : index + 1 == correctAnswer
            ? Colors.green
            : Colors.black;
  }

  Color getRightType() {
    return responseType == "Correct"
        ? Colors.green
        : responseType == "Incorrect"
            ? Colors.red
            : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question No: $questionNo',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    responseType,
                    style: TextStyle(
                      color: getRightType(),
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              HtmlWidget(
                question,
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                    ),
              ),
            ],
          ),
          Column(
            children: [
              for (final (index, option) in options.indexed)
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: getRightColor(index),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: HtmlWidget(
                              option,
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: getRightColor(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      attemptedAnswer == correctAnswer || attemptedAnswer == 0
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  Align(
                    alignment:
                        isSolutionLoaded ? Alignment.topLeft : Alignment.center,
                    child: TextButton(
                      onPressed: loadSolution,
                      child: Text(
                        isSolutionLoaded ? "Hide Solution" : "View Solution",
                      ),
                    ),
                  ),
                  Visibility(
                      visible: isSolutionLoaded,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Solution:",
                              style: TextStyle(
                                color: attemptedAnswer == correctAnswer ||
                                        attemptedAnswer == 0
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: HtmlWidget(
                              solution,
                              textStyle: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
