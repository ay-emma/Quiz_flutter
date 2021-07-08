import 'package:puzz_quiz/model/difficulty.dart';
import 'package:puzz_quiz/model/question_model.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestion({
    required int numberQuestions,
    required int categoryId,
    required Difficulty difficulty,
  });
}
