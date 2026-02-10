// lib/features/home/presentation/widgets/assigned_exams_section.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/home/presentation/bloc/asigned_exam_event.dart';
import '../../domain/entities/assigned_exam.dart';
import '../bloc/assigned_exam_bloc.dart';
import '../bloc/assigned_exam_state.dart';
import 'assigment_card.dart';
import '../../../exam/presentation/pages/exam_detail_page.dart'; // ✅ AGREGAR IMPORT
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
              return _buildEmptyView();
            }

            log('=================================================');
            log('${state.exams}');
            return _buildExamsList(context, state.exams); // ✅ PASAR context
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

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                context.read<AssignedExamBloc>().add(
                      LoadAssignedExams(userId: userId),
                    );
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No tienes exámenes asignados',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ AGREGAR context como parámetro
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
              _onStartExam(context, exam); // ✅ PASAR context
            },
          ),
        );
      },
    );
  }

  // ✅ AGREGAR context y navegación
  void _onStartExam(BuildContext context, AssignedExam exam) {
    log('🚀 Iniciando examen: ${exam.typeExam}');
    log('📊 Total de preguntas: ${exam.totalQuestions}');
    
    // ✅ Navegar a la página del examen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamDetailPage(exam: exam),
      ),
    );
  }
}