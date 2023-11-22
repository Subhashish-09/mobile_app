import 'package:flutter/material.dart';

class QuizNavigationButtons extends StatelessWidget {
  const QuizNavigationButtons({
    super.key,
    required this.nextHandler,
    required this.previousHandler,
    required this.nextHandleName,
  });

  final void Function() nextHandler;
  final void Function() previousHandler;
  final String nextHandleName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: double.maxFinite,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey,
            ),
            child: OutlinedButton(
              onPressed: previousHandler,
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)),
              child: const Text("Previous"),
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: double.maxFinite,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey,
            ),
            child: OutlinedButton(
              onPressed: nextHandler,
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)),
              child: Text(nextHandleName),
            ),
          ),
        ),
      ],
    );
  }
}
