import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../models/premium_feature.dart';
import '../utils/constants.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('PREMIUM'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [AppConstants.neonPurple.withAlpha(38), AppConstants.neonBlue.withAlpha(38)]),
              border: Border.all(color: AppConstants.hudAmber.withAlpha(77)),
            ),
            child: const Column(children: [
              Icon(Icons.workspace_premium, size: 48, color: AppConstants.hudAmber),
              SizedBox(height: 16),
              Text('COSMIC PREMIUM', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3)),
              SizedBox(height: 8),
              Text('Desbloquea todo el potencial', style: TextStyle(color: Colors.white54)),
            ]),
          ),
          const SizedBox(height: 24),
          ...PremiumFeature.values.map((f) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppConstants.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppConstants.neonBlue.withAlpha(51))),
            child: Row(children: [
              Icon(premium.hasFeature(f) ? Icons.check_circle : Icons.lock_outline,
                  color: premium.hasFeature(f) ? AppConstants.hudGreen : Colors.grey, size: 24),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(f.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                Text(f.description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ])),
            ]),
          )),
          const SizedBox(height: 24),
          HUDButton(
            label: premium.isPremium ? 'PREMIUM ACTIVADO' : 'ACTUALIZAR - \$4.99',
            icon: Icons.workspace_premium, color: AppConstants.hudAmber,
            onPressed: premium.isPremium ? null : () {
              context.read<PremiumProvider>().unlockPremium();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Premium activado!'), backgroundColor: AppConstants.hudAmber),
              );
            },
          ),
        ]),
      ),
    );
  }
}
