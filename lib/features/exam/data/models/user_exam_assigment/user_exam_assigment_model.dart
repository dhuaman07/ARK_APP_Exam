import 'package:flutter_login_app/features/exam/domain/entities/user_exam_assigment/user_exam_assigment.dart';

class AssigmentExamModel extends AssigmentExam {
  const AssigmentExamModel({
    required super.idFacultyExam,
    required super.typeExam,
    required super.assignedDate,
    required super.questions,
  });

  factory AssigmentExamModel.fromJson(Map<String, dynamic> json) =>
      AssigmentExamModel(
        idFacultyExam: json['idFacultyExam'] as String,
        typeExam:      json['typeExam'] as String,
        assignedDate:  DateTime.parse(json['assignedDate'] as String),
        questions:     (json['questions'] as List<dynamic>)
            .map((q) => AssigmentExamQuestionModel.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}

class AssigmentExamQuestionModel extends AssigmentExamQuestion {
  const AssigmentExamQuestionModel({
    required super.id,
    required super.idFacultyExam,
    required super.questionName,
    required super.alternatives,
  });

  factory AssigmentExamQuestionModel.fromJson(Map<String, dynamic> json) =>
      AssigmentExamQuestionModel(
        id:            json['id'] as String,
        idFacultyExam: json['idFacultyExam'] as String,
        questionName:  json['questionName'] as String,
        alternatives:  (json['alternatives'] as List<dynamic>)
            .map((a) => AssigmentExamAlternativeModel.fromJson(a as Map<String, dynamic>))
            .toList(),
      );
}

class AssigmentExamAlternativeModel extends AssigmentExamAlternative {
  const AssigmentExamAlternativeModel({
    required super.id,
    required super.idQuestion,
    required super.alternativeRpta,
  });

  factory AssigmentExamAlternativeModel.fromJson(Map<String, dynamic> json) =>
      AssigmentExamAlternativeModel(
        id:              json['id'] as String,
        idQuestion:      json['idQuestion'] as String,
        alternativeRpta: json['alternativeRpta'] as String,
      );
}