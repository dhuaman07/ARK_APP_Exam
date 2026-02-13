import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/features/exam/data/models/user_exam_create/user_exam_create.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_assigment/user_exam_assigment.dart';
import 'package:flutter_login_app/features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_bloc.dart';
import 'package:flutter_login_app/features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_event.dart';
import 'package:flutter_login_app/features/exam/presentation/bloc/user_exam_assigment/user_exam_assigment_state.dart';
import 'package:flutter_login_app/injection_container.dart' as di;

class ExamDetailPage extends StatelessWidget {
  final String idFacultyExamAssigment;
  final String idUser; // ✅ necesario para el submit

  const ExamDetailPage({
    super.key,
    required this.idFacultyExamAssigment,
    required this.idUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<UserExamAssigmentBloc>()
        ..add(LoadExamAssigment(
          idFacultyExamAssigment: idFacultyExamAssigment,
        )),
      child: BlocBuilder<UserExamAssigmentBloc, UserExamAssigmentState>(
        builder: (context, state) {
          if (state is UserExamAssigmentLoading ||
              state is UserExamAssigmentInitial) {
            return _buildLoadingPage();
          }
          if (state is UserExamAssigmentError) {
            return _buildErrorPage(state.message);
          }
          if (state is UserExamAssigmentLoaded) {
            return _ExamContent(
              exam: state.exam,
              idUser: idUser, // ✅ pasa al contenido
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingPage() {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2196F3)),
            SizedBox(height: 16),
            Text('Cargando examen...',
                style: TextStyle(fontSize: 16, color: Color(0xFF757575))),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPage(String message) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Color(0xFFFF5252), size: 64),
              const SizedBox(height: 16),
              const Text('Error al cargar el examen',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF757575))),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget interno con toda la lógica del examen ────────────────
class _ExamContent extends StatefulWidget {
  final AssigmentExam exam;
  final String idUser; // ✅

  const _ExamContent({
    required this.exam,
    required this.idUser,
  });

  @override
  State<_ExamContent> createState() => _ExamContentState();
}

class _ExamContentState extends State<_ExamContent> {
  int _currentQuestionIndex = 0;

  // Key: índice de pregunta, Value: id de la alternativa seleccionada
  final Map<int, String> _selectedAnswers = {};

  late int _timeRemainingSeconds;
  late DateTime _startDate; // ✅ guarda cuándo inició el examen
  Timer? _timer;

  List<AssigmentExamQuestion> get _questions => widget.exam.questions;
  AssigmentExamQuestion get _currentQuestion =>
      _questions[_currentQuestionIndex];
  bool get _isLastQuestion =>
      _currentQuestionIndex == _questions.length - 1;
  bool get _hasAnswer =>
      _selectedAnswers.containsKey(_currentQuestionIndex);

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now(); // ✅ registra inicio
    _timeRemainingSeconds = _questions.length * 2 * 60;
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
        setState(() => _timeRemainingSeconds--);
      } else {
        _timer?.cancel();
        _showTimeUpDialog();
      }
    });
  }

  // ── BUILD ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
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
                    _buildQuestionBadge(),
                    const SizedBox(height: 16),
                    _buildQuestion(_currentQuestion.questionName),
                    const SizedBox(height: 24),
                    ..._buildAlternatives(_currentQuestion.alternatives),
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
            child: const Icon(Icons.school,
                color: Color(0xFF2196F3), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Examen Tipo ${widget.exam.typeExam}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A)),
                ),
                Text(
                  '${_questions.length} preguntas',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5252).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time,
                    color: Color(0xFFFF5252), size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_timeRemainingSeconds),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5252)),
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
              const Text('Progreso',
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF757575))),
              Text(
                'Pregunta ${(_currentQuestionIndex + 1).toString().padLeft(2, '0')} / ${_questions.length}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2196F3)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'PREGUNTA ${_currentQuestionIndex + 1}',
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
            letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildQuestion(String question) {
    return Text(
      question,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
          height: 1.5),
    );
  }

  List<Widget> _buildAlternatives(
      List<AssigmentExamAlternative> alternatives) {
    return List.generate(alternatives.length, (i) {
      final alt = alternatives[i];
      final letter = String.fromCharCode(65 + i);
      final isSelected =
          _selectedAnswers[_currentQuestionIndex] == alt.id;

      return _buildAlternativeOption(
        letter: letter,
        text: alt.alternativeRpta,
        altId: alt.id,
        isSelected: isSelected,
      );
    });
  }

  Widget _buildAlternativeOption({
    required String letter,
    required String text,
    required String altId,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => setState(
          () => _selectedAnswers[_currentQuestionIndex] = altId),
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
                          : const Color(0xFF757575)),
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
                    height: 1.4),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF2196F3), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
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
          if (_currentQuestionIndex > 0) ...[
            OutlinedButton(
              onPressed: () =>
                  setState(() => _currentQuestionIndex--),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Icon(Icons.arrow_back,
                  color: Color(0xFF757575)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _hasAnswer
                  ? () {
                      if (_isLastQuestion) {
                        _showFinishDialog();
                      } else {
                        setState(() => _currentQuestionIndex++);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                disabledBackgroundColor: const Color(0xFFE0E0E0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLastQuestion ? 'Finalizar Examen' : 'Siguiente',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Finalizar Examen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                '¿Estás seguro de que deseas finalizar el examen?'),
            const SizedBox(height: 16),
            Text(
              'Preguntas respondidas: ${_selectedAnswers.length}/${_questions.length}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2196F3)),
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
                backgroundColor: const Color(0xFF2196F3)),
            child: const Text('Finalizar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFFFF5252)),
            SizedBox(width: 8),
            Text('Tiempo Agotado'),
          ],
        ),
        content: const Text(
            'El tiempo del examen ha terminado. Tus respuestas serán enviadas automáticamente.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3)),
            child: const Text('Aceptar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── SUBMIT ✅ ──────────────────────────────────────────────────
 void _submitExam() {
  final endDate = DateTime.now();

  // ✅ UserExamDetailRequest → correcto para cada respuesta
  final details = _selectedAnswers.entries.map((entry) {
    final question = _questions[entry.key];
    return UserExamDetailRequest(   // ✅ no UserExamRequest
      idQuestion:   question.id,
      idAlternative: entry.value,
    );
  }).toList();

  // ✅ SubmitExamRequest → correcto para el payload completo
  final request = UserExamRequest(  // ✅ no UserExamDetailRequest
    idUser:        widget.idUser,
    idFacultyExam: widget.exam.idFacultyExam,
    startDate:     _startDate,
    endDate:       endDate,
    userExamDetail: details,
  );

  print('📤 Payload: ${request.toJson()}');
  // TODO: BLoC → enviar al backend

  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Examen enviado exitosamente'),
      backgroundColor: Color(0xFF4CAF50),
    ),
  );
}

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}