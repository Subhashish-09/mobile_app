import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  const Navigation(
      {required this.previousHandler, required this.nextHandler, super.key});

  final void Function() previousHandler;
  final void Function() nextHandler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(right: 10),
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
            margin: const EdgeInsets.only(left: 10),
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
              child: const Text("Next"),
            ),
          ),
        ),
      ],
    );
  }
}
