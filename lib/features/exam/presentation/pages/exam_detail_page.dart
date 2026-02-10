// lib/features/exam/presentation/pages/exam_detail_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../home/domain/entities/assigned_exam.dart';

class ExamDetailPage extends StatefulWidget {
  final AssignedExam exam;

  const ExamDetailPage({
    super.key,
    required this.exam,
  });

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  late int _timeRemainingSeconds;
  Timer? _timer;

  // TODO: Esto vendrá del BLoC
  final List<Map<String, dynamic>> _mockQuestions = [
    {
      'category': 'MOLECULAR BIOLOGY',
      'question': 'What is the primary function of the mitochondria in a eukaryotic cell, and how does it contribute to cellular homeostasis?',
      'alternatives': [
        {'letter': 'A', 'text': 'Cellular respiration and ATP production via oxidative phosphorylation'},
        {'letter': 'B', 'text': 'Genetic information storage and DNA replication'},
        {'letter': 'C', 'text': 'Protein synthesis, folding, and transport via the Golgi apparatus'},
        {'letter': 'D', 'text': 'Photosynthesis and glucose production through chlorophyll activation'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Calcular tiempo estimado (2 minutos por pregunta)
    _timeRemainingSeconds = widget.exam.totalQuestions * 2 * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemainingSeconds > 0) {
        setState(() {
          _timeRemainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _autoSubmitExam();
      }
    });
  }

  void _autoSubmitExam() {
    // TODO: Enviar respuestas automáticamente
    _showTimeUpDialog();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _mockQuestions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategory(currentQuestion['category']),
                    const SizedBox(height: 16),
                    _buildQuestion(currentQuestion['question']),
                    const SizedBox(height: 24),
                    ..._buildAlternatives(currentQuestion['alternatives']),
                  ],
                ),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school,
              color: Color(0xFF2196F3),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.exam.typeExam,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5252).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Color(0xFFFF5252),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_timeRemainingSeconds),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5252),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
              Text(
                'Question ${(_currentQuestionIndex + 1).toString().padLeft(2, '0')} / ${widget.exam.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.exam.totalQuestions,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2196F3),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
        height: 1.4,
      ),
    );
  }

  List<Widget> _buildAlternatives(List<dynamic> alternatives) {
    return alternatives.map((alt) {
      final isSelected = _selectedAnswers[_currentQuestionIndex] == alt['letter'];
      return _buildAlternativeOption(
        alt['letter'],
        alt['text'],
        isSelected: isSelected,
      );
    }).toList();
  }

  Widget _buildAlternativeOption(String letter, String text, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAnswers[_currentQuestionIndex] = letter;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF2196F3).withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF2196F3)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF2196F3)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected 
                        ? Colors.white
                        : const Color(0xFF757575),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected 
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFF424242),
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2196F3),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final hasAnswer = _selectedAnswers.containsKey(_currentQuestionIndex);
    final isLastQuestion = _currentQuestionIndex == _mockQuestions.length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentQuestionIndex--;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF757575),
              ),
            ),
          if (_currentQuestionIndex > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: hasAnswer ? () {
                if (isLastQuestion) {
                  _showFinishDialog();
                } else {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: const Color(0xFFE0E0E0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastQuestion ? 'Finish Exam' : 'Next Question',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Finalizar Examen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de que deseas finalizar el examen?'),
            const SizedBox(height: 16),
            Text(
              'Preguntas respondidas: ${_selectedAnswers.length}/${_mockQuestions.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFFFF5252)),
            SizedBox(width: 8),
            Text('Tiempo Agotado'),
          ],
        ),
        content: const Text('El tiempo del examen ha terminado. Tus respuestas serán enviadas automáticamente.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _submitExam() {
    // TODO: Enviar respuestas al backend
    print('Respuestas: $_selectedAnswers');
    
    // Navegar de vuelta al home
    Navigator.pop(context);
    
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Examen enviado exitosamente'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}