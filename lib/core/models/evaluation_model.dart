// lib/core/models/evaluation_model.dart

import 'package:bian_app/core/models/species_model.dart';
import 'package:bian_app/core/models/user_model.dart';
import 'package:bian_app/core/storage/secure_storage.dart';

class Evaluation {
  final String id;
  final String speciesId;
  final String farmName;
  final String farmLocation;
  final DateTime evaluationDate;
  final String evaluatorName;
  final Map<String, dynamic> responses;
  final double? overallScore;
  final Map<String, double>? categoryScores;
  final String status;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;

  final User? user;

  final SecureStorage _storage = SecureStorage();

  Evaluation({
    required this.id,
    required this.speciesId,
    required this.farmName,
    required this.farmLocation,
    required this.evaluationDate,
    required this.evaluatorName,
    required this.responses,
    this.overallScore,
    this.categoryScores,
    required this.status,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      speciesId: json['speciesId'],
      farmName: json['farmName'],
      farmLocation: json['farmLocation'],
      evaluationDate: DateTime.parse(json['evaluationDate']),
      evaluatorName: json['evaluatorName'],
      responses: Map<String, dynamic>.from(json['responses']),
      overallScore: json['overallScore']?.toDouble(),
      categoryScores: json['categoryScores'] != null
          ? Map<String, double>.from(json['categoryScores'])
          : null,
      status: json['status'] ?? 'draft',
      language: json['language'] ?? 'es',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speciesId': speciesId,
      'farmName': farmName,
      'farmLocation': farmLocation,
      'evaluationDate': evaluationDate.toIso8601String(),
      'evaluatorName': evaluatorName,
      'responses': responses,
      'overallScore': overallScore,
      'categoryScores': categoryScores,
      'status': status,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Evaluation copyWith({
    String? id,
    String? speciesId,
    String? farmName,
    String? farmLocation,
    DateTime? evaluationDate,
    String? evaluatorName,
    Map<String, dynamic>? responses,
    double? overallScore,
    Map<String, double>? categoryScores,
    String? status,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Evaluation(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      farmName: farmName ?? this.farmName,
      farmLocation: farmLocation ?? this.farmLocation,
      evaluationDate: evaluationDate ?? this.evaluationDate,
      evaluatorName: evaluatorName ?? this.evaluatorName,
      responses: responses ?? this.responses,
      overallScore: overallScore ?? this.overallScore,
      categoryScores: categoryScores ?? this.categoryScores,
      status: status ?? this.status,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  double getProgress(Species species) {
    int totalFields = 0;
    int completedFields = 0;

    for (var category in species.categories) {
      for (var field in category.fields) {
        totalFields++;
        final key = '${category.id}_${field.id}';
        if (responses.containsKey(key) && responses[key] != null) {
          completedFields++;
        }
      }
    }

    return totalFields > 0 ? completedFields / totalFields : 0.0;
  }

  bool isComplete(Species species) {
    for (var category in species.categories) {
      for (var field in category.fields) {
        if (field.required) {
          final key = '${category.id}_${field.id}';
          if (!responses.containsKey(key) || responses[key] == null) {
            return false;
          }
        }
      }
    }
    return true;
  }

  // 🔥 JSON GENÉRICO - TODO EN STRINGS
  Future<Map<String, dynamic>> generateStructuredJSON(
    Species species,
    Map<String, dynamic> results,
    List<String> translatedRecommendations,
  ) async {
    final user = await _storage.getUser();

    final structuredJson = <String, dynamic>{
      'user_id': user?.id?.toString() ?? '',
      'evaluation_id': id,
      'evaluation_date': evaluationDate.toIso8601String(),
      'language': language,
      'species': speciesId,
      'farm_name': farmName,
      'farm_location': farmLocation,
      'evaluator_name': evaluatorName,
      'status': status,
      'overall_score': results['overall_score'].toString(),
      'compliance_level': results['compliance_level'].toString(),
      'categories': _buildGenericCategories(species, results),
      'critical_points': _formatCriticalPoints(results['critical_points']),
      'strong_points': _formatStrongPoints(results['strong_points']),
      'recommendations': translatedRecommendations,
    };

    return structuredJson;
  }

  // ✅ Construir categorías de forma genérica - TODO EN STRINGS
  Map<String, dynamic> _buildGenericCategories(
    Species species,
    Map<String, dynamic> results,
  ) {
    final categories = <String, dynamic>{};

    for (var category in species.categories) {
      final categoryData = <String, dynamic>{};

      // Agregar score de la categoría COMO STRING
      if (results['category_scores'] != null &&
          results['category_scores'][category.id] != null) {
        categoryData['score'] = results['category_scores'][category.id].toString();
      }

      // Agregar respuestas de los campos de forma genérica COMO STRINGS
      categoryData['responses'] = <String, String>{};
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = responses[key];
        
        // Usar el ID del campo sin el sufijo de especie
        final genericFieldId = _getGenericFieldId(field.id);
        categoryData['responses'][genericFieldId] = value?.toString() ?? '';
      }

      categories[category.id] = categoryData;
    }

    return categories;
  }

  // ✅ Obtener ID genérico del campo (sin sufijos como _pigs, _birds)
  String _getGenericFieldId(String fieldId) {
    // Remover sufijos específicos de especie
    return fieldId
        .replaceAll('_pigs', '')
        .replaceAll('_birds', '');
  }

  // ✅ Formatear puntos críticos de forma legible
  List<Map<String, String>> _formatCriticalPoints(List criticalPoints) {
    return criticalPoints.map((point) {
      final parts = point.toString().split('_');
      final categoryId = parts[0];
      final fieldId = parts.sublist(1).join('_');
      
      return {
        'category': categoryId,
        'field': _getGenericFieldId(fieldId),
        'full_id': point.toString(),
      };
    }).toList();
  }

  // ✅ Formatear puntos fuertes
  List<Map<String, String>> _formatStrongPoints(List strongPoints) {
    return strongPoints.map((point) {
      return {
        'category': point.toString(),
      };
    }).toList();
  }
}