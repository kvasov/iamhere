import 'dart:ui';
import 'package:flutter/material.dart';

class BlurLayerWidget extends StatelessWidget {
  final double sigma;
  final double opacity;

  const BlurLayerWidget({
    super.key,
    required this.sigma,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          height: 1,
          color: Colors.transparent,
        ),
      ),
    );
  }
}
