import 'package:flutter/material.dart';
import '../models/premium_feature.dart';

class PremiumProvider extends ChangeNotifier {
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  bool hasFeature(PremiumFeature feature) => _isPremium;

  void unlockPremium() {
    _isPremium = true;
    notifyListeners();
  }
}
