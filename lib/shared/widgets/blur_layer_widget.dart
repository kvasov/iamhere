import 'dart:ui';
import 'package:flutter/material.dart';

class BlurLayerWidget extends StatelessWidget {
  final double sigma;
  final double opacity;
  final Color color;

  const BlurLayerWidget({
    super.key,
    required this.sigma,
    required this.opacity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          height: 1,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
