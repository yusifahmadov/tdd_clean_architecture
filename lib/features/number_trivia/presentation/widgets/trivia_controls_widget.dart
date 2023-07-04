import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControlsWidget extends StatelessWidget {
  TriviaControlsWidget({Key? key}) : super(key: key);

  final TextEditingController triviaInputTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    void getConcreteTrivia() {
      BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(
          numberString: triviaInputTextFieldController.text));
    }

    void getRandomTrivia() {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForRandomNumber());
    }

    return Column(
      children: [
        SizedBox(
          height: 80,
          child: TextField(
            controller: triviaInputTextFieldController,
            onChanged: (value) {
              if (kDebugMode) {
                print(
                    "the value of text field is: ${triviaInputTextFieldController.text}");
              }
            },
            onSubmitted: (value) {
              getConcreteTrivia();
              triviaInputTextFieldController.clear();
            },
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              enabled: true,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    getConcreteTrivia();
                    triviaInputTextFieldController.clear();
                  },
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: MaterialButton(
                  color: Colors.grey,
                  onPressed: () {
                    getRandomTrivia();
                  },
                  child: const Text(
                    'Get Random Trivia',
                    style: TextStyle(color: Colors.black),
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
