import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// ignore: must_be_immutable
class SingleQuestionOptions extends StatelessWidget {
  SingleQuestionOptions({
    super.key,
    required this.options,
    required this.saveHandler,
    required this.currentQuestionResponse,
  });

  final List options;
  final Function(int) saveHandler;
  int currentQuestionResponse;

  Color getRightColor(index) {
    return currentQuestionResponse == index + 1 ? Colors.blue : Colors.black;
  }

  IconData? getRightIcon(index) {
    return currentQuestionResponse == index + 1 ? Icons.circle : null;
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
                  onTap: () {
                    currentQuestionResponse = index + 1;
                    final response = index + 1;
                    saveHandler(response);
                  },
                  onDoubleTap: () {
                    currentQuestionResponse = 0;
                    const response = 0;
                    saveHandler(response);
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
