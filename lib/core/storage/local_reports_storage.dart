// lib/core/storage/local_reports_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evaluation_model.dart';

class LocalReportsStorage {
  static const String _keyLocalReports = 'local_offline_reports';
  static const String _keyPendingSync = 'pending_sync_reports';
  static const int maxReports = 20;

  // ✅ Guardar reporte local (persistente)
  static Future<bool> saveLocalReport(Evaluation evaluation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingReports = await getAllLocalReports();

      // Verificar si ya existe (actualizar)
      final existingIndex = existingReports.indexWhere((r) => r.id == evaluation.id);
      
      if (existingIndex != -1) {
        existingReports[existingIndex] = evaluation;
      } else {
        if (existingReports.length >= maxReports) {
          existingReports.sort((a, b) => a.evaluationDate.compareTo(b.evaluationDate));
          existingReports.removeAt(0);
        }
        existingReports.add(evaluation);
      }

      final reportsJson = existingReports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(_keyLocalReports, encoded);

      // Marcar como pendiente de sincronización
      await _markAsPendingSync(evaluation.id);

      print('✅ Reporte local guardado: ${evaluation.id}');
      return true;
    } catch (e) {
      print('❌ Error guardando reporte local: $e');
      return false;
    }
  }

  // ✅ Obtener todos los reportes locales
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

  // ✅ Obtener reporte por ID
  static Future<Evaluation?> getLocalReportById(String id) async {
    try {
      final reports = await getAllLocalReports();
      return reports.firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Report not found'),
      );
    } catch (e) {
      print('❌ Reporte local no encontrado: $id');
      return null;
    }
  }

  // ✅ Eliminar reporte local
  static Future<bool> deleteLocalReport(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reports = await getAllLocalReports();

      reports.removeWhere((r) => r.id == id);

      final reportsJson = reports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(_keyLocalReports, encoded);

      // Quitar de pendientes de sincronización
      await _removeFromPendingSync(id);

      print('✅ Reporte local eliminado: $id');
      return true;
    } catch (e) {
      print('❌ Error eliminando reporte local: $e');
      return false;
    }
  }

  // ✅ Limpiar todos los reportes locales
  static Future<bool> clearAllLocalReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLocalReports);
      await prefs.remove(_keyPendingSync);
      print('✅ Todos los reportes locales eliminados');
      return true;
    } catch (e) {
      print('❌ Error eliminando reportes locales: $e');
      return false;
    }
  }

  // ✅ Obtener cantidad de reportes locales
  static Future<int> getLocalReportsCount() async {
    final reports = await getAllLocalReports();
    return reports.length;
  }

  // ═══════════════════════════════════════════════════════════
  // GESTIÓN DE SINCRONIZACIÓN
  // ═══════════════════════════════════════════════════════════

  // ✅ Marcar reporte como pendiente de sincronización
  static Future<void> _markAsPendingSync(String reportId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingIds = await getPendingSyncIds();
      
      if (!pendingIds.contains(reportId)) {
        pendingIds.add(reportId);
        await prefs.setStringList(_keyPendingSync, pendingIds);
      }
    } catch (e) {
      print('❌ Error marcando como pendiente: $e');
    }
  }

  // ✅ Quitar reporte de pendientes de sincronización
  static Future<void> _removeFromPendingSync(String reportId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingIds = await getPendingSyncIds();
      
      pendingIds.remove(reportId);
      await prefs.setStringList(_keyPendingSync, pendingIds);
    } catch (e) {
      print('❌ Error quitando de pendientes: $e');
    }
  }

  // ✅ Obtener IDs de reportes pendientes de sincronización
  static Future<List<String>> getPendingSyncIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_keyPendingSync) ?? [];
    } catch (e) {
      print('❌ Error obteniendo pendientes: $e');
      return [];
    }
  }

  // ✅ Obtener reportes pendientes de sincronización
  static Future<List<Evaluation>> getPendingSyncReports() async {
    try {
      final pendingIds = await getPendingSyncIds();
      final allReports = await getAllLocalReports();
      
      return allReports.where((r) => pendingIds.contains(r.id)).toList();
    } catch (e) {
      print('❌ Error obteniendo reportes pendientes: $e');
      return [];
    }
  }

  // ✅ Marcar reporte como sincronizado (moverlo a reportes normales)
  static Future<bool> markAsSynced(String reportId) async {
    try {
      await _removeFromPendingSync(reportId);
      print('✅ Reporte marcado como sincronizado: $reportId');
      return true;
    } catch (e) {
      print('❌ Error marcando como sincronizado: $e');
      return false;
    }
  }

  // ✅ Verificar si hay reportes pendientes de sincronización
  static Future<bool> hasPendingSyncReports() async {
    final pendingIds = await getPendingSyncIds();
    return pendingIds.isNotEmpty;
  }

  // ✅ Obtener cantidad de reportes pendientes
  static Future<int> getPendingSyncCount() async {
    final pendingIds = await getPendingSyncIds();
    return pendingIds.length;
  }
}