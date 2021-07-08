import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:puzz_quiz/controllers/quiz/quiz_state.dart';
import 'package:puzz_quiz/model/question_model.dart';

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController, QuizState>(
        (ref) => QuizController());

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());

  void submiAnswer(Question currentQuestion, String answer) {
    if (currentQuestion.correctAnswer == answer) {
      state = state.copyWith(
        selectedAnswer: answer,
        correct: state.correct?..add(currentQuestion),
        incorrect: state.incorrect,
        status: QuizStatus.correct,
      );
    } else {
      state = state.copyWith(
        selectedAnswer: answer,
        correct: state.correct,
        incorrect: state.incorrect?..add(currentQuestion),
        status: QuizStatus.incorrect,
      );
    }
  }

  void nextQuestion(List<Question> questions, int currentIndex) {
    state = state.copyWith(
      selectedAnswer: '',
      status: currentIndex + 1 < questions.length
          ? QuizStatus.initial
          : QuizStatus.complete,
      incorrect: state.incorrect,
      correct: state.correct,
    );
  }

  void reset() {
    state = QuizState.initial();
  }
}
