import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evaluation_model.dart';
import 'secure_storage.dart';

class DraftsStorage {
  static const String _keyDraftsPrefix = 'evaluation_drafts_user_';
  static const int maxDrafts = 2;
  static final _storage = SecureStorage();

  /// Genera la clave única para los borradores del usuario actual
  static Future<String?> _getUserDraftsKey() async {
    final user = await _storage.getUser();
    if (user == null) {
      print('⚠️ No hay usuario logueado, no se puede guardar borrador');
      return null;
    }
    return '$_keyDraftsPrefix${user.id}';
  }

  static Future<bool> saveDraft(Evaluation evaluation) async {
    try {
      final key = await _getUserDraftsKey();
      if (key == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final existingDrafts = await getAllDrafts();

      final existingIndex = existingDrafts.indexWhere((d) => d.id == evaluation.id);

      if (existingIndex != -1) {
        existingDrafts[existingIndex] = evaluation;
      } else {
        if (existingDrafts.length >= maxDrafts) {
          existingDrafts.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          existingDrafts.removeAt(0);
        }
        existingDrafts.add(evaluation);
      }

      final draftsJson = existingDrafts.map((d) => d.toJson()).toList();
      final encoded = jsonEncode(draftsJson);
      await prefs.setString(key, encoded);

      print('✅ Borrador guardado para usuario: ${evaluation.id}');
      return true;
    } catch (e) {
      print('❌ Error guardando borrador: $e');
      return false;
    }
  }

  static Future<List<Evaluation>> getAllDrafts() async {
    try {
      final key = await _getUserDraftsKey();
      if (key == null) return [];

      final prefs = await SharedPreferences.getInstance();
      final draftsString = prefs.getString(key);

      if (draftsString == null || draftsString.isEmpty) {
        return [];
      }

      final List<dynamic> draftsJson = jsonDecode(draftsString);
      final drafts = draftsJson
          .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
          .toList();

      drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return drafts;
    } catch (e) {
      print('❌ Error cargando borradores: $e');
      return [];
    }
  }

  static Future<Evaluation?> getDraftById(String id) async {
    try {
      final drafts = await getAllDrafts();
      return drafts.firstWhere(
        (d) => d.id == id,
        orElse: () => throw Exception('Draft not found'),
      );
    } catch (e) {
      print('❌ Borrador no encontrado: $id');
      return null;
    }
  }

  static Future<bool> deleteDraft(String id) async {
    try {
      final key = await _getUserDraftsKey();
      if (key == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final drafts = await getAllDrafts();

      drafts.removeWhere((d) => d.id == id);

      final draftsJson = drafts.map((d) => d.toJson()).toList();
      final encoded = jsonEncode(draftsJson);
      await prefs.setString(key, encoded);

      print('✅ Borrador eliminado: $id');
      return true;
    } catch (e) {
      print('❌ Error eliminando borrador: $e');
      return false;
    }
  }

  static Future<bool> deleteAllDrafts() async {
    try {
      final key = await _getUserDraftsKey();
      if (key == null) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      print('✅ Todos los borradores del usuario eliminados');
      return true;
    } catch (e) {
      print('❌ Error eliminando borradores: $e');
      return false;
    }
  }

  static Future<int> getDraftsCount() async {
    final drafts = await getAllDrafts();
    return drafts.length;
  }

  static Future<bool> canAddNewDraft() async {
    final count = await getDraftsCount();
    return count < maxDrafts;
  }

  static Future<List<Evaluation>> getDraftsBySpecies(String speciesId) async {
    final drafts = await getAllDrafts();
    return drafts.where((d) => d.speciesId == speciesId).toList();
  }
}