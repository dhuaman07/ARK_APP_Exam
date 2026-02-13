import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam_alternative_detail.dart';

class UserExamDetail {
  final String id;
  final String idQuestion;
  final String questionName;
  final List<UserExamAlternativeDetail> alternatives;

  const UserExamDetail({
    required this.id,
    required this.idQuestion,
    required this.questionName,
    required this.alternatives,
  });
}
