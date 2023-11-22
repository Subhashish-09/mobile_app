import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuizResultsCard extends StatelessWidget {
  QuizResultsCard({
    super.key,
    required this.title,
    required this.bottomText,
    required this.color,
    required this.bottomDescription,
  });

  final String title;
  final int bottomText;
  final String bottomDescription;
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              crossAxisAlignment: bottomDescription == "marks"
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  bottomText.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: bottomDescription == "marks" ? 5 : 0,
                ),
                Text(
                  bottomDescription,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
