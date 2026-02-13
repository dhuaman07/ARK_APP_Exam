// lib/features/exam/domain/entities/question.dart

import 'package:equatable/equatable.dart';

class ExamQuestion extends Equatable {
  final String id;
  final String questionText;
  final String category;
  final List<Alternative> alternatives;

  const ExamQuestion({
    required this.id,
    required this.questionText,
    required this.category,
    required this.alternatives,
  });

  @override
  List<Object?> get props => [id, questionText, category, alternatives];
}

class Alternative extends Equatable {
  final String id;
  final String letter;
  final String text;
  final bool isCorrect;

  const Alternative({
    required this.id,
    required this.letter,
    required this.text,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [id, letter, text, isCorrect];
}