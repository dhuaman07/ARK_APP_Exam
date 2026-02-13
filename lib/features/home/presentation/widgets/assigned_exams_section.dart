// lib/features/home/presentation/widgets/assigned_exams_section.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/home/presentation/bloc/assigned_exam/asigned_exam_event.dart';
import '../../domain/entities/assigned_exam.dart';
import '../bloc/assigned_exam/assigned_exam_bloc.dart';
import '../bloc/assigned_exam/assigned_exam_state.dart';
import 'assigment_card.dart';
import '../../../exam/presentation/pages/exam_detail_page.dart';
import '../../../../injection_container.dart' as di;

class AssignedExamsSection extends StatelessWidget {
  final String userId;

  const AssignedExamsSection({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<AssignedExamBloc>()..add(LoadAssignedExams(userId: userId)),
      child: BlocBuilder<AssignedExamBloc, AssignedExamState>(
        builder: (context, state) {
          if (state is AssignedExamLoading) {
            return _buildLoadingView();
          }

          if (state is AssignedExamError) {
            return _buildErrorView(context, state.message);
          }

          if (state is AssignedExamLoaded) {
            if (state.exams.isEmpty) {
              return _buildEmptyView(context); // ✅ MEJORADO
            }

            log('=================================================');
            log('${state.exams}');
            return _buildExamsList(context, state.exams);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ✅ Vista de ERROR (problemas de conexión)
  Widget _buildErrorView(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 48),
          const SizedBox(height: 12),
          Text(
            'Error al cargar exámenes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AssignedExamBloc>().add(
                    LoadAssignedExams(userId: userId),
                  );
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // ✅ Centrar
        children: [
          const SizedBox(height: 10),
          Text(
            'No tiene examenes asignados !!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AssignedExamBloc>().add(
                    LoadAssignedExams(userId: userId),
                  );
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Actualizar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade700, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamsList(BuildContext context, List<AssignedExam> exams) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];

        final colors = [
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.teal,
        ];
        final color = colors[index % colors.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AssignmentCard(
            title: exam.typeExam,
            duration: exam.durationFormatted,
            questions: exam.questionsLabel,
            color: color,
            onStartPressed: () {
              _onStartExam(context, exam);
            },
          ),
        );
      },
    );
  }

  void _onStartExam(BuildContext context, AssignedExam exam) {
    log('🚀 Iniciando examen: ${exam.typeExam}');
    log('📊 Total de preguntas: ${exam.totalQuestions}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamDetailPage(
          idFacultyExamAssigment: exam.idFacultyExamAssigment,
          idUser: userId,),
      ),
    );
  }
}
