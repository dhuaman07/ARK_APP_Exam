// lib/features/home/presentation/widgets/recent_results_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam.dart';
import 'package:flutter_login_app/features/exam/presentation/pages/exam_result_detail_page.dart';
import 'package:flutter_login_app/features/home/presentation/bloc/user_exam/user-exam_event.dart';
import '../../../../injection_container.dart' as di;
import '../../../home/presentation/bloc/user_exam/user_exam_bloc.dart';
import '../../../home/presentation/bloc/user_exam/user_exam_state.dart';
import 'result_item.dart';

class RecentResultsSection extends StatelessWidget {
  final String userId;

  const RecentResultsSection({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<UserExamBloc>()..add(LoadUserExams(userId: userId)),
      child: BlocBuilder<UserExamBloc, UserExamState>(
        builder: (context, state) {
          if (state is UserExamLoading) {
            return _buildLoading();
          }

          if (state is UserExamError) {
            return _buildError(state.message);
          }

          if (state is UserExamLoaded) {
            // ✅ Tomar todos los exámenes (completados y pendientes)
            final allExams = state.userExams.toList();

            if (allExams.isEmpty) {
              return _buildEmptyState();
            }

            // ✅ Ordenar: Completados primero (por endDate), luego pendientes (por assignedDate)
            allExams.sort((a, b) {
              // Si ambos están completados, ordenar por endDate descendente
              if (a.status.toLowerCase() == 'completed' &&
                  b.status.toLowerCase() == 'completed') {
                if (a.endDate != null && b.endDate != null) {
                  return b.endDate!.compareTo(a.endDate!);
                }
              }

              // Si uno está completado y otro pendiente, completado primero
              if (a.status.toLowerCase() == 'completed' &&
                  b.status.toLowerCase() == 'pending') {
                return -1;
              }
              if (a.status.toLowerCase() == 'pending' &&
                  b.status.toLowerCase() == 'completed') {
                return 1;
              }

              // Si ambos están pendientes, ordenar por assignedDate descendente
              return b.assignedDate.compareTo(a.assignedDate);
            });

            // ✅ Tomar los últimos 3
            final recentExams = allExams.take(3).toList();

            return Column(
              children: recentExams.map((exam) {
                final isCompleted = exam.status.toLowerCase() == 'completed';

                return ResultItem(
                  title: 'Examen Tipo ${exam.typeExam}',
                  subtitle: isCompleted
                      ? _formatCompletedDate(exam.endDate!)
                      : _formatPendingDate(exam.assignedDate),
                  score: isCompleted
                      ? '${exam.finalGrade.toStringAsFixed(0)}/100'
                      : 'Pendiente',
                  completed: isCompleted,
                  onTap: () {
                    if (isCompleted) {
                      _navigateToExamDetail(context, exam);
                    } else {
                      _navigateToStartExam(context, exam.idFacultyExam);
                    }
                  },
                );
              }).toList(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay exámenes asignados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando se te asignen exámenes aparecerán aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompletedDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return 'Completado ${months[date.month - 1]} ${date.day}';
  }

  String _formatPendingDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return 'Asignado ${months[date.month - 1]} ${date.day}';
  }

  void _navigateToExamDetail(BuildContext context, UserExam exam) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamResultDetailPage(exam: exam),
      ),
    );
  }

  void _navigateToStartExam(BuildContext context, String facultyExamId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciar examen: $facultyExamId'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Iniciar',
          onPressed: () {
            // TODO: Navegar a página para iniciar el examen
          },
        ),
      ),
    );
  }
}
