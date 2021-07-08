import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_controller.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_state.dart';
import 'package:puzz_quiz/main.dart';
import 'package:puzz_quiz/model/question_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizQuestion extends StatelessWidget {
  const QuizQuestion(
      {Key? key,
      required this.pageController,
      required this.state,
      required this.questions})
      : super(key: key);
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (BuildContext context, int index) {
          final question = questions[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Question ${index + 1} of ${questions.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
                child: Text(
                  HtmlCharacterEntities.decode(question.question!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[200],
                height: 32.0,
                thickness: 2.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              Column(
                children: question.answers!
                    .map((e) => AnswerCard(
                          answer: e,
                          isSelected: e == state.selectedAnswer,
                          isCorrect: e == question.correctAnswer,
                          isDisplayingAnswer: state.answered,
                          onTap: () => context
                              .read(quizControllerProvider.notifier)
                              .submiAnswer(question, e),
                        ))
                    .toList(),
              )
            ],
          );
        });
  }
}

class AnswerCard extends StatelessWidget {
  const AnswerCard(
      {Key? key,
      required this.answer,
      required this.isSelected,
      required this.isCorrect,
      required this.isDisplayingAnswer,
      required this.onTap})
      : super(key: key);

  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool isDisplayingAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: boxShadow,
          border: Border.all(
            color: isDisplayingAnswer
                ? isCorrect
                    ? Colors.green
                    : isSelected
                        ? Colors.red
                        : Colors.white
                : Colors.white,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                HtmlCharacterEntities.decode(answer),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: isDisplayingAnswer && isCorrect
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
              ),
            ),
            if (isDisplayingAnswer)
              isCorrect
                  ? const CircularIcon(icon: Icons.check, color: Colors.green)
                  : isSelected
                      ? const CircularIcon(
                          icon: Icons.close,
                          color: Colors.red,
                        )
                      : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

//* >>>>>>> 13:37

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CircularIcon({Key? key, required this.icon, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      width: 24.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: boxShadow,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
