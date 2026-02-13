// lib/features/exam/presentation/pages/exam_result_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam_detail.dart';
import 'package:flutter_login_app/features/exam/domain/entities/user_exam_detail/user_exam_alternative_detail.dart';
import 'package:intl/intl.dart';

class ExamResultDetailPage extends StatelessWidget {
  final UserExam exam;

  const ExamResultDetailPage({super.key, required this.exam});

  // ── Colores (tema claro) ──────────────────────────────
  static const _bg          = Color(0xFFF5F6FA);
  static const _surface     = Color(0xFFFFFFFF);
  static const _surface2    = Color(0xFFF0F1F5);
  static const _border      = Color(0xFFE4E6EF);
  static const _correct     = Color(0xFF00B87A);
  static const _wrong       = Color(0xFFFF3D5A);
  static const _accent      = Color(0xFF4C7EF3);
  static const _textPrimary = Color(0xFF1A1D2E);
  static const _textMuted   = Color(0xFF8E92A4);

  // ── Helpers ───────────────────────────────────────────
  int get _correctCount => exam.details.where((d) {
    return d.alternatives.any(
      (a) => a.id == a.idAlternativeSelected && a.isCorrectQst,
    );
  }).length;

  int get _wrongCount => exam.details.length - _correctCount;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy', 'es').format(date);
  }

  String _duration() {
    if (exam.startDate == null || exam.endDate == null) return '—';
    final diff = exam.endDate!.difference(exam.startDate!);
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    if (h > 0) return '$h h $m min';
    return '$m min';
  }

  _AltState _altState(UserExamAlternativeDetail alt) {
    final isSelected = alt.id == alt.idAlternativeSelected;
    if (isSelected && alt.isCorrectQst)  return _AltState.correctSelected;
    if (isSelected && !alt.isCorrectQst) return _AltState.wrongSelected;
    if (!isSelected && alt.isCorrectQst) return _AltState.correctNotSelected;
    return _AltState.neutral;
  }

  // ── BUILD ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildScoreCard()),
          SliverToBoxAdapter(child: _buildLegend()),
          SliverToBoxAdapter(child: _buildSectionTitle()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _buildQuestionCard(exam.details[i], i + 1),
              childCount: exam.details.length,
            ),
          ),
          // ✅ SafeArea evita que el botón quede detrás del nav bar del celular
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: _buildBackButton(context),
            ),
          ),
        ],
      ),
    );
  }

  // ── APP BAR ───────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: _surface,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _surface2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: _textMuted),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revisión de Examen',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
          Text('Examen Tipo ${exam.typeExam} · ${_formatDate(exam.endDate)}',
              style: const TextStyle(fontSize: 11, color: _textMuted)),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _border),
      ),
    );
  }

  // ── SCORE CARD ────────────────────────────────────────
  Widget _buildScoreCard() {
    final score = exam.finalGrade.toStringAsFixed(0);
    final pct   = (exam.finalGrade / 100).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 86, height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 86, height: 86,
                  child: CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 6,
                    backgroundColor: _surface2,
                    valueColor: const AlwaysStoppedAnimation(_correct),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(score,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700, color: _correct)),
                    const Text('/100',
                        style: TextStyle(fontSize: 10, color: _textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Examen Completado',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
                const SizedBox(height: 4),
                Text('Duración: ${_duration()} · ${exam.details.length} preguntas',
                    style: const TextStyle(fontSize: 11, color: _textMuted)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: [
                    _chip('Tipo ${exam.typeExam}', _accent, const Color(0x1A4C7EF3)),
                    _chip('✓ $_correctCount correctas', _correct, const Color(0x1400B87A)),
                    _chip('✗ $_wrongCount incorrecta${_wrongCount != 1 ? "s" : ""}',
                        _wrong, const Color(0x14FF3D5A)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(.3)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  // ── LEGEND ────────────────────────────────────────────
  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 16, runSpacing: 8,
        children: [
          _legendItem(_correct, 'Respondiste correctamente'),
          _legendItem(_wrong,   'Respondiste incorrectamente'),
          _legendItem(const Color(0xFFCDD0E0), 'Respuesta correcta no marcada'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: _textMuted)),
      ],
    );
  }

  // ── SECTION TITLE ─────────────────────────────────────
  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          const Text('PREGUNTAS Y RESPUESTAS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 1.4, color: _textMuted)),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: _border)),
        ],
      ),
    );
  }

  // ── QUESTION CARD ─────────────────────────────────────
  Widget _buildQuestionCard(UserExamDetail detail, int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x1A4C7EF3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0x404C7EF3)),
                  ),
                  child: Text('Q ${index.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: _accent)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(detail.questionName,
                      style: const TextStyle(
                          fontSize: 14, height: 1.6, color: _textPrimary)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(detail.alternatives.length, (i) {
                final alt    = detail.alternatives[i];
                final state  = _altState(alt);
                final letter = String.fromCharCode(65 + i);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildAlt(alt, letter, state),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── ALTERNATIVE ROW ───────────────────────────────────
  Widget _buildAlt(UserExamAlternativeDetail alt, String letter, _AltState state) {
    final Color bg, borderColor, letterBg, letterFg, textFg;
    Widget? icon;

    switch (state) {
      case _AltState.correctSelected:
        bg          = const Color(0xFFE8FAF3);
        borderColor = const Color(0xFF99DFC3);
        letterBg    = _correct;
        letterFg    = Colors.white;
        textFg      = _correct;
        icon = const Icon(Icons.check_circle_rounded, color: _correct, size: 18);
      case _AltState.wrongSelected:
        bg          = const Color(0xFFFFECEF);
        borderColor = const Color(0xFFFFB3BE);
        letterBg    = _wrong;
        letterFg    = Colors.white;
        textFg      = _wrong;
        icon = const Icon(Icons.cancel_rounded, color: _wrong, size: 18);
      case _AltState.correctNotSelected:
        bg          = const Color(0xFFF2FCF7);
        borderColor = const Color(0xFFBBEDD8);
        letterBg    = const Color(0xFFCCF0E2);
        letterFg    = _correct;
        textFg      = const Color(0xFF00956A);
        icon = const Icon(Icons.check_circle_outline_rounded,
            color: Color(0xFF00956A), size: 18);
      case _AltState.neutral:
        bg          = _surface2;
        borderColor = _border;
        letterBg    = _surface;
        letterFg    = _textMuted;
        textFg      = _textPrimary;
        icon        = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: letterBg, borderRadius: BorderRadius.circular(8)),
            child: Text(letter,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: letterFg)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alt.alternativeRpta +
                  (state == _AltState.correctNotSelected ? ' · respuesta correcta' : ''),
              style: TextStyle(
                  fontSize: 13, height: 1.5, color: textFg,
                  fontWeight: state == _AltState.neutral
                      ? FontWeight.w400
                      : FontWeight.w500),
            ),
          ),
          if (icon != null) ...[const SizedBox(width: 8), icon],
        ],
      ),
    );
  }

  // ── BACK BUTTON ───────────────────────────────────────
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('Volver al Inicio',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

enum _AltState { correctSelected, wrongSelected, correctNotSelected, neutral }