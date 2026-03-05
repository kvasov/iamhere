import 'package:flutter/material.dart';
import 'package:iamhere/shared/domain/entities/pixel_particle.dart';

/// Отрисовка всех пиксельных частиц
class PixelPainter extends CustomPainter {
  final List<PixelParticle> particles;
  final double animationProgress;

  PixelPainter(this.particles, {required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      if (p.isDead) continue;
      // Вычисляем прозрачность на основе прогресса анимации (от 1.0 до 0.0)
      final opacity = (1.0 - animationProgress / p.lifeSpeedMultiplier).clamp(0.0, 1.0);
      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawRect(Rect.fromCenter(center: p.position, width: 1, height: 1), paint);
    }
  }

  @override
  bool shouldRepaint(PixelPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.particles.length != particles.length;
  }
}

