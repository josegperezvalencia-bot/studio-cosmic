import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/effect_type.dart';

enum ParticleType { space, star, nebula, glow, planet, meteor }

class Particle2D {
  double x, y, vx, vy, size, opacity, rotation, rotationSpeed, life, maxLife;
  Color color;
  ParticleType type;

  Particle2D({
    required this.x, required this.y, required this.vx, required this.vy,
    required this.size, required this.opacity, required this.rotation,
    this.rotationSpeed = 0, required this.color, required this.life,
    required this.maxLife, required this.type,
  });

  bool get isAlive => life > 0;

  void update(double dt, double width, double height, Random rng) {
    x += vx * dt;
    y += vy * dt;
    rotation += rotationSpeed * dt;
    life -= dt;
    if (type == ParticleType.meteor) opacity = (life / maxLife).clamp(0.0, 1.0);
    if (x < -size) x = width + size;
    if (x > width + size) x = -size;
    if (y < -size) y = height + size;
    if (y > height + size) y = -size;
  }
}

class ParticleEffectService {
  static final ParticleEffectService _instance = ParticleEffectService._();
  factory ParticleEffectService() => _instance;
  ParticleEffectService._();

  final Random _rng = Random();
  Timer? _updateTimer;
  final StreamController<List<Particle2D>> _particleController = StreamController<List<Particle2D>>.broadcast();
  List<Particle2D> _particles = [];
  List<EffectType> _activeEffects = [];
  double _width = 0, _height = 0;

  Stream<List<Particle2D>> get particleStream => _particleController.stream;

  void initialize(double width, double height) {
    _width = width; _height = height;
    _updateTimer = Timer.periodic(const Duration(milliseconds: 33), (_) => _update());
  }

  void setActiveEffects(List<EffectType> effects) {
    _activeEffects = List.from(effects);
    _particles = [];
    _spawnParticles();
  }

  void resize(double width, double height) {
    _width = width; _height = height;
    _particles = [];
    _spawnParticles();
  }

  void _spawnParticles() {
    for (final effect in _activeEffects) {
      switch (effect) {
        case EffectType.spaceParticles:
          for (int i = 0; i < 50; i++) { _particles.add(_randomSpace()); }
        case EffectType.animatedStars:
          for (int i = 0; i < 80; i++) { _particles.add(_randomStar()); }
        case EffectType.nebula:
          for (int i = 0; i < 3; i++) {
            final cx = _rng.nextDouble() * _width;
            final cy = _rng.nextDouble() * _height;
            final colors = [const Color(0xFF8B5CF6), const Color(0xFF00D4FF), const Color(0xFFFF1493)];
            for (int j = 0; j < 25; j++) {
              final a = _rng.nextDouble() * 2 * pi;
              final d = _rng.nextDouble() * 120;
              _particles.add(Particle2D(
                x: cx + cos(a) * d, y: cy + sin(a) * d,
                vx: (_rng.nextDouble() - 0.5) * 3, vy: (_rng.nextDouble() - 0.5) * 3,
                size: _rng.nextDouble() * 35 + 15, opacity: _rng.nextDouble() * 0.2 + 0.05,
                rotation: 0, color: colors[_rng.nextInt(3)],
                life: double.infinity, maxLife: double.infinity, type: ParticleType.nebula,
              ));
            }
          }
        case EffectType.neonGlow:
          final glowColors = [const Color(0xFF00D4FF), const Color(0xFF8B5CF6), const Color(0xFFFF1493)];
          for (int i = 0; i < 15; i++) { _particles.add(Particle2D(
            x: _rng.nextDouble() * _width, y: _rng.nextDouble() * _height,
            vx: (_rng.nextDouble() - 0.5) * 10, vy: (_rng.nextDouble() - 0.5) * 10,
            size: _rng.nextDouble() * 8 + 3, opacity: _rng.nextDouble() * 0.3 + 0.1,
            rotation: 0, color: glowColors[_rng.nextInt(3)],
            life: double.infinity, maxLife: double.infinity, type: ParticleType.glow,
          )); }
        case EffectType.floatingPlanets:
          for (int i = 0; i < 3; i++) { _particles.add(Particle2D(
            x: _rng.nextDouble() * _width, y: _rng.nextDouble() * _height,
            vx: (_rng.nextDouble() - 0.5) * 5, vy: (_rng.nextDouble() - 0.5) * 5,
            size: _rng.nextDouble() * 20 + 10, opacity: 0.8, rotation: _rng.nextDouble() * 6.28,
            color: pColors[_rng.nextInt(3)], life: double.infinity, maxLife: double.infinity,
            type: ParticleType.planet,
          )); }
        case EffectType.meteorShower:
          for (int i = 0; i < 5; i++) { _particles.add(_randomMeteor()); }
      }
    }
  }

  Particle2D _randomSpace() => Particle2D(
    x: _rng.nextDouble() * _width, y: _rng.nextDouble() * _height,
    vx: (_rng.nextDouble() - 0.5) * 15, vy: (_rng.nextDouble() - 0.5) * 15,
    size: _rng.nextDouble() * 2 + 0.5, opacity: _rng.nextDouble() * 0.8 + 0.2,
    rotation: 0, color: Colors.white, life: double.infinity, maxLife: double.infinity,
    type: ParticleType.space,
  );

  Particle2D _randomStar() {
    final colors = [Colors.white, const Color(0xFF00D4FF), const Color(0xFFFFF8E7), const Color(0xFF8B5CF6)];
    return Particle2D(
      x: _rng.nextDouble() * _width, y: _rng.nextDouble() * _height,
      vx: 0, vy: 0, size: _rng.nextDouble() * 2.5 + 1, opacity: _rng.nextDouble() * 0.5 + 0.5,
      rotation: _rng.nextDouble() * 6.28, rotationSpeed: (_rng.nextDouble() - 0.5) * 2,
      color: colors[_rng.nextInt(4)], life: double.infinity, maxLife: double.infinity,
      type: ParticleType.star,
    );
  }

  Particle2D _randomMeteor() => Particle2D(
    x: _rng.nextDouble() * _width, y: -20,
    vx: (_rng.nextDouble() - 0.3) * 100 - 100, vy: 150 + _rng.nextDouble() * 200,
    size: _rng.nextDouble() * 3 + 1.5, opacity: 1.0, rotation: atan2(150, -100),
    color: const Color(0xFFFFB300), life: 3.0 + _rng.nextDouble() * 2.0, maxLife: 5.0,
    type: ParticleType.meteor,
  );

  void _update() {
    const dt = 0.033;
    for (int i = _particles.length - 1; i >= 0; i--) {
      _particles[i].update(dt, _width, _height, _rng);
      if (_activeEffects.contains(EffectType.meteorShower) && _particles[i].type == ParticleType.meteor && !_particles[i].isAlive) {
        _particles[i] = _randomMeteor();
      }
    }
    _particleController.add(List.from(_particles));
  }

  void dispose() { _updateTimer?.cancel(); _particleController.close(); }
}
