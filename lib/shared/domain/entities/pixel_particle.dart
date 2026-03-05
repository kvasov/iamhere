import 'package:flutter/material.dart';

/// Пиксельная частица, участвующая в "взрыве"
class PixelParticle {
  Offset position;
  Offset velocity;
  Color color;
  double lifeSpeedMultiplier;
  double life = 1.0;

  /// Гравитация
  static const gravity = 0.02;
  /// Трение (чем меньше значение, тем меньше разлет частиц)
  static const friction = 0.97;

  PixelParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.lifeSpeedMultiplier,
  });

  void update() {
    velocity = Offset(
      velocity.dx * friction,
      velocity.dy * friction + gravity);
    position += velocity;
    life -= 0.01 / lifeSpeedMultiplier;
  }

  bool get isDead => life <= 0;
}

