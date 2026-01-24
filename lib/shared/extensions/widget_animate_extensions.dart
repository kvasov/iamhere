import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Расширение для переиспользуемых анимаций виджетов.
extension WidgetAnimateExtensions on Widget {
  /// Анимация появления: fade + slide снизу вверх.
  /// Подходит для полей форм, карточек, списков.
  /// [staggerIndex] — индекс для поочерёдного появления (каждый следующий +50ms задержки).
  Widget formFieldAnimate({int staggerIndex = 0}) {
    final delay = (50 + staggerIndex * 50).ms;
    final duration = 300.ms;
    return animate()
        .fade(delay: delay, duration: duration)
        .move(begin: const Offset(0, 10), end: Offset.zero, delay: delay, duration: duration);
  }

  /// Универсальная анимация: fade + scale.
  /// Можно использовать для кнопок, чипов, модалок.
  Widget fadeScaleAnimate({int delayMs = 0, int durationMs = 300}) {
    final delay = delayMs.ms;
    final duration = durationMs.ms;
    return animate()
        .fade(delay: delay, duration: duration)
        .scale(delay: delay, duration: duration);
  }
}
