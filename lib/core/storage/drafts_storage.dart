import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/evaluation_model.dart';

class DraftsStorage {
  static const String _keyDrafts = 'evaluation_drafts';
  static const int maxDrafts = 2;

  // ✅ Guardar borrador
  static Future<bool> saveDraft(Evaluation evaluation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingDrafts = await getAllDrafts();

      // Buscar si ya existe este borrador (por ID)
      final existingIndex = existingDrafts.indexWhere((d) => d.id == evaluation.id);

      if (existingIndex != -1) {
        // Actualizar borrador existente
        existingDrafts[existingIndex] = evaluation;
      } else {
        // Verificar límite de borradores
        if (existingDrafts.length >= maxDrafts) {
          // Eliminar el borrador más antiguo
          existingDrafts.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          existingDrafts.removeAt(0);
        }
        // Agregar nuevo borrador
        existingDrafts.add(evaluation);
      }

      // Guardar lista actualizada
      final draftsJson = existingDrafts.map((d) => d.toJson()).toList();
      final encoded = jsonEncode(draftsJson);
      await prefs.setString(_keyDrafts, encoded);

      print('✅ Borrador guardado: ${evaluation.id}');
      return true;
    } catch (e) {
      print('❌ Error guardando borrador: $e');
      return false;
    }
  }

  // ✅ Obtener todos los borradores
  static Future<List<Evaluation>> getAllDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsString = prefs.getString(_keyDrafts);

      if (draftsString == null || draftsString.isEmpty) {
        return [];
      }

      final List<dynamic> draftsJson = jsonDecode(draftsString);
      final drafts = draftsJson
          .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
          .toList();

      // Ordenar por fecha de actualización (más reciente primero)
      drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return drafts;
    } catch (e) {
      print('❌ Error cargando borradores: $e');
      return [];
    }
  }

  // ✅ Obtener borrador por ID
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

  // ✅ Eliminar borrador
  static Future<bool> deleteDraft(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final drafts = await getAllDrafts();

      drafts.removeWhere((d) => d.id == id);

      final draftsJson = drafts.map((d) => d.toJson()).toList();
      final encoded = jsonEncode(draftsJson);
      await prefs.setString(_keyDrafts, encoded);

      print('✅ Borrador eliminado: $id');
      return true;
    } catch (e) {
      print('❌ Error eliminando borrador: $e');
      return false;
    }
  }

  // ✅ Eliminar todos los borradores
  static Future<bool> deleteAllDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyDrafts);
      print('✅ Todos los borradores eliminados');
      return true;
    } catch (e) {
      print('❌ Error eliminando borradores: $e');
      return false;
    }
  }

  // ✅ Obtener cantidad de borradores
  static Future<int> getDraftsCount() async {
    final drafts = await getAllDrafts();
    return drafts.length;
  }

  // ✅ Verificar si hay espacio para nuevo borrador
  static Future<bool> canAddNewDraft() async {
    final count = await getDraftsCount();
    return count < maxDrafts;
  }

  // ✅ Obtener borradores por especie
  static Future<List<Evaluation>> getDraftsBySpecies(String speciesId) async {
    final drafts = await getAllDrafts();
    return drafts.where((d) => d.speciesId == speciesId).toList();
  }
}