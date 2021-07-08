import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:puzz_quiz/model/failure.dart';
import 'package:puzz_quiz/model/question_model.dart';
import 'package:puzz_quiz/model/difficulty.dart';

import 'base_quiz_repository.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepository((ref.read)));

class QuizRepository extends BaseQuizRepository {
  final Reader _read;

  QuizRepository(this._read);

  @override
  Future<List<Question>> getQuestion(
      {required int numberQuestions,
      required int categoryId,
      required Difficulty difficulty}) async {
    try {
      final queryParameters = {
        'type': 'multiple',
        'amount': numberQuestions,
        'category': categoryId,
      };
      if (difficulty != Difficulty.any) {
        queryParameters.addAll({
          'difficulty': EnumToString.convertToString(difficulty),
        });
      }
      final response = await _read(dioProvider).get(
        'https://opentdb.com/api.php',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        if (results.isNotEmpty) {
          return results.map((e) => Question.fromMap(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong!');
    } on SocketException catch (err) {
      print(err);
      throw Failure(message: "Please check your connection");
    }
  }
}
