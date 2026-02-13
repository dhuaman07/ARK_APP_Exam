// lib/features/exam/data/models/submit_exam_request.dart

class UserExamRequest {
  final String idUser;
  final String idFacultyExam;
  final DateTime startDate;
  final DateTime endDate;
  final List<UserExamDetailRequest> userExamDetail;

  UserExamRequest({
    required this.idUser,
    required this.idFacultyExam,
    required this.startDate,
    required this.endDate,
    required this.userExamDetail,
  });

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'idFacultyExam': idFacultyExam,
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        'userExamDetail': userExamDetail.map((e) => e.toJson()).toList(),
      };
}

class UserExamDetailRequest {
  final String idQuestion;
  final String idAlternative;

  UserExamDetailRequest({
    required this.idQuestion,
    required this.idAlternative,
  });

  Map<String, dynamic> toJson() => {
        'idQuestion': idQuestion,
        'idAlternative': idAlternative,
      };
}