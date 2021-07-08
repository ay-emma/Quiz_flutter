import 'package:flutter/material.dart';
import 'package:puzz_quiz/Repository/quiz_repository.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_controller.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_state.dart';
import 'package:puzz_quiz/main.dart';
import 'package:puzz_quiz/model/question_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizResults extends StatelessWidget {
  final QuizState state;
  final List<Question> questions;
  const QuizResults({Key? key, required this.state, required this.questions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "${state.correct?.length}/ ${questions.length}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          "CORRECT",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 40,
        ),
        CustomButton(
            title: "New Quiz",
            onTap: () {
              context.refresh(quizRepositoryProvider);
              context.read(quizControllerProvider);
            })
      ],
    );
  }
}
