// lib/features/home/presentation/widgets/assignment_card.dart
import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  final String title;
  final String duration;
  final String questions;
  final Color color;
  final VoidCallback? onStartPressed;

  const AssignmentCard({
    super.key,
    required this.title,
    required this.duration,
    required this.questions,
    required this.color,
    this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildContent()),
          _buildIcon(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        _buildMetadata(),
        const SizedBox(height: 12),
        _buildStartButton(),
      ],
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          duration,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(width: 16),
        Icon(Icons.help_outline, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          questions,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton.icon(
      onPressed: onStartPressed ?? () {},
      icon: const Icon(Icons.play_arrow, size: 18),
      label: const Text('Start'),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.school, size: 40, color: color),
    );
  }
}