/// Modelo para estadísticas del dashboard
class DashboardStats {
  final double averageScore;
  final int totalEvaluations;
  final int evaluationsThisMonth;
  final int pendingSync;
  
  final Map<String, int> evaluationsByMonth;
  final Map<String, int> evaluationsBySpecies;
  final Map<String, double> categoryAverages;
  final List<TrendPoint> scoreTrend;
  final List<RecentEvaluation> recentEvaluations;

  DashboardStats({
    required this.averageScore,
    required this.totalEvaluations,
    required this.evaluationsThisMonth,
    required this.pendingSync,
    required this.evaluationsByMonth,
    required this.evaluationsBySpecies,
    required this.categoryAverages,
    required this.scoreTrend,
    required this.recentEvaluations,
  });

  factory DashboardStats.empty() {
    return DashboardStats(
      averageScore: 0,
      totalEvaluations: 0,
      evaluationsThisMonth: 0,
      pendingSync: 0,
      evaluationsByMonth: {},
      evaluationsBySpecies: {'birds': 0, 'pigs': 0},
      categoryAverages: {},
      scoreTrend: [],
      recentEvaluations: [],
    );
  }

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0,
      totalEvaluations: json['total_evaluations'] as int? ?? 0,
      evaluationsThisMonth: json['evaluations_this_month'] as int? ?? 0,
      pendingSync: json['pending_sync'] as int? ?? 0,
      evaluationsByMonth: Map<String, int>.from(json['evaluations_by_month'] ?? {}),
      evaluationsBySpecies: Map<String, int>.from(json['evaluations_by_species'] ?? {'birds': 0, 'pigs': 0}),
      categoryAverages: Map<String, double>.from(
        (json['category_averages'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toDouble())) ?? {}
      ),
      scoreTrend: (json['score_trend'] as List?)
          ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      recentEvaluations: (json['recent_evaluations'] as List?)
          ?.map((e) => RecentEvaluation.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class TrendPoint {
  final DateTime date;
  final double score;
  final String monthLabel;

  TrendPoint({
    required this.date,
    required this.score,
    required this.monthLabel,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      date: DateTime.parse(json['date'] as String),
      score: (json['score'] as num).toDouble(),
      monthLabel: json['month_label'] as String? ?? '',
    );
  }
}

class RecentEvaluation {
  final String id;
  final String farmName;
  final String species;
  final double score;
  final DateTime date;

  RecentEvaluation({
    required this.id,
    required this.farmName,
    required this.species,
    required this.score,
    required this.date,
  });

  factory RecentEvaluation.fromJson(Map<String, dynamic> json) {
    return RecentEvaluation(
      id: json['id'] as String? ?? '',
      farmName: json['farm_name'] as String? ?? '',
      species: json['species'] as String? ?? 'birds',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
