import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard(
      {super.key, required this.cardTitle, required this.cardDescription});

  final String cardTitle;
  final String? cardDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          elevation: 10,
          surfaceTintColor: Colors.white,
          child: Row(
            children: [
              Image.network(
                "https://media.istockphoto.com/id/1047570732/vector/english.jpg?s=612x612&w=0&k=20&c=zgafUJxCytevU-ZRlrZlTEpw3mLlS_HQTIOHLjaSPPM=",
                scale: 6,
                fit: BoxFit.fill,
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
        ));
  }
}
