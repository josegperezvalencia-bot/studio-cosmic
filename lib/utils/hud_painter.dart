import 'package:flutter/material.dart';
import 'constants.dart';

class HUDPainter extends CustomPainter {
  final bool showGrid;

  HUDPainter({this.showGrid = true});

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final paint = Paint()
        ..color = AppConstants.neonBlue.withAlpha(13)
        ..strokeWidth = 0.5;
      for (double x = 0; x <= size.width; x += 30) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
      for (double y = 0; y <= size.height; y += 30) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
    _drawCorners(canvas, size);
  }

  void _drawCorners(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.neonBlue.withAlpha(77)
      ..strokeWidth = 1.0;
    const s = 20.0, m = 10.0;
    canvas.drawLine(const Offset(m, m + s), const Offset(m, m), paint);
    canvas.drawLine(const Offset(m, m), const Offset(m + s, m), paint);
    canvas.drawLine(Offset(size.width - m - s, m), Offset(size.width - m, m), paint);
    canvas.drawLine(Offset(size.width - m, m), Offset(size.width - m, m + s), paint);
    canvas.drawLine(Offset(m, size.height - m - s), Offset(m, size.height - m), paint);
    canvas.drawLine(Offset(m, size.height - m), Offset(m + s, size.height - m), paint);
    canvas.drawLine(Offset(size.width - m - s, size.height - m), Offset(size.width - m, size.height - m), paint);
    canvas.drawLine(Offset(size.width - m, size.height - m), Offset(size.width - m, size.height - m - s), paint);
  }

  @override
  bool shouldRepaint(covariant HUDPainter oldDelegate) => true;
}
