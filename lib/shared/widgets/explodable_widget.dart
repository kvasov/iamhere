import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iamhere/shared/domain/entities/pixel_particle.dart';
import 'package:iamhere/shared/painters/pixel_painter.dart';

/// Виджет, который можно "взорвать". [builder] получает [triggerExplode] — вызови его
/// (например из onPressed кнопки удаления), чтобы запустить анимацию; по завершении вызовется [onExploded].
class ExplodableWidget extends StatefulWidget {
  final Widget Function(VoidCallback triggerExplode) builder;
  final VoidCallback onExploded;

  const ExplodableWidget({super.key, required this.builder, required this.onExploded});

  @override
  State<ExplodableWidget> createState() => _ExplodableWidgetState();
}

class _ExplodableWidgetState extends State<ExplodableWidget> with SingleTickerProviderStateMixin {
  final GlobalKey _repaintKey = GlobalKey();
  late AnimationController _controller;

  List<PixelParticle> _particles = [];
  bool _isExploding = false;
  Size? _widgetSize;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {
          for (var p in _particles) {
            p.update();
          }
        });
      })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint('AnimationStatus.completed');
        widget.onExploded(); // уведомляем родителя, что нужно удалить
      }
    });
  }

  /// Эффект взрыва: снимаем изображение с виджета, создаём пиксельные частицы
  Future<void> _explode() async {
    final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;

    // Ждём конца текущего фрейма
    await Future.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;

    // Получаем изображение и байты
    final image = await boundary.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return;
    final bytes = byteData.buffer.asUint8List();

    // Получаем реальный размер виджета
    final box = _repaintKey.currentContext?.findRenderObject() as RenderBox?;
    _widgetSize = box?.size;

    final width = image.width;
    final height = image.height;
    // Берем каждый первый пиксель
    // (можно брать каждый 2-й, 3-й...)
    const pixelSize = 1;
    final newParticles = <PixelParticle>[];

    int particleCounter = 0;

    for (int y = 0; y < height; y += pixelSize) {
      for (int x = 0; x < width; x += pixelSize) {

        // Дополнительная фильтрация для уменьшения количества частиц
        // пропускаем каждый n-й пиксель
        particleCounter++;
        if (particleCounter % 3 == 0) continue;

        final index = (y * width + x) * 4;
        final r = bytes[index];
        final g = bytes[index + 1];
        final b = bytes[index + 2];
        final a = bytes[index + 3];

        if (a > 50) {
          final color = Color.fromARGB(a, r, g, b);
          final vx = (Random().nextDouble() - 0.5) * 3;
          final vy = (Random().nextDouble() - 1.0) * 2;

          newParticles.add(PixelParticle(
            position: Offset(x.toDouble(), y.toDouble()),
            velocity: Offset(vx, vy),
            color: color,
            lifeSpeedMultiplier: Random().nextDouble() * 0.99 + 0.01,
          ));
        }
      }
    }

    setState(() {
      _particles = newParticles;
      _isExploding = true;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return _isExploding && _widgetSize != null
        ? SizedBox(
            width: _widgetSize!.width,
            height: _widgetSize!.height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: PixelPainter(_particles, animationProgress: _controller.value),
                );
              },
            ),
          )
        : RepaintBoundary(
          key: _repaintKey,
          child: widget.builder(() {
            if (!_isExploding) _explode();
          }),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

