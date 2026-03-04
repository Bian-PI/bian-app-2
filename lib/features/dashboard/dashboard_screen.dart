import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/dashboard_stats.dart';
import '../../core/services/dashboard_service.dart';
import '../../core/theme/bian_theme.dart';
import 'widgets/score_gauge.dart';
import 'widgets/monthly_bar_chart.dart';
import 'widgets/trend_line_chart.dart';
import 'widgets/species_pie_chart.dart';
import 'widgets/category_comparison_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stats = await DashboardService.getStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          loc.translate('dashboard') != 'dashboard' 
              ? loc.translate('dashboard') 
              : 'Dashboard',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: BianTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _buildBody(loc),
    );
  }

  Widget _buildBody(AppLocalizations loc) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: BianTheme.primaryRed),
            SizedBox(height: 16),
            Text('Cargando estadísticas...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Error al cargar datos',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadStats,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BianTheme.primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final stats = _stats ?? DashboardStats.empty();

    return RefreshIndicator(
      onRefresh: _loadStats,
      color: BianTheme.primaryRed,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: Score promedio + Evaluaciones del mes
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score Gauge
                Expanded(
                  child: _buildCard(
                    title: 'Score Promedio',
                    child: Center(
                      child: ScoreGauge(
                        score: stats.averageScore,
                        size: 140,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Stats rápidas
                Expanded(
                  child: Column(
                    children: [
                      _buildStatCard(
                        icon: Icons.assessment,
                        value: stats.totalEvaluations.toString(),
                        label: 'Total Evaluaciones',
                        color: BianTheme.primaryRed,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        icon: Icons.calendar_month,
                        value: stats.evaluationsThisMonth.toString(),
                        label: 'Este Mes',
                        color: const Color(0xFF2196F3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Evaluaciones por Mes
            _buildCard(
              title: 'Evaluaciones por Mes',
              subtitle: 'Últimos 6 meses',
              child: MonthlyBarChart(
                data: stats.evaluationsByMonth,
                height: 180,
              ),
            ),
            const SizedBox(height: 16),

            // Tendencia de Bienestar
            _buildCard(
              title: 'Tendencia de Bienestar',
              subtitle: 'Evolución del score promedio',
              child: TrendLineChart(
                data: stats.scoreTrend,
                height: 180,
              ),
            ),
            const SizedBox(height: 16),

            // Fila 3: Distribución por especie + Categorías
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Distribución por Especie
                Expanded(
                  flex: 1,
                  child: _buildCard(
                    title: 'Por Especie',
                    child: SpeciesPieChart(
                      data: stats.evaluationsBySpecies,
                      size: 120,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Comparativa Categorías
                Expanded(
                  flex: 1,
                  child: _buildCard(
                    title: 'Categorías',
                    subtitle: 'Promedio por área',
                    child: stats.categoryAverages.isNotEmpty
                        ? CategoryComparisonChart(
                            data: stats.categoryAverages,
                            height: 160,
                          )
                        : SizedBox(
                            height: 160,
                            child: Center(
                              child: Text(
                                'Sin datos',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Evaluaciones Recientes
            _buildCard(
              title: 'Evaluaciones Recientes',
              child: stats.recentEvaluations.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.history, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text(
                              'Sin evaluaciones recientes',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: stats.recentEvaluations.map((eval) {
                        return _buildRecentEvaluationItem(eval);
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEvaluationItem(RecentEvaluation eval) {
    final isGood = eval.score >= 75;
    final color = eval.score >= 90 ? const Color(0xFF1B5E20)
        : eval.score >= 75 ? const Color(0xFF4CAF50)
        : eval.score >= 50 ? const Color(0xFFFFB300)
        : const Color(0xFFE53935);

    final speciesIcon = eval.species.contains('bird') || eval.species.contains('ave')
        ? '🐔'
        : '🐷';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(speciesIcon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eval.farmName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(eval.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${eval.score.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}
