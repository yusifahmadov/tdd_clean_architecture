import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplayWidget extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const TriviaDisplayWidget({
    required this.numberTrivia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Center(
            child: Text(
              numberTrivia.number.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
