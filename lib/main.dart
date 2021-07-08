import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:puzz_quiz/Repository/quiz_repository.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_controller.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_state.dart';
import 'package:puzz_quiz/model/difficulty.dart';
import 'package:puzz_quiz/model/failure.dart';
import 'package:puzz_quiz/model/question_model.dart';
import 'package:puzz_quiz/quiz_question.dart';
import 'package:puzz_quiz/quiz_results.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Puzz-Quiz App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        home: QuizPage(),
      ),
    );
  }
}

final quizeQuestionsProvider =
    FutureProvider.autoDispose<List<Question>>((ref) {
  return ref.watch(quizRepositoryProvider).getQuestion(
      numberQuestions: 5,
      categoryId: Random().nextInt(24) + 9,
      difficulty: Difficulty.any);
});

class QuizPage extends HookWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizQuestions = useProvider(quizeQuestionsProvider);
    final pageController = usePageController();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff7b4397), Color(0xffdc2430)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => QuizError(
            message: error is Failure ? error.message : "Something went wrong",
          ),
        ),
        bottomSheet: quizQuestions.maybeWhen(
          data: (question) {
            final quizstate = useProvider(quizControllerProvider);
            if (!quizstate.answered) return const SizedBox.shrink();
            return CustomButton(
                title: pageController.page!.toInt() + 1 < question.length
                    ? "Next Question"
                    : "See Result",
                onTap: () {
                  context
                      .read(quizControllerProvider.notifier)
                      .nextQuestion(question, pageController.page!.toInt());
                  if (pageController.page!.toInt() + 1 < question.length) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                });
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PageController pageController,
    List<Question> questions,
  ) {
    if (questions.isEmpty) return QuizError(message: 'No questions found');

    final quizState = useProvider(quizControllerProvider);
    return quizState.status == QuizStatus.complete
        ? QuizResults(state: quizState, questions: questions)
        : QuizQuestion(
            pageController: pageController,
            state: quizState,
            questions: questions,
          );
  }
}

class QuizError extends StatelessWidget {
  final String message;
  const QuizError({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          CustomButton(
              title: "Retry",
              onTap: () => context.refresh(quizRepositoryProvider))
        ],
      ),
    );
  }
}

final List<BoxShadow> boxShadow = const [
  BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4.0),
];

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
