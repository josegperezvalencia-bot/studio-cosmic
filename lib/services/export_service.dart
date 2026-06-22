import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportService {
  static final ExportService _instance = ExportService._();
  factory ExportService() => _instance;
  ExportService._();

  Future<String> exportFile(String name, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${dir.path}/exports');
    if (!await exportDir.exists()) await exportDir.create(recursive: true);
    final file = File('${exportDir.path}/$name');
    await file.writeAsString(content);
    return file.path;
  }

  Future<List<String>> getExportedFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${dir.path}/exports');
    if (await exportDir.exists()) {
      return exportDir.listSync().map((e) => e.path).toList();
    }
    return [];
  }
}
