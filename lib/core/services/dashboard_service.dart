import '../models/dashboard_stats.dart';
import '../models/evaluation_model.dart';
import '../api/api_service.dart';
import '../storage/secure_storage.dart';
import '../storage/reports_storage.dart';
import '../storage/local_reports_storage.dart';

class DashboardService {
  static final _storage = SecureStorage();
  static final _apiService = ApiService();
  static final _months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

  /// Obtiene estadísticas de reportes LOCALES (funciona offline)
  static Future<DashboardStats> getLocalStats() async {
    try {
      // Obtener reportes completados localmente
      final localReports = await ReportsStorage.getAllReports();
      
      // Obtener reportes pendientes de sincronización
      final pendingReports = await LocalReportsStorage.getAllReports();
      
      // Convertir evaluaciones a mapas para procesar
      final List<Map<String, dynamic>> allReports = [];
      
      for (var eval in localReports) {
        allReports.add(_evaluationToMap(eval));
      }
      
      for (var report in pendingReports) {
        allReports.add(report);
      }
      
      if (allReports.isEmpty) {
        return DashboardStats.empty();
      }

      return _calculateStats(allReports);
    } catch (e) {
      print('Error getting local dashboard stats: $e');
      return DashboardStats.empty();
    }
  }

  /// Obtiene estadísticas del SERVIDOR (requiere conexión) - Solo para Admin
  static Future<DashboardStats> getServerStats() async {
    try {
      final user = await _storage.getUser();
      if (user == null) return DashboardStats.empty();

      // Verificar si es admin
      final isAdmin = user.role?.toLowerCase() == 'admin';
      
      Map<String, dynamic> result;
      
      if (isAdmin) {
        // Admin ve todos los reportes
        result = await _apiService.getAllEvaluationsAdmin(limit: 500, offset: 0);
      } else {
        // Usuario normal ve solo sus reportes
        result = await _apiService.getUserEvaluations(limit: 100, offset: 0);
      }
      
      if (result['success'] != true) {
        print('Error getting evaluations from server: ${result['message']}');
        return DashboardStats.empty();
      }
      
      final evaluations = (result['evaluations'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      
      if (evaluations.isEmpty) {
        return DashboardStats.empty();
      }

      return _calculateStats(evaluations);
    } catch (e) {
      print('Error getting server dashboard stats: $e');
      return DashboardStats.empty();
    }
  }

  /// Convierte Evaluation a Map para procesamiento uniforme
  static Map<String, dynamic> _evaluationToMap(Evaluation eval) {
    return {
      'id': eval.id,
      'farm_name': eval.farmName,
      'species_id': eval.speciesId,
      'overall_score': eval.overallScore,
      'created_at': eval.evaluationDate.toIso8601String(),
      'date': eval.evaluationDate.toIso8601String(),
      'category_details': eval.results?['category_details'],
    };
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
        final dateStr = eval['created_at'] as String? ?? eval['date'] as String? ?? eval['evaluation_date'] as String?;
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
          if (byMonth.containsKey(monthKey)) {
            byMonth[monthKey] = (byMonth[monthKey] ?? 0) + 1;
            monthlyScores[monthKey]?.add(score);
          }
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
