import 'package:uuid/uuid.dart';
import '../models/wallpaper_project.dart';
import '../models/wallpaper_layer.dart';

class AIService {
  static final AIService _instance = AIService._();
  factory AIService() => _instance;
  AIService._();

  final _uuid = const Uuid();

  WallpaperProject generateFromPrompt(String prompt) {
    final project = WallpaperProject(
      id: _uuid.v4(),
      name: prompt.length > 30 ? '${prompt.substring(0, 27)}...' : prompt,
    );

    final layers = <WallpaperLayer>[];
    layers.add(WallpaperLayer(id: _uuid.v4(), depth: -2.0, scale: 1.2, opacity: 0.9));

    final lower = prompt.toLowerCase();
    if (lower.contains('planeta')) {
      layers.add(WallpaperLayer(id: _uuid.v4(), depth: 1.0, scale: 0.8));
      layers.add(WallpaperLayer(id: _uuid.v4(), depth: 0.0, scale: 1.5, opacity: 0.4));
    }
    if (lower.contains('ciudad') || lower.contains('cyberpunk')) {
      for (int i = 0; i < 3; i++) {
        layers.add(WallpaperLayer(id: _uuid.v4(), depth: -1.0 + i * 1.5, scale: 1.0 + i * 0.1));
      }
    }
    if (lower.contains('galaxia') || lower.contains('nebulosa')) {
      layers.add(WallpaperLayer(id: _uuid.v4(), depth: -3.0, scale: 1.5, opacity: 0.6));
    }
    if (lower.contains('agujero') || lower.contains('black')) {
      layers.add(WallpaperLayer(id: _uuid.v4(), depth: 0.5, scale: 0.7, rotation: 0.5));
      layers.add(WallpaperLayer(id: _uuid.v4(), depth: 2.0, scale: 1.3, opacity: 0.7, rotation: 0.3));
    }

    project.layers = layers;
    return project;
  }
}
