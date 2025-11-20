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
      user: null, // si quieres luego cargarlo, hazlo fuera
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

  // 🔥 JSON estructurado, ahora async
  Future<Map<String, dynamic>> generateStructuredJSON(
    Species species,
    Map<String, dynamic> results,
    List<String> translatedRecommendations,
  ) async {

    final user = await _storage.getUser();

    final structuredJson = <String, dynamic>{
      'user_id': user?.id,
      'evaluation_id': id,
      'evaluation_date': evaluationDate.toIso8601String(),
      'language': language,
      'species': speciesId,
      'farm_name': farmName,
      'farm_location': farmLocation,
      'evaluator_name': evaluatorName,
      'status': status,
      'overall_score': results['overall_score'],
      'compliance_level': results['compliance_level'],
      'categories': {},
    };

    for (var category in species.categories) {
      final categoryData = <String, dynamic>{};

      if (results['category_scores'] != null &&
          results['category_scores'][category.id] != null) {
        categoryData['score'] = results['category_scores'][category.id];
      }

      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = responses[key];
        categoryData[field.id] = value;
      }

      structuredJson['categories'][category.id] = categoryData;
    }

    structuredJson['critical_points'] = results['critical_points'];
    structuredJson['strong_points'] = results['strong_points'];
    structuredJson['recommendations'] = translatedRecommendations;

    return structuredJson;
  }
}
