import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widget.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const SingleChildScrollView(
        child: BuildBody(),
      ),
    );
  }
}

class BuildBody extends StatelessWidget {
  const BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          // header part containing error/numberTrivia/Loading state widgets
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
            if (state is Empty) {
              return const DisplayMessageWidget(text: 'Start Searching');
            } else if (state is Loading) {
              return const LoadingWidget();
            } else if (state is Loaded) {
              return TriviaDisplayWidget(numberTrivia: state.trivia);
            } else if (state is Error) {
              return DisplayMessageWidget(text: state.errorMessage);
            }
            return Container();
          }),
          const SizedBox(
            height: 10,
          ),
          // controls widgets containing text field and buttons
          TriviaControlsWidget(),
        ],
      ),
    );
  }
}
