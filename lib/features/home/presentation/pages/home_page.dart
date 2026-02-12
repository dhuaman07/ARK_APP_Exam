// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_login_app/features/home/presentation/widgets/recent_results_section.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/home_header.dart';
import '../widgets/performance_summary_card.dart';
import '../widgets/assigned_exams_section.dart'; // ✅ Importar
import '../widgets/result_item.dart';
import '../widgets/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header
            HomeHeader(
              user: widget.user,
              onNotificationTap: () {
                // TODO: Navegar a notificaciones
              },
            ),

            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Performance Summary
                    const PerformanceSummaryCard(
                      averageGrade: '88%',
                      examsCompleted: 12,
                    ),

                    const SizedBox(height: 24),

                    // Currently Assigned Section
                    _buildSectionTitle('Examenes asignados'),

                    const SizedBox(height: 16),

                    // ✅ Aquí va el widget que maneja el BLoC
                    AssignedExamsSection(userId: widget.user.id),

                    const SizedBox(height: 24),

                    // Recent Results Section
                    _buildSectionHeader('Resultados recientes'),

                    const SizedBox(height: 12),

                    // ✅ Aquí va el widget que maneja el BLoC
                    RecentResultsSection(userId: widget.user.id),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            _showLogoutDialog();
          } else {
            setState(() {
              _currentIndex = index;
            });
            // TODO: Implementar navegación a otras páginas
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Navegar a ver todos los resultados
          },
          child: const Text(
            'Ver Todos',
            style: TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro que deseas cerrar sesión?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
