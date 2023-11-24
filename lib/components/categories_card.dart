import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    super.key,
    required this.cardTitle,
    required this.cardDescription,
    required this.cardType,
  });

  final String cardTitle;
  final String? cardDescription;

  final String? cardType;

  IconData? getIcon() {
    if (cardType == "SubCategory") {
      return Icons.subject;
    } else if (cardType == "Quiz") {
      return Icons.quiz;
    } else if (cardType == "Topic") {
      return Icons.topic;
    } else if (cardType == "Practise") {
      return Icons.turned_in_not_sharp;
    } else if (cardType == "QuizAttempts") {
      return Icons.check_circle_outline_rounded;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  color: Colors.black,
                  getIcon(),
                  size: 52,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cardTitle),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(cardDescription as String),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
