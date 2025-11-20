import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evaluation_model.dart';

class ReportsStorage {
  static const String _keyReports = 'completed_reports';

  // ✅ Guardar reporte completado
  static Future<bool> saveReport(Evaluation evaluation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingReports = await getAllReports();

      // Verificar si ya existe (por ID)
      final existingIndex = existingReports.indexWhere((r) => r.id == evaluation.id);

      if (existingIndex != -1) {
        existingReports[existingIndex] = evaluation;
      } else {
        existingReports.add(evaluation);
      }

      // Ordenar por fecha (más reciente primero)
      existingReports.sort((a, b) => b.evaluationDate.compareTo(a.evaluationDate));

      final reportsJson = existingReports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(_keyReports, encoded);

      print('✅ Reporte guardado: ${evaluation.id}');
      return true;
    } catch (e) {
      print('❌ Error guardando reporte: $e');
      return false;
    }
  }

  // ✅ Obtener todos los reportes
  static Future<List<Evaluation>> getAllReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsString = prefs.getString(_keyReports);

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
      print('❌ Error cargando reportes: $e');
      return [];
    }
  }

  // ✅ Obtener reporte por ID
  static Future<Evaluation?> getReportById(String id) async {
    try {
      final reports = await getAllReports();
      return reports.firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Report not found'),
      );
    } catch (e) {
      print('❌ Reporte no encontrado: $id');
      return null;
    }
  }

  // ✅ Eliminar reporte
  static Future<bool> deleteReport(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reports = await getAllReports();

      reports.removeWhere((r) => r.id == id);

      final reportsJson = reports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(_keyReports, encoded);

      print('✅ Reporte eliminado: $id');
      return true;
    } catch (e) {
      print('❌ Error eliminando reporte: $e');
      return false;
    }
  }

  // ✅ Obtener reportes por especie
  static Future<List<Evaluation>> getReportsBySpecies(String speciesId) async {
    final reports = await getAllReports();
    return reports.where((r) => r.speciesId == speciesId).toList();
  }

  // ✅ Obtener cantidad de reportes
  static Future<int> getReportsCount() async {
    final reports = await getAllReports();
    return reports.length;
  }

  // ✅ Obtener granjas únicas
  static Future<Set<String>> getUniqueFarms() async {
    final reports = await getAllReports();
    return reports.map((r) => r.farmName).toSet();
  }
}