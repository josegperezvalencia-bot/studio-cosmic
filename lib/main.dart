import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/wallpaper_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/particle_provider.dart';
import 'providers/premium_provider.dart';
import 'providers/export_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ParticleProvider()),
        ChangeNotifierProvider(create: (_) => PremiumProvider()),
        ChangeNotifierProvider(create: (_) => ExportProvider()),
      ],
      child: const CosmicWallpaperApp(),
    ),
  );
}

class CosmicWallpaperApp extends StatelessWidget {
  const CosmicWallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Wallpaper Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
