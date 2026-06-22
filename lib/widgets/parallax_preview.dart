import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class ParallaxPreview extends StatelessWidget {
  final Widget child;
  final double sensitivity;
  final bool enableParallax;

  const ParallaxPreview({
    super.key, required this.child,
    this.sensitivity = 1.0, this.enableParallax = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableParallax) return child;
    return Consumer<SensorProvider>(
      builder: (context, sensor, _) => Transform.translate(
        offset: Offset(sensor.tiltX * sensitivity * 20, sensor.tiltY * sensitivity * 20),
        child: child,
      ),
    );
  }
}
