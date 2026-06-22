import 'dart:math';
import 'package:flutter/material.dart';
import '../services/particle_effect_service.dart';

class ParticleCanvas extends StatelessWidget {
  final List<Particle2D> particles;
  const ParticleCanvas({super.key, required this.particles});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _ParticlePainter(particles));
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle2D> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color.withAlpha((p.opacity * 255).toInt());
      switch (p.type) {
        case ParticleType.star:
          canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
          if (p.size > 1.5) {
            final glow = Paint()..color = p.color.withAlpha(((p.opacity * 0.3) * 255).toInt());
            canvas.drawCircle(Offset(p.x, p.y), p.size * 2.5, glow);
          }
        case ParticleType.nebula:
          paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
          canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
        case ParticleType.glow:
          final gradient = RadialGradient(colors: [p.color.withAlpha(128), p.color.withAlpha(26), Colors.transparent]);
          final gp = Paint()..shader = gradient.createShader(Rect.fromCircle(center: Offset(p.x, p.y), radius: p.size * 2));
          canvas.drawCircle(Offset(p.x, p.y), p.size * 2, gp);
          canvas.drawCircle(Offset(p.x, p.y), p.size * 0.3, paint);
        case ParticleType.planet:
          canvas.save();
          canvas.translate(p.x, p.y);
          canvas.rotate(p.rotation);
          final pp = Paint()..shader = RadialGradient(colors: [p.color, p.color.withAlpha(179), p.color.withAlpha(77)])
              .createShader(Rect.fromCircle(center: Offset.zero, radius: p.size));
          canvas.drawCircle(Offset.zero, p.size, pp);
          final gp = Paint()..color = p.color.withAlpha(51)..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.5);
          canvas.drawCircle(Offset.zero, p.size * 1.5, gp);
          canvas.restore();
        case ParticleType.meteor:
          canvas.save();
          canvas.translate(p.x, p.y);
          canvas.rotate(p.rotation);
          canvas.drawCircle(Offset.zero, p.size, Paint()..color = const Color(0xFFFFB300).withAlpha((p.opacity * 255).toInt()));
          canvas.drawRect(Rect.fromCenter(center: const Offset(-15, 0), width: 30, height: 2),
              Paint()..color = const Color(0xFFFFB300).withAlpha(((p.opacity * 0.3) * 255).toInt())..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
          canvas.restore();
        default:
          canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class StarField extends StatelessWidget {
  final int starCount;
  const StarField({super.key, this.starCount = 80});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _StarFieldPainter(starCount: starCount));
  }
}

class _StarFieldPainter extends CustomPainter {
  final int starCount;
  _StarFieldPainter({required this.starCount});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    for (int i = 0; i < starCount; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final baseSize = rng.nextDouble() * 2 + 0.5;
      final twinkle = 0.5 + 0.5 * sin(time + rng.nextDouble() * 2 * pi);
      final paint = Paint()..color = Colors.white.withAlpha(((0.3 + 0.7 * twinkle) * 255).toInt());
      canvas.drawCircle(Offset(x, y), baseSize * (0.5 + 0.5 * twinkle), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => true;
}
