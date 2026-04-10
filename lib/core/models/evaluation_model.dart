import 'package:bian_app/core/models/species_model.dart';
import 'package:bian_app/core/models/user_model.dart';
import 'package:bian_app/core/storage/secure_storage.dart';

class Evaluation {
  final String id;
  final String speciesId;
  final String? productionType; // Tipo de producción para aves
  final String farmName;
  final String farmLocation;
  final DateTime evaluationDate;
  final String evaluatorName;
  final String evaluatorDocument;
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
    this.productionType,
    required this.farmName,
    required this.farmLocation,
    required this.evaluationDate,
    required this.evaluatorName,
    required this.evaluatorDocument,
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
    try {
      print('📦 Evaluation.fromJson - Claves en JSON: ${json.keys.toList()}');

      print(
          '📊 overallScore presente: ${json.containsKey('overallScore')} / overall_score: ${json.containsKey('overall_score')}');
      print('📊 overallScore valor raw: ${json['overallScore']} (tipo: ${json['overallScore']?.runtimeType})');

      print(
          '📊 categoryScores presente: ${json.containsKey('categoryScores')} / category_scores: ${json.containsKey('category_scores')}');
      print('📊 categoryScores valor raw: ${json['categoryScores']} (tipo: ${json['categoryScores']?.runtimeType})');

      print('📊 categories presente: ${json.containsKey('categories')}');

      // Debug de categories si existe

      if (json['categories'] != null) {
        print('📂 categories (raw): ${json['categories']}');

        if (json['categories'] is Map) {
          final cats = json['categories'] as Map;

          cats.forEach((key, value) {
            print('  📁 Categoría $key:');

            if (value is Map && value.containsKey('score')) {
              print('    Score: ${value['score']}');
            }
          });
        }
      }

      // Parse scores antes de crear el objeto
      final parsedOverallScore = _parseScore(json['overallScore']) ?? _parseScore(json['overall_score']);
      final parsedCategoryScores = _parseCategoryScores(json['categoryScores'] ?? json['category_scores']) ?? _extractCategoryScoresFromCategories(json['categories']);
      
      print('📊 PARSED overallScore: $parsedOverallScore');
      print('📊 PARSED categoryScores: $parsedCategoryScores');

      return Evaluation(
        id: json['id']?.toString() ?? '',
        speciesId: json['speciesId']?.toString() ??
            json['species']?.toString() ??
            'birds',
        productionType: json['productionType']?.toString() ??
            json['production_type']?.toString(),
        farmName:
            json['farmName']?.toString() ?? json['farm_name']?.toString() ?? '',
        farmLocation: json['farmLocation']?.toString() ??
            json['farm_location']?.toString() ??
            '',
        evaluationDate: json['evaluationDate'] != null
            ? DateTime.parse(json['evaluationDate'])
            : (json['evaluation_date'] != null
                ? DateTime.parse(json['evaluation_date'])
                : DateTime.now()),
        evaluatorName: json['evaluatorName']?.toString() ??
            json['evaluator_name']?.toString() ??
            '',
        evaluatorDocument: json['evaluatorDocument']?.toString() ??
            json['evaluator_document']?.toString() ??
            '',
        responses: json['responses'] != null
            ? Map<String, dynamic>.from(json['responses'])
            : (json['categories'] != null
                ? _parseCategoriesToResponses(json['categories'])
                : {}),
        overallScore: parsedOverallScore,
        categoryScores: parsedCategoryScores,
        status: json['status']?.toString() ?? 'completed',
        language: json['language']?.toString() ?? 'es',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : (json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now()),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : (json['updated_at'] != null
                ? DateTime.parse(json['updated_at'])
                : DateTime.now()),
        user: null,
      );
    } catch (e) {
      print('❌ Error parseando evaluación: $e');
      print('📦 JSON recibido: $json');
      rethrow;
    }
  }

  static double? _parseScore(dynamic score) {
    if (score == null) return null;
    if (score is double) return score;
    if (score is int) return score.toDouble();
    if (score is String) return double.tryParse(score);
    return null;
  }

  static Map<String, double>? _parseCategoryScores(dynamic scores) {
    print('🔍 _parseCategoryScores - Tipo recibido: ${scores.runtimeType}');

    print('🔍 _parseCategoryScores - Valor: $scores');

    if (scores == null) {
      print('❌ categoryScores es NULL');

      return null;
    }

    if (scores is Map) {
      print('✅ categoryScores es un Map con ${scores.length} entradas');

      scores.forEach((key, value) {
        print('  - $key: $value (tipo: ${value.runtimeType})');
      });

      final result = scores.map((key, value) {
        final parsedValue = _parseScore(value) ?? 0.0;

        print('  ✓ Parseado $key: $parsedValue');

        return MapEntry(key.toString(), parsedValue);
      });

      print('✅ categoryScores parseados: $result');

      return result;
    }

    print('❌ categoryScores no es un Map, es: ${scores.runtimeType}');
    return null;
  }

  static Map<String, double>? _extractCategoryScoresFromCategories(
      dynamic categories) {
    print(
        '🔍 _extractCategoryScoresFromCategories - Intentando extraer scores de categories');

    if (categories == null) {
      print('❌ categories es NULL');

      return null;
    }

    if (categories is Map) {
      final categoryScores = <String, double>{};

      categories.forEach((categoryKey, categoryData) {
        if (categoryData is Map && categoryData.containsKey('score')) {
          final score = _parseScore(categoryData['score']);

          if (score != null) {
            categoryScores[categoryKey.toString()] = score;

            print('  ✓ Extraído score de $categoryKey: $score');
          }
        }
      });

      if (categoryScores.isNotEmpty) {
        print('✅ categoryScores extraídos de categories: $categoryScores');

        return categoryScores;
      }
    }

    print('❌ No se pudieron extraer categoryScores de categories');

    return null;
  }

  static Map<String, dynamic> _parseCategoriesToResponses(dynamic categories) {
    final responses = <String, dynamic>{};
    if (categories is Map) {
      categories.forEach((categoryKey, categoryData) {
        if (categoryData is Map && categoryData['responses'] != null) {
          final categoryResponses = categoryData['responses'];
          if (categoryResponses is Map) {
            categoryResponses.forEach((fieldKey, value) {
              responses['${categoryKey}_$fieldKey'] = value;
            });
          }
        }
      });
    }
    return responses;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speciesId': speciesId,
      'productionType': productionType,
      'farmName': farmName,
      'farmLocation': farmLocation,
      'evaluationDate': evaluationDate.toIso8601String(),
      'evaluatorName': evaluatorName,
      'evaluatorDocument': evaluatorDocument,
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
    String? productionType,
    String? farmName,
    String? farmLocation,
    DateTime? evaluationDate,
    String? evaluatorName,
    String? evaluatorDocument,
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
      productionType: productionType ?? this.productionType,
      farmName: farmName ?? this.farmName,
      farmLocation: farmLocation ?? this.farmLocation,
      evaluationDate: evaluationDate ?? this.evaluationDate,
      evaluatorName: evaluatorName ?? this.evaluatorName,
      evaluatorDocument: evaluatorDocument ?? this.evaluatorDocument,
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

  Future<Map<String, dynamic>> generateStructuredJSON(
    Species species,
    Map<String, dynamic> results,
    List<String> translatedRecommendations, {
    bool isOfflineMode = false,
  }) async {
    String userId = 'OFFLINE';
    String connectionStatus = 'OFFLINE';

    try {
      final user = await _storage.getUser();
      if (user?.id != null && !isOfflineMode) {
        userId = user!.id.toString();
        connectionStatus = 'ONLINE';
      } else if (isOfflineMode && evaluatorDocument.isNotEmpty) {
        // En modo offline, usar el documento como user_id
        userId = evaluatorDocument;
        connectionStatus = 'OFFLINE';
      }
    } catch (e) {
      print('ℹ️ Usuario en modo offline: $userId');
      connectionStatus = 'OFFLINE';
      if (evaluatorDocument.isNotEmpty) {
        userId = evaluatorDocument;
      }
    }

    // Redondear el score a 2 decimales
    final overallScoreValue = (results['overall_score'] ?? 0.0) as double;
    final roundedScore = (overallScoreValue * 100).round() / 100;

    final structuredJson = <String, dynamic>{
      'connection_status': connectionStatus,
      'user_id': userId,
      'evaluation_date': evaluationDate.toIso8601String(),
      'language': language,
      'species': speciesId,
      // Incluir production_type solo para aves
      if (speciesId == 'birds' && productionType != null)
        'production_type': productionType,
      'farm_name': farmName,
      'farm_location': farmLocation,
      'evaluator_name': evaluatorName,
      'overall_score': roundedScore.toStringAsFixed(2),
      'compliance_level': (results['compliance_level'] ?? 'acceptable').toString(),
      'categories': _buildGenericCategories(species, results),
      'critical_points':
          _formatCriticalPoints(results['critical_points'] as List? ?? []),
      'strong_points':
          _formatStrongPoints(results['strong_points'] as List? ?? []),
      'recommendations': translatedRecommendations,
    };

    return structuredJson;
  }

  Map<String, dynamic> _buildGenericCategories(
    Species species,
    Map<String, dynamic> results,
  ) {
    final categories = <String, dynamic>{};

    for (var category in species.categories) {
      final categoryData = <String, dynamic>{};

      // Agregar score redondeado a 2 decimales
      if (results['category_scores'] != null &&
          results['category_scores'][category.id] != null) {
        final score = results['category_scores'][category.id] as double;
        categoryData['score'] = score.toStringAsFixed(2);
      } else {
        categoryData['score'] = '0.00';
      }

      // Agregar weight de la categoría
      categoryData['weight'] = category.weight.toStringAsFixed(2);

      // Agregar respuestas
      categoryData['responses'] = <String, String>{};
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = responses[key];
        final genericFieldId = _getGenericFieldId(field.id);
        categoryData['responses'][genericFieldId] = value?.toString() ?? '';
      }

      // Normalizar nombre de categoría: 'resource' -> 'resources' (plural)
      String categoryKey = category.id;
      if (categoryKey == 'resource') {
        categoryKey = 'resources';
      }

      categories[categoryKey] = categoryData;
    }

    return categories;
  }

  String _getGenericFieldId(String fieldId) {
    return fieldId.replaceAll('_pigs', '').replaceAll('_birds', '');
  }

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

  List<Map<String, String>> _formatStrongPoints(List strongPoints) {
    return strongPoints.map((point) {
      return {
        'category': point.toString(),
      };
    }).toList();
  }

  Map<String, dynamic> recalculateResults(Species species) {
    return {
      'overall_score': overallScore ?? 0.0,
      'compliance_level': 0.0,
      'category_scores': categoryScores ?? {},
      'critical_points': <String>[],
      'strong_points': <String>[],
    };
  }
}
