import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Options extends StatelessWidget {
  const Options({
    super.key,
    required this.options,
    required this.optionsLength,
    required this.correctAnswer,
    required this.optionsHandler,
    required this.attemptedAnswer,
    required this.isAttempted,
  });

  final List options;
  final int optionsLength;
  final int correctAnswer;
  final int attemptedAnswer;
  final bool isAttempted;
  final Function(int index) optionsHandler;

  Color getRightColor(index) {
    return isAttempted
        ? attemptedAnswer == index + 1
            ? attemptedAnswer == correctAnswer
                ? Colors.green
                : Colors.red
            : index + 1 == correctAnswer
                ? Colors.green
                : Colors.black
        : Colors.black;
  }

  IconData? getRightIcon(index) {
    return isAttempted
        ? attemptedAnswer == index + 1
            ? attemptedAnswer == correctAnswer
                ? Icons.done
                : Icons.close
            : index + 1 == correctAnswer
                ? Icons.done
                : null
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (index, option) in options.indexed)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: InkWell(
                  onTap: isAttempted
                      ? null
                      : () {
                          optionsHandler(index);
                        },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: getRightColor(index),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: getRightColor(index) == Colors.black
                                ? Colors.transparent
                                : getRightColor(index),
                            border: Border.all(
                              color: getRightColor(index),
                            ),
                          ),
                          child: getRightColor(index) == Colors.black
                              ? null
                              : Icon(
                                  color: Colors.white,
                                  getRightIcon(index),
                                  size: 16,
                                ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            child: HtmlWidget(
                          option,
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: getRightColor(index),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
