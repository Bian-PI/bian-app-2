import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/dashboard_stats.dart';
import '../../core/models/user_model.dart';
import '../../core/services/dashboard_service.dart';
import '../../core/storage/secure_storage.dart';
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

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final _storage = SecureStorage();
  
  DashboardStats? _localStats;
  DashboardStats? _serverStats;
  bool _isLoadingLocal = true;
  bool _isLoadingServer = false;
  bool _isAdmin = false;
  User? _currentUser;
  
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _loadUserAndStats();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndStats() async {
    // Cargar usuario
    final user = await _storage.getUser();
    final isAdmin = user?.role?.toLowerCase() == 'admin';
    
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isAdmin = isAdmin;
        if (isAdmin) {
          _tabController = TabController(length: 2, vsync: this);
        }
      });
    }

    // Cargar stats locales (siempre)
    await _loadLocalStats();
    
    // Cargar stats del servidor solo si es admin
    if (isAdmin) {
      await _loadServerStats();
    }
  }

  Future<void> _loadLocalStats() async {
    setState(() => _isLoadingLocal = true);

    try {
      final stats = await DashboardService.getLocalStats();
      if (mounted) {
        setState(() {
          _localStats = stats;
          _isLoadingLocal = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocal = false);
      }
    }
  }

  Future<void> _loadServerStats() async {
    setState(() => _isLoadingServer = true);

    try {
      final stats = await DashboardService.getServerStats();
      if (mounted) {
        setState(() {
          _serverStats = stats;
          _isLoadingServer = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingServer = false);
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
            onPressed: () {
              _loadLocalStats();
              if (_isAdmin) _loadServerStats();
            },
            tooltip: 'Actualizar',
          ),
        ],
        bottom: _isAdmin && _tabController != null ? TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: const [
            Tab(
              icon: Icon(Icons.phone_android, size: 20),
              text: 'Mis Reportes',
            ),
            Tab(
              icon: Icon(Icons.cloud, size: 20),
              text: 'Servidor (Admin)',
            ),
          ],
        ) : null,
      ),
      body: _isAdmin && _tabController != null ? _buildAdminView(loc) : _buildUserView(loc),
    );
  }

  /// Vista para ADMIN con tabs (Local + Servidor)
  Widget _buildAdminView(AppLocalizations loc) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Tab 1: Reportes Locales
        _buildStatsView(
          stats: _localStats,
          isLoading: _isLoadingLocal,
          onRefresh: _loadLocalStats,
          emptyMessage: 'No hay reportes locales',
          emptyIcon: Icons.phone_android,
        ),
        // Tab 2: Reportes del Servidor
        _buildStatsView(
          stats: _serverStats,
          isLoading: _isLoadingServer,
          onRefresh: _loadServerStats,
          emptyMessage: 'No hay reportes en el servidor',
          emptyIcon: Icons.cloud_off,
          showConnectionWarning: true,
        ),
      ],
    );
  }

  /// Vista para USUARIO NORMAL (solo local)
  Widget _buildUserView(AppLocalizations loc) {
    return _buildStatsView(
      stats: _localStats,
      isLoading: _isLoadingLocal,
      onRefresh: _loadLocalStats,
      emptyMessage: 'No hay reportes locales',
      emptyIcon: Icons.assessment_outlined,
    );
  }

  Widget _buildStatsView({
    required DashboardStats? stats,
    required bool isLoading,
    required Future<void> Function() onRefresh,
    required String emptyMessage,
    required IconData emptyIcon,
    bool showConnectionWarning = false,
  }) {
    if (isLoading) {
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

    final data = stats ?? DashboardStats.empty();
    final hasData = data.totalEvaluations > 0;

    if (!hasData) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Realiza evaluaciones para ver estadísticas',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BianTheme.primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: BianTheme.primaryRed,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Advertencia de conexión para servidor
            if (showConnectionWarning)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Datos del servidor - requiere conexión a internet',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ),
              ),

            // Fila 1: Score promedio + Stats
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCard(
                    title: 'Score Promedio',
                    child: Center(
                      child: ScoreGauge(
                        score: data.averageScore,
                        size: 130,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _buildStatCard(
                        icon: Icons.assessment,
                        value: data.totalEvaluations.toString(),
                        label: 'Total',
                        color: BianTheme.primaryRed,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        icon: Icons.calendar_month,
                        value: data.evaluationsThisMonth.toString(),
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
                data: data.evaluationsByMonth,
                height: 180,
              ),
            ),
            const SizedBox(height: 16),

            // Tendencia de Bienestar
            _buildCard(
              title: 'Tendencia de Bienestar',
              subtitle: 'Evolución del score promedio',
              child: TrendLineChart(
                data: data.scoreTrend,
                height: 180,
              ),
            ),
            const SizedBox(height: 16),

            // Fila 3: Distribución por especie + Categorías
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildCard(
                    title: 'Por Especie',
                    child: SpeciesPieChart(
                      data: data.evaluationsBySpecies,
                      size: 110,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildCard(
                    title: 'Categorías',
                    subtitle: 'Promedio por área',
                    child: data.categoryAverages.isNotEmpty
                        ? CategoryComparisonChart(
                            data: data.categoryAverages,
                            height: 150,
                          )
                        : SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bar_chart, size: 40, color: Colors.grey.shade300),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sin datos',
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                  ),
                                ],
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
              child: data.recentEvaluations.isEmpty
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
                      children: data.recentEvaluations.map((eval) {
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(14),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
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
          Text(speciesIcon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eval.farmName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(eval.date),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${eval.score.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
