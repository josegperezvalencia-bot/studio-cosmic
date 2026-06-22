import 'package:flutter/material.dart';
import '../services/export_service.dart';

class ExportProvider extends ChangeNotifier {
  final ExportService _exportService = ExportService();
  bool _isExporting = false;
  double _exportProgress = 0;
  String? _lastExportPath;

  bool get isExporting => _isExporting;
  double get exportProgress => _exportProgress;
  String? get lastExportPath => _lastExportPath;

  Future<String> exportFile(String name, String content) async {
    _isExporting = true;
    _exportProgress = 0;
    notifyListeners();

    for (double i = 0; i <= 1; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 50));
      _exportProgress = i;
      notifyListeners();
    }

    final path = await _exportService.exportFile(name, content);
    _lastExportPath = path;
    _exportProgress = 1.0;
    _isExporting = false;
    notifyListeners();
    return path;
  }
}
