import 'package:flutter/material.dart';

class QuizDetailsText extends StatelessWidget {
  const QuizDetailsText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }
}
