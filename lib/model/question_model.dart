import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Question extends Equatable {
  final String? category;
  final String? difficulty;
  final String? question;
  final String? correctAnswer;
  final List<String>? answers;

  Question(
      {this.difficulty,
      this.category,
      this.correctAnswer,
      this.question,
      this.answers});

  @override
  List<Object?> get props => [
        category,
        difficulty,
        question,
        correctAnswer,
      ];

  factory Question.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null;
    return Question(
      difficulty: map["difficulty"],
      category: map["category"],
      correctAnswer: map["correct_answer"],
      question: map["question"],
      answers: List<String>.from(map["incorrect_answers"] ?? [])
        ..add(map["correct_answer"])
        ..shuffle(),
    );
  }
}


// my idea =>  
//answers : [...map["incorrect_answers"],map["correct_answer"],],