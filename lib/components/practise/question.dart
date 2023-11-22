import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Question extends StatelessWidget {
  const Question({super.key, required this.question, required this.questionNo});

  final String question;
  final int questionNo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Question No: $questionNo'),
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
    );
  }
}
