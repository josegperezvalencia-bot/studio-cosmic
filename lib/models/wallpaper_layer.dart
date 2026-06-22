import 'package:flutter/material.dart';

class WallpaperLayer {
  String id;
  String imagePath;
  double depth;
  double offsetX;
  double offsetY;
  double scale;
  double rotation;
  double opacity;
  bool visible;

  WallpaperLayer({
    required this.id,
    this.imagePath = '',
    this.depth = 0.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.opacity = 1.0,
    this.visible = true,
  });

  WallpaperLayer copyWith({
    String? id,
    String? imagePath,
    double? depth,
    double? offsetX,
    double? offsetY,
    double? scale,
    double? rotation,
    double? opacity,
    bool? visible,
  }) =>
      WallpaperLayer(
        id: id ?? this.id,
        imagePath: imagePath ?? this.imagePath,
        depth: depth ?? this.depth,
        offsetX: offsetX ?? this.offsetX,
        offsetY: offsetY ?? this.offsetY,
        scale: scale ?? this.scale,
        rotation: rotation ?? this.rotation,
        opacity: opacity ?? this.opacity,
        visible: visible ?? this.visible,
      );

  Color get placeholderColor {
    final colors = [
      const Color(0xFF00D4FF),
      const Color(0xFF8B5CF6),
      const Color(0xFFFF1493),
      const Color(0xFF00FF88),
      const Color(0xFFFFB300),
       Colors.blueGrey,
    ];
    return colors[id.hashCode.abs() % colors.length];
  }
}
