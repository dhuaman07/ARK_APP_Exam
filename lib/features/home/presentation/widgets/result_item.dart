// lib/features/home/presentation/widgets/result_item.dart
import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String score;
  final bool completed;
  final VoidCallback? onTap;

  const ResultItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.completed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _buildStatusIcon(),
            const SizedBox(width: 12),
            _buildContent(),
            _buildScore(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: completed
            ? Colors.green.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        completed ? Icons.check_circle : Icons.schedule,
        color: completed ? Colors.green : Colors.blue,
        size: 20,
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScore() {
    return Text(
      score,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: completed ? Colors.green : Colors.blue,
      ),
    );
  }
}