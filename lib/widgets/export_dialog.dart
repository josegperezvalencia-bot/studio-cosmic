import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/export_provider.dart';
import '../providers/premium_provider.dart';
import '../models/wallpaper_project.dart';
import '../models/premium_feature.dart';
import '../utils/constants.dart';
import 'hud_widgets.dart';

class ExportDialog extends StatelessWidget {
  final WallpaperProject project;
  const ExportDialog({super.key, required this.project});

  static Future<void> show(BuildContext context, WallpaperProject project) {
    return showDialog(context: context, builder: (context) => ExportDialog(project: project));
  }

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();
    final export = context.watch<ExportProvider>();

    return AlertDialog(
      backgroundColor: AppConstants.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppConstants.hudGreen, width: 0.5)),
      title: const Text('EXPORTAR', style: TextStyle(color: AppConstants.hudGreen, letterSpacing: 2)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _option(context, Icons.wallpaper, 'Fondo Animado', false, () => _export(context, 'wallpaper.dat')),
        const SizedBox(height: 8),
        _option(context, Icons.image, 'Imagen 4K', !premium.hasFeature(PremiumFeature.export4K), () => _export(context, '${project.id}_4k.png')),
        const SizedBox(height: 8),
        _option(context, Icons.gif, 'GIF Animado', !premium.hasFeature(PremiumFeature.gifExport), () => _export(context, '${project.id}.gif')),
        const SizedBox(height: 8),
        _option(context, Icons.videocam, 'Video MP4', !premium.hasFeature(PremiumFeature.mp4Export), () => _export(context, '${project.id}.mp4')),
        if (export.isExporting) ...[
          const SizedBox(height: 12),
          LinearProgressIndicator(value: export.exportProgress, backgroundColor: AppConstants.darkSurface, valueColor: const AlwaysStoppedAnimation(AppConstants.hudGreen)),
          const SizedBox(height: 4),
          Text('${(export.exportProgress * 100).toInt()}%', style: const TextStyle(color: AppConstants.hudGreen)),
        ],
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CERRAR', style: TextStyle(color: AppConstants.neonBlue)))],
    );
  }

  Widget _option(BuildContext context, IconData icon, String label, bool locked, VoidCallback onTap) {
    return GestureDetector(
      onTap: locked ? () => _showLocked(context) : onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstants.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: locked ? Colors.grey.withAlpha(77) : AppConstants.neonBlue.withAlpha(77), width: 0.5),
        ),
        child: Row(children: [
          Icon(icon, color: locked ? Colors.grey : AppConstants.neonBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: locked ? Colors.grey : Colors.white, fontWeight: FontWeight.w600))),
          if (locked) const Icon(Icons.lock, color: Colors.grey, size: 18),
        ]),
      ),
    );
  }

  void _export(BuildContext context, String filename) async {
    Navigator.pop(context);
    await context.read<ExportProvider>().exportFile(filename, project.name);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exportado exitosamente'), backgroundColor: AppConstants.hudGreen),
      );
    }
  }

  void _showLocked(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función premium. ¡Actualiza para desbloquear!'), backgroundColor: AppConstants.hudAmber),
    );
  }
}
