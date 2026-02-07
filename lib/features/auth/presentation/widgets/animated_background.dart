import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradiente base con colores distintivos
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0E27), // Azul marino profundo
                Color(0xFF1A1B3E), // Morado oscuro
                Color(0xFF0F1419), // Negro azulado
              ],
            ),
          ),
        ),
        
        // Partículas animadas
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlesPainter(_controller.value),
              child: Container(),
            );
          },
        ),
        
        // Overlay con textura de ruido sutil
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.03),
                Colors.transparent,
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
        ),
        
        widget.child,
      ],
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Crear partículas flotantes con efecto de profundidad
    for (int i = 0; i < 30; i++) {
      final progress = (animationValue + i / 30) % 1.0;
      final x = (i * 37.0) % size.width;
      final y = size.height * progress;
      final opacity = (1 - progress) * 0.6;
      
      // Colores cian y magenta para contraste
      final color = i % 2 == 0
          ? Color.lerp(
              const Color(0xFF00F5FF), // Cian brillante
              const Color(0xFF0080FF), // Azul
              (math.sin(progress * math.pi * 2) + 1) / 2,
            )!
          : Color.lerp(
              const Color(0xFFFF006E), // Magenta
              const Color(0xFFFF4D00), // Naranja rojizo
              (math.cos(progress * math.pi * 2) + 1) / 2,
            )!;

      paint.color = color.withOpacity(opacity);
      
      final radius = 2.0 + (math.sin(progress * math.pi) * 1.5);
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      // Efecto de brillo
      paint.color = Colors.white.withOpacity(opacity * 0.5);
      canvas.drawCircle(Offset(x, y), radius * 0.4, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
