import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewPaintEffect extends PaintingEffect {
  final Color startColor;
  final Color endColor;
  final Color shimmerColor;

  NewPaintEffect({
    required this.startColor,
    required this.endColor,
    required this.shimmerColor,
    super.duration = Durations.short1, // Light color for shimmer
  });

  @override
  Paint createPaint(double t, Rect rect, TextDirection? textDirection) {
    // Main gradient for left-to-right transition
    final mainGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [startColor, endColor],
      stops: [0.0, t.clamp(0.0, 1.0)],
    );

    // Shimmer gradient
    final shimmerGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.transparent,
        shimmerColor.withOpacity(0.5),
        Colors.transparent
      ],
      stops: [t - 0.2, t, t + 0.2], // Shimmer position based on `t`
    );

    // Combine the gradients in a composite shader effect
    return Paint()
      ..shader = mainGradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver
      ..shader = shimmerGradient.createShader(rect);
  }

  @override
  Duration get duration => const Duration(seconds: 2);

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) {
    if (other is! NewPaintEffect) return this;

    return NewPaintEffect(
      startColor: Color.lerp(startColor, other.startColor, t) ?? startColor,
      endColor: Color.lerp(endColor, other.endColor, t) ?? endColor,
      shimmerColor:
          Color.lerp(shimmerColor, other.shimmerColor, t) ?? shimmerColor,
      duration: duration,
    );
  }

  @override
  double get lowerBound => 0.0;

  @override
  bool get reverse => false;

  @override
  double get upperBound => 1.0;
}
