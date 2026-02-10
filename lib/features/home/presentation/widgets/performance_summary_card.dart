// lib/features/home/presentation/widgets/performance_summary_card.dart
import 'package:flutter/material.dart';

class PerformanceSummaryCard extends StatelessWidget {
  final String averageGrade;
  final int examsCompleted;

  const PerformanceSummaryCard({
    super.key,
    required this.averageGrade,
    required this.examsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildAverageGrade(),
          ),
          _buildExamsCompleted(),
        ],
      ),
    );
  }

  Widget _buildAverageGrade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Summary',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          averageGrade,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Average Grade',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildExamsCompleted() {
    return Column(
      children: [
        Text(
          '$examsCompleted',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Exams Completed',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}