class AssigmentExam {
  final String            idFacultyExam;
  final String            typeExam;
  final DateTime          assignedDate;
  final List<AssigmentExamQuestion> questions;

  const AssigmentExam({
    required this.idFacultyExam,
    required this.typeExam,
    required this.assignedDate,
    required this.questions,
  });

  factory AssigmentExam.fromJson(Map<String, dynamic> json) =>
      AssigmentExam(
        idFacultyExam: json['idFacultyExam'],
        typeExam:      json['typeExam'],
        assignedDate:  DateTime.parse(json['assignedDate']),
        questions:     (json['questions'] as List)
            .map((q) => AssigmentExamQuestion.fromJson(q))
            .toList(),
      );
}

class AssigmentExamQuestion {
  final String id;
  final String idFacultyExam;
  final String questionName;
  final List<AssigmentExamAlternative> alternatives;

  const AssigmentExamQuestion({
    required this.id,
    required this.idFacultyExam,
    required this.questionName,
    required this.alternatives,
  });

  factory AssigmentExamQuestion.fromJson(Map<String, dynamic> json) =>
      AssigmentExamQuestion(
        id:            json['id'],
        idFacultyExam: json['idFacultyExam'],
        questionName:  json['questionName'],
        alternatives:  (json['alternatives'] as List)
            .map((a) => AssigmentExamAlternative.fromJson(a))
            .toList(),
      );
}

class AssigmentExamAlternative {
  final String id;
  final String idQuestion;
  final String alternativeRpta;

  const AssigmentExamAlternative({
    required this.id,
    required this.idQuestion,
    required this.alternativeRpta,
  });

  factory AssigmentExamAlternative.fromJson(Map<String, dynamic> json) =>
      AssigmentExamAlternative(
        id:               json['id'],
        idQuestion:       json['idQuestion'],
        alternativeRpta:  json['alternativeRpta'],
      );
}