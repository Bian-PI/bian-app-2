import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/models/species_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/api/api_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../evaluation/results_screen.dart';
import 'package:intl/intl.dart';

/// Pantalla de administrador mejorada con búsqueda y filtros
class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final _apiService = ApiService();
  final _searchController = TextEditingController();

  List<Evaluation> _allReports = [];
  List<Evaluation> _filteredReports = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedSpeciesFilter = 'all'; // 'all', 'birds', 'pigs'
  double _minScoreFilter = 0;
  Map<String, int> _userReportCount = {};

  @override
  void initState() {
    super.initState();
    _loadAllReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllReports() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('📥 [ADMIN] Cargando todos los reportes...');

      final result = await _apiService.getAllEvaluationsAdmin(
        limit: 500, // Cargar todos de una vez
        offset: 0,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final List<dynamic> evaluationsData = result['evaluations'] ?? [];
        final List<Evaluation> newReports = evaluationsData
            .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
            .toList();

        // Calcular estadísticas de usuarios
        _userReportCount = {};
        for (var report in newReports) {
          final userId = report.user?.id?.toString() ?? report.evaluatorDocument ?? 'unknown';
          _userReportCount[userId] = (_userReportCount[userId] ?? 0) + 1;
        }

        setState(() {
          _allReports = newReports;
          _filteredReports = newReports;
          _isLoading = false;
        });

        print('✅ [ADMIN] ${_allReports.length} reportes cargados');
      } else {
        setState(() {
          _isLoading = false;
          _allReports = [];
          _filteredReports = [];
        });

        if (mounted) {
          CustomSnackbar.showError(
            context,
            'Error: ${result['message'] ?? 'No se pudieron cargar reportes'}',
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _allReports = [];
        _filteredReports = [];
      });

      print('❌ Error cargando reportes (admin): $e');
      CustomSnackbar.showError(
        context,
        'Error de conexión: $e',
      );
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredReports = _allReports.where((report) {
        // Filtro de búsqueda (documento, granja, ubicación, evaluador)
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final matchesFarm = report.farmName.toLowerCase().contains(query);
          final matchesLocation = report.farmLocation.toLowerCase().contains(query);
          final matchesEvaluator = report.evaluatorName.toLowerCase().contains(query);
          final matchesDocument = report.evaluatorDocument.toLowerCase().contains(query);

          if (!matchesFarm && !matchesLocation && !matchesEvaluator && !matchesDocument) {
            return false;
          }
        }

        // Filtro de especie
        if (_selectedSpeciesFilter != 'all' && report.speciesId != _selectedSpeciesFilter) {
          return false;
        }

        // Filtro de score mínimo
        if ((report.overallScore ?? 0) < _minScoreFilter) {
          return false;
        }

        return true;
      }).toList();

      // Ordenar por fecha (más recientes primero)
      _filteredReports.sort((a, b) {
        return b.evaluationDate.compareTo(a.evaluationDate);
      });
    });
  }

  Future<void> _refreshReports() async {
    await _loadAllReports();
    _applyFilters();
  }

  void _viewReport(Evaluation evaluation) async {
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final result = await _apiService.getEvaluationById(evaluation.id);

      if (mounted) Navigator.pop(context);

      if (result['success'] == true) {
        final fullEvaluation = Evaluation.fromJson(result['evaluation']);
        final species = fullEvaluation.speciesId == 'birds' ? Species.birds() : Species.pigs();

        Map<String, dynamic> results;

        if (fullEvaluation.overallScore != null && fullEvaluation.overallScore! > 0) {
          Map<String, double> categoryScores;
          if (fullEvaluation.categoryScores != null && fullEvaluation.categoryScores!.isNotEmpty) {
            categoryScores = fullEvaluation.categoryScores!;
          } else {
            categoryScores = {
              'feeding': fullEvaluation.overallScore!,
              'health': fullEvaluation.overallScore!,
              'behavior': fullEvaluation.overallScore!,
              'infrastructure': fullEvaluation.overallScore!,
              'management': fullEvaluation.overallScore!,
            };
          }

          results = {
            'overallScore': fullEvaluation.overallScore,
            'categoryScores': categoryScores,
          };
        } else {
          results = _recalculateResults(fullEvaluation, species);
        }

        final structuredJson = await fullEvaluation.generateStructuredJSON(
          species,
          results,
          [], // Recommendations vacío
        );

        print('✅ [ADMIN] Datos preparados para mostrar:');
        print('  - overallScore: ${results['overallScore']}');
        print('  - categoryScores: ${results['categoryScores']}');

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultsScreen(
                evaluation: fullEvaluation,
                species: species,
                results: results,
                structuredJson: structuredJson,
                isLocal: false, // Reportes del servidor, no mostrar sync
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(context, loc.translate('error_loading_report'));
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        CustomSnackbar.showError(context, 'Error: ${e.toString()}');
      }
      print('❌ Error al cargar evaluación: $e');
    }
  }

  Map<String, dynamic> _recalculateResults(Evaluation evaluation, Species species) {
    int totalQuestions = 0;
    int positiveResponses = 0;
    final categoryScores = <String, double>{};

    for (var category in species.categories) {
      int categoryTotal = 0;
      int categoryPositive = 0;

      for (var field in category.fields) {
        if (field.type.toString().contains('yesNo')) {
          final key = '${category.id}_${field.id}';
          final value = evaluation.responses[key];

          if (value != null) {
            categoryTotal++;
            totalQuestions++;

            if (value == true || value == 'true') {
              categoryPositive++;
              positiveResponses++;
            }
          }
        }
      }

      if (categoryTotal > 0) {
        categoryScores[category.id] = (categoryPositive / categoryTotal) * 100;
      } else {
        categoryScores[category.id] = 0.0;
      }
    }

    final overallScore = totalQuestions > 0 ? (positiveResponses / totalQuestions) * 100 : 0.0;

    return {
      'overallScore': overallScore,
      'categoryScores': categoryScores,
    };
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.white),
            const SizedBox(width: 8),
            Text(loc.translate('admin_all_reports')),
          ],
        ),
        backgroundColor: BianTheme.primaryRed,
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          _buildSearchAndFilters(loc),

          // Estadísticas
          _buildStatistics(loc),

          // Lista de reportes
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredReports.isEmpty
                    ? _buildEmptyState(loc)
                    : RefreshIndicator(
                        onRefresh: _refreshReports,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredReports.length,
                          itemBuilder: (context, index) {
                            return _buildReportCard(_filteredReports[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: loc.translate('search_placeholder'),
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(Icons.search, color: BianTheme.primaryRed),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        _applyFilters();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: BianTheme.mediumGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: BianTheme.primaryRed, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _applyFilters();
            },
          ),

          const SizedBox(height: 12),

          // Filtros en fila
          Row(
            children: [
              // Filtro de especie
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSpeciesFilter,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'all', child: Text(loc.translate('filter_all_species'), style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 'birds', child: Text(loc.translate('filter_birds'), style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 'pigs', child: Text(loc.translate('filter_pigs'), style: TextStyle(fontSize: 14))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSpeciesFilter = value!;
                    });
                    _applyFilters();
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Filtro de score mínimo
              Expanded(
                child: DropdownButtonFormField<double>(
                  value: _minScoreFilter,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 0.0, child: Text(loc.translate('filter_score_all'), style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 50.0, child: Text(loc.translate('filter_score_50'), style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 70.0, child: Text(loc.translate('filter_score_70'), style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 85.0, child: Text(loc.translate('filter_score_85'), style: TextStyle(fontSize: 14))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _minScoreFilter = value!;
                    });
                    _applyFilters();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(AppLocalizations loc) {
    final uniqueUsers = _userReportCount.keys.length;
    final totalReports = _filteredReports.length;
    final avgScore = _filteredReports.isEmpty
        ? 0.0
        : _filteredReports.map((r) => r.overallScore ?? 0.0).reduce((a, b) => a + b) / totalReports;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurple[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.assessment,
            label: loc.translate('stats_reports'),
            value: '$totalReports',
          ),
          _buildStatItem(
            icon: Icons.people,
            label: loc.translate('stats_users'),
            value: '$uniqueUsers',
          ),
          _buildStatItem(
            icon: Icons.trending_up,
            label: loc.translate('stats_average'),
            value: '${avgScore.toStringAsFixed(0)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(Evaluation report) {
    final loc = AppLocalizations.of(context);
    final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
    final speciesColor = Color(int.parse(species.gradientColors[0]));
    final score = report.overallScore ?? 0.0;
    final scoreColor = score >= 85
        ? BianTheme.successGreen
        : score >= 70
            ? BianTheme.warningYellow
            : BianTheme.errorRed;

    final dateStr = DateFormat('dd MMM yyyy', 'es').format(report.evaluationDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () => _viewReport(report),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icono de especie
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: speciesColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      species.iconPath,
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(speciesColor, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.farmName.isEmpty ? loc.translate('no_name') : report.farmName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.farmLocation.isEmpty ? loc.translate('no_location') : report.farmLocation,
                          style: TextStyle(
                            fontSize: 13,
                            color: BianTheme.mediumGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Score
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scoreColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${score.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Info adicional - SIN contador de reportes
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: BianTheme.mediumGray),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.evaluatorName.isEmpty ? loc.translate('no_evaluator') : report.evaluatorName,
                      style: TextStyle(fontSize: 12, color: BianTheme.mediumGray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.calendar_today, size: 14, color: BianTheme.mediumGray),
                  const SizedBox(width: 4),
                  Text(
                    dateStr,
                    style: TextStyle(fontSize: 12, color: BianTheme.mediumGray),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: BianTheme.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            loc.translate('no_reports_found'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BianTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('adjust_search_filters'),
            style: TextStyle(
              fontSize: 14,
              color: BianTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}
