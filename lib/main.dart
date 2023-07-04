import 'package:flutter/material.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialApp',
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          secondaryHeaderColor: Colors.green.shade600),
      home: const NumberTriviaPage(),
    );
  }
}
