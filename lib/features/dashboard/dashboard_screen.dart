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

class _DashboardScreenState extends State<DashboardScreen> {
  final _storage = SecureStorage();
  
  DashboardStats? _localStats;
  DashboardStats? _serverStats;
  bool _isLoadingLocal = true;
  bool _isLoadingServer = false;
  bool _isAdmin = false;
  User? _currentUser;
  
  // 0 = Local, 1 = Server
  int _selectedSection = 0;

  @override
  void initState() {
    super.initState();
    _loadUserAndStats();
  }

  Future<void> _loadUserAndStats() async {
    final user = await _storage.getUser();
    final isAdmin = user?.role?.toLowerCase() == 'admin';
    
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isAdmin = isAdmin;
      });
    }

    await _loadLocalStats();
    
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App Bar con gradiente
          SliverAppBar(
            expandedHeight: _isAdmin ? 180 : 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: BianTheme.primaryRed,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () {
                  _loadLocalStats();
                  if (_isAdmin) _loadServerStats();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      BianTheme.primaryRed,
                      BianTheme.primaryRed.withRed(180),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Panel de Control',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isAdmin 
                              ? 'Administrador • Acceso completo'
                              : 'Mis estadísticas de evaluación',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                        ),
                        if (_isAdmin) ...[
                          const SizedBox(height: 16),
                          _buildSectionSelector(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Contenido
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  /// Selector de sección para Admin (Local / Servidor)
  Widget _buildSectionSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSectionTab(
              index: 0,
              icon: Icons.smartphone_rounded,
              label: 'Mis Reportes',
              isSelected: _selectedSection == 0,
            ),
          ),
          Expanded(
            child: _buildSectionTab(
              index: 1,
              icon: Icons.cloud_rounded,
              label: 'Servidor',
              isSelected: _selectedSection == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTab({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSection = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? BianTheme.primaryRed : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? BianTheme.primaryRed : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final isServerSection = _isAdmin && _selectedSection == 1;
    final stats = isServerSection ? _serverStats : _localStats;
    final isLoading = isServerSection ? _isLoadingServer : _isLoadingLocal;
    
    if (isLoading) {
      return _buildLoadingState();
    }

    final data = stats ?? DashboardStats.empty();
    final hasData = data.totalEvaluations > 0;

    if (!hasData) {
      return _buildEmptyState(isServerSection);
    }

    return _buildStatsContent(data, isServerSection);
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: BianTheme.primaryRed,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando estadísticas...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isServerSection) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              isServerSection ? Icons.cloud_off_rounded : Icons.analytics_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            isServerSection 
                ? 'Sin datos en el servidor'
                : 'Sin reportes locales',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isServerSection
                ? 'Los reportes sincronizados aparecerán aquí'
                : 'Realiza evaluaciones para ver tus estadísticas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              if (isServerSection) {
                _loadServerStats();
              } else {
                _loadLocalStats();
              }
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Actualizar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: BianTheme.primaryRed,
              side: const BorderSide(color: BianTheme.primaryRed, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(DashboardStats data, bool isServerSection) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner para servidor
          if (isServerSection)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667eea).withOpacity(0.1),
                    const Color(0xFF764ba2).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF667eea).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Color(0xFF667eea),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vista de Administrador',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667eea),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Mostrando todos los reportes del sistema',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Score y Stats principales
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  child: Column(
                    children: [
                      Text(
                        'Score Promedio',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ScoreGauge(
                        score: data.averageScore,
                        size: 120,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildStatCard(
                      icon: Icons.assignment_rounded,
                      value: data.totalEvaluations.toString(),
                      label: 'Total',
                      gradient: [const Color(0xFFE53935), const Color(0xFFFF7043)],
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      icon: Icons.today_rounded,
                      value: data.evaluationsThisMonth.toString(),
                      label: 'Este Mes',
                      gradient: [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sección título
          _buildSectionTitle('Actividad', Icons.show_chart_rounded),
          const SizedBox(height: 12),

          // Evaluaciones por Mes
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 20, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Evaluaciones por Mes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Últimos 6 meses',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 16),
                MonthlyBarChart(data: data.evaluationsByMonth, height: 180),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tendencia
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up_rounded, size: 20, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Tendencia de Bienestar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Evolución del score promedio',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 16),
                TrendLineChart(data: data.scoreTrend, height: 180),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sección título
          _buildSectionTitle('Distribución', Icons.pie_chart_rounded),
          const SizedBox(height: 12),

          // Por Especie y Categorías
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Por Especie',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SpeciesPieChart(
                        data: data.evaluationsBySpecies,
                        size: 100,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categorías',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      data.categoryAverages.isNotEmpty
                          ? CategoryComparisonChart(
                              data: data.categoryAverages,
                              height: 140,
                            )
                          : _buildNoDataSmall(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Evaluaciones Recientes
          _buildSectionTitle('Recientes', Icons.history_rounded),
          const SizedBox(height: 12),
          
          _buildCard(
            child: data.recentEvaluations.isEmpty
                ? _buildNoDataSmall()
                : Column(
                    children: data.recentEvaluations.map((eval) {
                      return _buildRecentItem(eval);
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: BianTheme.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: BianTheme.primaryRed),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataSmall() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 32, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              'Sin datos',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItem(RecentEvaluation eval) {
    final color = eval.score >= 90
        ? const Color(0xFF1B5E20)
        : eval.score >= 75
            ? const Color(0xFF4CAF50)
            : eval.score >= 50
                ? const Color(0xFFFF9800)
                : const Color(0xFFE53935);

    final speciesIcon = eval.species.contains('bird') || eval.species.contains('ave')
        ? '🐔'
        : '🐷';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(speciesIcon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${eval.score.toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
