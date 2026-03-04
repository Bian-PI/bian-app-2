import 'package:intl/intl.dart';
import '../models/dashboard_stats.dart';
import '../api/api_service.dart';
import '../storage/secure_storage.dart';

class DashboardService {
  static final _storage = SecureStorage();
  static final _apiService = ApiService();
  static final _months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

  /// Obtiene estadísticas del dashboard desde el servidor
  static Future<DashboardStats> getStats() async {
    try {
      final user = await _storage.getUser();
      if (user == null) return DashboardStats.empty();

      // Obtener evaluaciones del usuario
      final result = await _apiService.getUserEvaluations(limit: 100, offset: 0);
      
      if (result['success'] != true) {
        print('Error getting evaluations: ${result['message']}');
        return DashboardStats.empty();
      }
      
      final evaluations = (result['evaluations'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      
      if (evaluations.isEmpty) {
        return DashboardStats.empty();
      }

      return _calculateStats(evaluations);
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return DashboardStats.empty();
    }
  }

  /// Calcula estadísticas a partir de lista de evaluaciones
  static DashboardStats _calculateStats(List<Map<String, dynamic>> evaluations) {
    if (evaluations.isEmpty) return DashboardStats.empty();

    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

    // Variables para cálculos
    double totalScore = 0;
    int validScores = 0;
    int thisMonthCount = 0;
    Map<String, int> byMonth = {};
    Map<String, int> bySpecies = {'birds': 0, 'pigs': 0};
    Map<String, List<double>> categoryScores = {};
    Map<String, List<double>> monthlyScores = {};
    List<RecentEvaluation> recent = [];

    // Inicializar últimos 6 meses
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final key = _months[month.month - 1];
      byMonth[key] = 0;
      monthlyScores[key] = [];
    }

    // Procesar cada evaluación
    for (var eval in evaluations) {
      try {
        final dateStr = eval['created_at'] as String? ?? eval['date'] as String?;
        final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
        final score = (eval['overall_score'] as num?)?.toDouble() ?? 
                      (eval['score'] as num?)?.toDouble() ?? 0;
        final species = eval['species_id'] as String? ?? 'birds';
        final farmName = eval['farm_name'] as String? ?? 'Sin nombre';

        // Contar por especie
        if (species.contains('bird') || species.contains('ave') || species.contains('pollo')) {
          bySpecies['birds'] = (bySpecies['birds'] ?? 0) + 1;
        } else {
          bySpecies['pigs'] = (bySpecies['pigs'] ?? 0) + 1;
        }

        // Score promedio
        if (score > 0) {
          totalScore += score;
          validScores++;
        }

        // Evaluaciones de este mes
        if (date != null && date.year == now.year && date.month == now.month) {
          thisMonthCount++;
        }

        // Por mes (últimos 6 meses)
        if (date != null && date.isAfter(sixMonthsAgo)) {
          final monthKey = _months[date.month - 1];
          byMonth[monthKey] = (byMonth[monthKey] ?? 0) + 1;
          monthlyScores[monthKey]?.add(score);
        }

        // Promedios por categoría
        final categoryDetails = eval['category_details'] as Map<String, dynamic>?;
        if (categoryDetails != null) {
          categoryDetails.forEach((catId, details) {
            if (details is Map) {
              final percentage = (details['percentage'] as num?)?.toDouble();
              if (percentage != null) {
                categoryScores[catId] ??= [];
                categoryScores[catId]!.add(percentage);
              }
            }
          });
        }

        // Evaluaciones recientes (últimas 5)
        if (recent.length < 5 && date != null) {
          recent.add(RecentEvaluation(
            id: eval['id']?.toString() ?? '',
            farmName: farmName,
            species: species,
            score: score,
            date: date,
          ));
        }
      } catch (e) {
        print('Error processing evaluation: $e');
      }
    }

    // Calcular promedios por categoría
    Map<String, double> categoryAverages = {};
    categoryScores.forEach((cat, scores) {
      if (scores.isNotEmpty) {
        categoryAverages[cat] = scores.reduce((a, b) => a + b) / scores.length;
      }
    });

    // Calcular tendencia mensual
    List<TrendPoint> trend = [];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = _months[month.month - 1];
      final scores = monthlyScores[monthKey] ?? [];
      final avgScore = scores.isNotEmpty 
          ? scores.reduce((a, b) => a + b) / scores.length 
          : 0.0;
      
      trend.add(TrendPoint(
        date: month,
        score: avgScore,
        monthLabel: monthKey,
      ));
    }

    // Ordenar recientes por fecha descendente
    recent.sort((a, b) => b.date.compareTo(a.date));

    return DashboardStats(
      averageScore: validScores > 0 ? totalScore / validScores : 0,
      totalEvaluations: evaluations.length,
      evaluationsThisMonth: thisMonthCount,
      pendingSync: 0,
      evaluationsByMonth: byMonth,
      evaluationsBySpecies: bySpecies,
      categoryAverages: categoryAverages,
      scoreTrend: trend,
      recentEvaluations: recent.take(5).toList(),
    );
  }

  /// Obtiene el nombre traducido de una categoría
  static String getCategoryName(String categoryId, String language) {
    final namesEs = {
      'resources': 'Recursos',
      'resource': 'Recursos',
      'animal': 'Animal',
      'management': 'Gestión',
      'health': 'Sanidad',
      'behavior': 'Comportamiento',
      'transport': 'Transporte',
    };
    
    final namesEn = {
      'resources': 'Resources',
      'resource': 'Resources',
      'animal': 'Animal',
      'management': 'Management',
      'health': 'Health',
      'behavior': 'Behavior',
      'transport': 'Transport',
    };

    final names = language == 'en' ? namesEn : namesEs;
    return names[categoryId] ?? categoryId;
  }
}
