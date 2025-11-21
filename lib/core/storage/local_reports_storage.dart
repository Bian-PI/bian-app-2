// lib/core/storage/local_reports_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evaluation_model.dart';

class LocalReportsStorage {
  static const String _keyLocalReports = 'local_offline_reports';
  static const int maxReports = 10;

  static Future<bool> saveLocalReport(Evaluation evaluation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingReports = await getAllLocalReports();

      if (existingReports.length >= maxReports) {
        existingReports.sort((a, b) => a.evaluationDate.compareTo(b.evaluationDate));
        existingReports.removeAt(0);
      }

      existingReports.add(evaluation);

      final reportsJson = existingReports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(_keyLocalReports, encoded);

      print('✅ Reporte local guardado: ${evaluation.id}');
      return true;
    } catch (e) {
      print('❌ Error guardando reporte local: $e');
      return false;
    }
  }

  static Future<List<Evaluation>> getAllLocalReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsString = prefs.getString(_keyLocalReports);

      if (reportsString == null || reportsString.isEmpty) {
        return [];
      }

      final List<dynamic> reportsJson = jsonDecode(reportsString);
      final reports = reportsJson
          .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
          .toList();

      reports.sort((a, b) => b.evaluationDate.compareTo(a.evaluationDate));

      return reports;
    } catch (e) {
      print('❌ Error cargando reportes locales: $e');
      return [];
    }
  }

  static Future<bool> deleteLocalReport(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reports = await getAllLocalReports();

      reports.removeWhere((r) => r.id == id);

      final reportsJson = reports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(_keyLocalReports, encoded);

      print('✅ Reporte local eliminado: $id');
      return true;
    } catch (e) {
      print('❌ Error eliminando reporte local: $e');
      return false;
    }
  }

  static Future<bool> clearAllLocalReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLocalReports);
      print('✅ Todos los reportes locales eliminados');
      return true;
    } catch (e) {
      print('❌ Error eliminando reportes locales: $e');
      return false;
    }
  }

  static Future<int> getLocalReportsCount() async {
    final reports = await getAllLocalReports();
    return reports.length;
  }
}