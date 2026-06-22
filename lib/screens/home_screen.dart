import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/particle_provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../widgets/parallax_preview.dart';
import '../widgets/layer_widget.dart';
import '../widgets/effect_card.dart';
import '../widgets/export_dialog.dart';
import '../widgets/particle_canvas.dart';
import '../models/effect_type.dart';
import '../utils/constants.dart';
import 'preview_screen.dart';
import 'ai_generator_screen.dart';
import 'gallery_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final _screens = const [_CreatorTab(), _GalleryTab(), _SettingsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentNavIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: AppConstants.neonBlue.withAlpha(38), width: 0.5))),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (i) => setState(() => _currentNavIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'CREAR'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'GALERÍA'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'AJUSTES'),
          ],
        ),
      ),
    );
  }
}

class _CreatorTab extends StatelessWidget {
  const _CreatorTab();

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.watch<WallpaperProvider>();
    final sensor = context.watch<SensorProvider>();

    if (wallpaper.currentProject == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('COSMIC WALLPAPER STUDIO')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppConstants.neonBlue.withAlpha(77), width: 2),
                boxShadow: [BoxShadow(color: AppConstants.neonBlue.withAlpha(26), blurRadius: 30, spreadRadius: 5)],
              ),
              child: const Icon(Icons.dashboard_customize, size: 56, color: AppConstants.neonBlue),
            ),
            const SizedBox(height: 32),
            const Text('COSMIC WALLPAPER', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4)),
            const SizedBox(height: 8),
            const Text('STUDIO', style: TextStyle(fontSize: 16, color: AppConstants.neonBlue, letterSpacing: 8)),
            const SizedBox(height: 40),
            HUDButton(label: 'NUEVO PROYECTO', icon: Icons.add, onPressed: () => wallpaper.createNewProject()),
            const SizedBox(height: 16),
            HUDButton(label: 'GENERAR CON IA', icon: Icons.auto_awesome, color: AppConstants.neonPurple, onPressed: () => _openAI(context)),
          ]),
        ),
      );
    }

    final project = wallpaper.currentProject!;
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(icon: const Icon(Icons.preview), onPressed: () => _showPreview(context)),
          IconButton(icon: const Icon(Icons.auto_awesome), onPressed: () => _openAI(context)),
          IconButton(icon: const Icon(Icons.save_outlined), onPressed: () => wallpaper.saveProject()),
        ],
      ),
      body: Column(children: [
        Expanded(flex: 3, child: _buildPreview(context, wallpaper, sensor)),
        Expanded(flex: 4, child: _buildEditor(context, wallpaper)),
      ]),
    );
  }

  Widget _buildPreview(BuildContext context, WallpaperProvider wallpaper, SensorProvider sensor) {
    final project = wallpaper.currentProject!;
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.neonBlue.withAlpha(51), width: 0.5),
        color: project.backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(children: [
          for (final layer in project.layers.where((l) => l.visible))
            Positioned.fill(
              child: ParallaxPreview(sensitivity: project.parallaxSensitivity * layer.depth,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(layer.offsetX * MediaQuery.of(context).size.width, layer.offsetY * MediaQuery.of(context).size.height)
                    ..rotateZ(layer.rotation)..scale(layer.scale),
                  child: Opacity(opacity: layer.opacity, child: Container(
                    decoration: BoxDecoration(
                      color: layer.placeholderColor.withAlpha(77),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                ),
              ),
            ),
          if (project.layers.isEmpty)
            const Center(child: Text('Añade capas para comenzar', style: TextStyle(color: Colors.white24))),
          Positioned(top: 8, right: 8, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppConstants.darkBg.withAlpha(179), borderRadius: BorderRadius.circular(4)),
            child: Text('SENS: ${project.parallaxSensitivity.toStringAsFixed(1)}x', style: const TextStyle(color: AppConstants.neonBlue, fontSize: 10, fontWeight: FontWeight.w600)),
          )),
        ]),
      ),
    );
  }

  Widget _buildEditor(BuildContext context, WallpaperProvider wallpaper) {
    return DefaultTabController(
      length: 3,
      child: Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppConstants.neonBlue.withAlpha(38), width: 0.5))),
          child: const TabBar(
            indicatorColor: AppConstants.neonBlue,
            labelColor: AppConstants.neonBlue,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(icon: Icon(Icons.layers), text: 'CAPAS'), Tab(icon: Icon(Icons.auto_fix_high), text: 'EFECTOS'), Tab(icon: Icon(Icons.tune), text: 'AJUSTES')],
          ),
        ),
        Expanded(child: TabBarView(children: [
          _layersTab(context, wallpaper),
          _effectsTab(context, wallpaper),
          _settingsTab(context, wallpaper),
        ])),
      ]),
    );
  }

  Widget _layersTab(BuildContext context, WallpaperProvider wallpaper) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: HUDButton(label: 'AÑADIR CAPA', icon: Icons.add, onPressed: () => wallpaper.addLayer()),
        ),
        if (wallpaper.selectedLayer != null)
          LayerEditorWidget(layer: wallpaper.selectedLayer!, onChanged: (l) {
            if (wallpaper.selectedLayerIndex >= 0) wallpaper.updateLayer(wallpaper.selectedLayerIndex, l);
          }),
        LayerListWidget(
          layers: wallpaper.currentProject!.layers,
          selectedIndex: wallpaper.selectedLayerIndex,
          onSelect: wallpaper.selectLayer,
          onDelete: wallpaper.removeLayer,
          onReorder: wallpaper.reorderLayer,
        ),
      ]),
    );
  }

  Widget _effectsTab(BuildContext context, WallpaperProvider wallpaper) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('EFECTOS DISPONIBLES', style: TextStyle(color: AppConstants.neonBlue, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.9),
          itemCount: EffectType.values.length,
          itemBuilder: (context, index) {
            final effect = EffectType.values[index];
            return EffectCard(
              effect: effect,
              isActive: wallpaper.currentProject!.activeEffects.contains(effect),
              onToggle: () => wallpaper.toggleEffect(effect),
            );
          },
        ),
      ]),
    );
  }

  Widget _settingsTab(BuildContext context, WallpaperProvider wallpaper) {
    final project = wallpaper.currentProject!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        HUDPanel(title: 'Parallax', icon: Icons.zoom_out_map, child: HUDSlider(
          label: 'Sensibilidad', value: project.parallaxSensitivity, min: 0, max: 3, divisions: 300,
          onChanged: wallpaper.setParallaxSensitivity, displayValue: (v) => '${v.toStringAsFixed(1)}x',
        )),
        HUDPanel(title: 'Proyecto', icon: Icons.info_outline, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nombre: ${project.name}', style: const TextStyle(color: Colors.white70)),
          Text('Capas: ${project.layers.length}/10', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          HUDButton(label: 'RENOMBRAR', icon: Icons.edit, onPressed: () => _rename(context, wallpaper)),
        ])),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: HUDButton(label: 'VISTA PREVIA', icon: Icons.play_arrow, onPressed: () => _showPreview(context))),
            const SizedBox(width: 12),
            Expanded(child: HUDButton(label: 'EXPORTAR', icon: Icons.file_download, color: AppConstants.hudGreen, onPressed: () => ExportDialog.show(context, project))),
          ]),
        ),
      ]),
    );
  }

  void _showPreview(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviewScreen()));
  void _openAI(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIGeneratorScreen()));

  void _rename(BuildContext context, WallpaperProvider wallpaper) {
    final ctrl = TextEditingController(text: wallpaper.currentProject?.name);
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppConstants.darkCard,
      title: const Text('Renombrar', style: TextStyle(color: AppConstants.neonBlue)),
      content: TextField(controller: ctrl, style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        TextButton(onPressed: () { wallpaper.renameProject(ctrl.text); Navigator.pop(ctx); }, child: const Text('Guardar')),
      ],
    ));
  }
}

class _GalleryTab extends StatelessWidget {
  const _GalleryTab();
  @override
  Widget build(BuildContext context) => const GalleryScreen();
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();
  @override
  Widget build(BuildContext context) => const SettingsScreen();
}
