import 'package:bian_app/core/models/species_model.dart';

class Evaluation {
  final String id;
  final String speciesId;
  final String farmName;
  final String farmLocation;
  final DateTime evaluationDate;
  final String evaluatorName;
  final Map<String, dynamic> responses; // categoryId_fieldId: value
  final double? overallScore;
  final Map<String, double>? categoryScores;
  final String status; // 'draft', 'completed'
  final DateTime createdAt;
  final DateTime updatedAt;

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
    this.status = 'draft',
    required this.createdAt,
    required this.updatedAt,
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
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calcular progreso de la evaluación
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

  // Verificar si la evaluación está completa
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

  // ✅ NUEVO: Generar JSON con nombres de campos en INGLÉS (nombres técnicos)
  Map<String, dynamic> generateTechnicalJSON(Species species) {
    final jsonData = <String, dynamic>{
      'evaluation_id': id,
      'evaluation_date': evaluationDate.toIso8601String(),
      'species': speciesId, // 'birds' o 'pigs'
      'farm': {
        'name': farmName,
        'location': farmLocation,
      },
      'evaluator_name': evaluatorName,
      'status': status,
      'categories': {},
    };

    // Recorrer todas las categorías y campos
    for (var category in species.categories) {
      final categoryData = <String, dynamic>{};
      
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = responses[key];
        
        // Usar el ID del campo (nombre técnico en inglés)
        dynamic processedValue;
        if (value == null) {
          processedValue = null;
        } else if (value is bool) {
          processedValue = value; // true/false directo
        } else if (value is num) {
          processedValue = value;
        } else {
          processedValue = value.toString();
        }
        
        categoryData[field.id] = processedValue;
      }
      
      jsonData['categories'][category.id] = categoryData;
    }

    return jsonData;
  }

  // ✅ NUEVO: Generar resumen legible (para mostrar al usuario)
  String generateReadableSummary(Species species) {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════════════════════════');
    buffer.writeln('EVALUATION REPORT - BIAN');
    buffer.writeln('═══════════════════════════════════════════════════════════');
    buffer.writeln('ID: $id');
    buffer.writeln('Species: $speciesId');
    buffer.writeln('Farm: $farmName ($farmLocation)');
    buffer.writeln('Evaluator: $evaluatorName');
    buffer.writeln('Date: ${evaluationDate.toIso8601String()}');
    buffer.writeln('Status: $status');
    buffer.writeln('Progress: ${(getProgress(species) * 100).toStringAsFixed(1)}%');
    buffer.writeln('───────────────────────────────────────────────────────────');
    
    for (var category in species.categories) {
      buffer.writeln('');
      buffer.writeln('${category.name.toUpperCase()} (${category.id}):');
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = responses[key];
        buffer.writeln('  - ${field.id}: ${value ?? "null"}');
      }
    }
    
    buffer.writeln('═══════════════════════════════════════════════════════════');
    return buffer.toString();
  }
}