import 'package:flutter/material.dart';
import 'package:iamhere/shared/widgets/blur_layer_widget.dart';

class BlurGradientWidget extends StatelessWidget {
  final double height;
  final double sigma;
  final double opacity;

  const BlurGradientWidget({
    super.key,
    required this.height,
    required this.sigma,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(height.toInt(), (index) {
          final sigma = (index / (height - 1)) * this.sigma;
          final opacity = (index / (height - 1)) * this.opacity;

          return BlurLayerWidget(
            sigma: sigma,
            opacity: opacity,
          );
        }),
      ),
    );
  }
}