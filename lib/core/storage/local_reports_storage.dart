import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evaluation_model.dart';
import 'secure_storage.dart';

class LocalReportsStorage {
  static const String _keyLocalReportsPrefix = 'local_offline_reports_user_';
  static const String _keyPendingSyncPrefix = 'pending_sync_reports_user_';
  static const int maxReports = 20;
  static final _storage = SecureStorage();

  /// Genera la clave única para los reportes locales del usuario actual
  static Future<String?> _getUserLocalReportsKey() async {
    final user = await _storage.getUser();
    if (user == null) {
      print('⚠️ No hay usuario logueado, usando clave para modo offline');
      // En modo offline sin usuario, usar una clave especial
      return '${_keyLocalReportsPrefix}offline_mode';
    }
    return '$_keyLocalReportsPrefix${user.id}';
  }

  /// Genera la clave única para los reportes pendientes del usuario actual
  static Future<String?> _getUserPendingSyncKey() async {
    final user = await _storage.getUser();
    if (user == null) {
      // En modo offline sin usuario, usar una clave especial
      return '${_keyPendingSyncPrefix}offline_mode';
    }
    return '$_keyPendingSyncPrefix${user.id}';
  }

  static Future<bool> saveLocalReport(Evaluation evaluation) async {
    try {
      final key = await _getUserLocalReportsKey();
      if (key == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final existingReports = await getAllLocalReports();

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
      await prefs.setString(key, encoded);

      await _markAsPendingSync(evaluation.id);

      print('✅ Reporte local guardado para usuario: ${evaluation.id}');
      return true;
    } catch (e) {
      print('❌ Error guardando reporte local: $e');
      return false;
    }
  }

  static Future<List<Evaluation>> getAllLocalReports() async {
    try {
      final key = await _getUserLocalReportsKey();
      if (key == null) return [];

      final prefs = await SharedPreferences.getInstance();
      final reportsString = prefs.getString(key);

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

  static Future<bool> deleteLocalReport(String id) async {
    try {
      final key = await _getUserLocalReportsKey();
      if (key == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final reports = await getAllLocalReports();

      reports.removeWhere((r) => r.id == id);

      final reportsJson = reports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(reportsJson);
      await prefs.setString(key, encoded);

      await _removeFromPendingSync(id);

      print('✅ Reporte local eliminado: $id');
      return true;
    } catch (e) {
      print('❌ Error eliminando reporte local: $e');
      return false;
    }
  }

  static Future<bool> clearAllLocalReports() async {
    try {
      final reportsKey = await _getUserLocalReportsKey();
      final syncKey = await _getUserPendingSyncKey();
      if (reportsKey == null || syncKey == null) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(reportsKey);
      await prefs.remove(syncKey);
      print('✅ Todos los reportes locales del usuario eliminados');
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


  static Future<void> _markAsPendingSync(String reportId) async {
    try {
      final key = await _getUserPendingSyncKey();
      if (key == null) return;

      final prefs = await SharedPreferences.getInstance();
      final pendingIds = await getPendingSyncIds();

      if (!pendingIds.contains(reportId)) {
        pendingIds.add(reportId);
        await prefs.setStringList(key, pendingIds);
      }
    } catch (e) {
      print('❌ Error marcando como pendiente: $e');
    }
  }

  static Future<void> _removeFromPendingSync(String reportId) async {
    try {
      final key = await _getUserPendingSyncKey();
      if (key == null) return;

      final prefs = await SharedPreferences.getInstance();
      final pendingIds = await getPendingSyncIds();

      pendingIds.remove(reportId);
      await prefs.setStringList(key, pendingIds);
    } catch (e) {
      print('❌ Error quitando de pendientes: $e');
    }
  }

  static Future<List<String>> getPendingSyncIds() async {
    try {
      final key = await _getUserPendingSyncKey();
      if (key == null) return [];

      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(key) ?? [];
    } catch (e) {
      print('❌ Error obteniendo pendientes: $e');
      return [];
    }
  }

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

  static Future<bool> hasPendingSyncReports() async {
    final pendingIds = await getPendingSyncIds();
    return pendingIds.isNotEmpty;
  }

  static Future<int> getPendingSyncCount() async {
    final pendingIds = await getPendingSyncIds();
    return pendingIds.length;
  }

  /// Migra reportes offline al usuario que acaba de iniciar sesión
  /// Esto vincula evaluaciones creadas sin login a la cuenta del usuario
  static Future<int> migrateOfflineReportsToUser(int userId) async {
    try {
      print('🔄 Iniciando migración de reportes offline al usuario $userId...');

      final prefs = await SharedPreferences.getInstance();

      // 1. Obtener reportes offline (sin usuario)
      final offlineKey = '${_keyLocalReportsPrefix}offline_mode';
      final offlineReportsString = prefs.getString(offlineKey);

      if (offlineReportsString == null || offlineReportsString.isEmpty) {
        print('ℹ️ No hay reportes offline para migrar');
        return 0;
      }

      // 2. Parsear los reportes offline desde JSON
      final List<dynamic> offlineReportsJson = jsonDecode(offlineReportsString);

      print('📦 Encontrados ${offlineReportsJson.length} reportes offline');

      // 3. Convertir a objetos Evaluation
      final offlineReports = offlineReportsJson
          .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
          .toList();

      final updatedReports = offlineReports.map((report) {
        // Actualizar el userId en el reporte
        // Nota: Evaluation no tiene userId directo, pero lo usaremos al sincronizar
        return report; // El userId se agrega al sincronizar
      }).toList();

      // 4. Obtener reportes existentes del usuario (si los hay)
      final userKey = '$_keyLocalReportsPrefix$userId';
      final userReportsString = prefs.getString(userKey);

      List<Evaluation> existingUserReports = [];
      if (userReportsString != null && userReportsString.isNotEmpty) {
        final List<dynamic> existingJson = jsonDecode(userReportsString);
        existingUserReports = existingJson
            .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // 5. Combinar reportes existentes del usuario con los offline migrados
      final allReports = [
        ...existingUserReports,
        ...updatedReports,
      ];

      // 6. Guardar todos los reportes combinados como JSON
      final allReportsJson = allReports.map((r) => r.toJson()).toList();
      final encoded = jsonEncode(allReportsJson);
      await prefs.setString(userKey, encoded);

      // 7. Marcar todos los reportes migrados como pendientes de sincronización
      final userPendingKey = '$_keyPendingSyncPrefix$userId';
      final pendingIds = prefs.getStringList(userPendingKey) ?? [];

      for (var report in updatedReports) {
        if (!pendingIds.contains(report.id)) {
          pendingIds.add(report.id);
        }
      }

      await prefs.setStringList(userPendingKey, pendingIds);

      // 8. Limpiar reportes offline
      await prefs.remove(offlineKey);
      await prefs.remove('${_keyPendingSyncPrefix}offline_mode');

      print('✅ Migrados ${updatedReports.length} reportes offline al usuario $userId');
      print('📌 Todos marcados como pendientes de sincronización');

      return updatedReports.length;
    } catch (e) {
      print('❌ Error migrando reportes offline: $e');
      return 0;
    }
  }
}