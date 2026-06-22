import 'package:flutter/material.dart';
import 'wallpaper_layer.dart';
import 'effect_type.dart';

class WallpaperProject {
  String id;
  String name;
  List<WallpaperLayer> layers;
  List<EffectType> activeEffects;
  double parallaxSensitivity;
  Color backgroundColor;
  DateTime createdAt;

  WallpaperProject({
    required this.id,
    required this.name,
    this.layers = const [],
    this.activeEffects = const [],
    this.parallaxSensitivity = 1.0,
    this.backgroundColor = const Color(0xFF0A0A0F),
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
