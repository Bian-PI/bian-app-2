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

/// Pantalla de administrador para ver TODOS los reportes del sistema
class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final _apiService = ApiService();

  List<Evaluation> _allReports = [];
  int _reportTotal = 0;
  bool _hasMoreReports = false;
  int _reportOffset = 0;
  final int _reportLimit = 20;
  bool _isLoading = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadAllReports();
  }

  Future<void> _loadAllReports() async {
    if (_isLoading || _isLoadingMore) return;

    setState(() {
      if (_reportOffset == 0) {
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
    });

    try {
      final result = await _apiService.getAllEvaluationsAdmin(
        limit: _reportLimit,
        offset: _reportOffset,
      );

      if (result['success'] == true) {
        final List<dynamic> evaluationsData = result['evaluations'];
        final List<Evaluation> newReports = evaluationsData
            .map((json) => Evaluation.fromJson(json as Map<String, dynamic>))
            .toList();

        final int total = result['total'];
        final bool hasMore = result['hasMore'];

        setState(() {
          if (_reportOffset == 0) {
            _allReports = newReports;
          } else {
            _allReports.addAll(newReports);
          }
          _reportTotal = total;
          _hasMoreReports = hasMore;
          _reportOffset = _allReports.length;
          _isLoading = false;
          _isLoadingMore = false;
        });

        print('✅ [ADMIN] Reportes cargados: ${_allReports.length} / $total');
      } else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });

        if (mounted) {
          CustomSnackbar.showError(
            context,
            'Error al cargar reportes',
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      print('❌ Error cargando reportes (admin): $e');
    }
  }

  Future<void> _refreshReports() async {
    setState(() {
      _reportOffset = 0;
      _allReports.clear();
    });
    await _loadAllReports();
  }

  /// Obtiene los detalles completos del servidor y muestra el reporte en ResultsScreen
  void _viewReport(Evaluation evaluation) async {
    final loc = AppLocalizations.of(context);

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Obtener detalles completos del servidor
      final result = await _apiService.getEvaluationById(evaluation.id);

      if (mounted) Navigator.pop(context); // Cerrar loading

      if (result['success'] == true) {
        // Reconstruir el evaluation desde los datos completos del servidor
        final fullEvaluation = Evaluation.fromJson(result['evaluation']);
        final species = fullEvaluation.speciesId == 'birds' ? Species.birds() : Species.pigs();
        final results = _recalculateResults(fullEvaluation, species);
        final translatedRecommendations = _translateRecommendations(
          results['recommendations'],
          fullEvaluation.language,
        );

        final structuredJson = await fullEvaluation.generateStructuredJSON(
          species,
          results,
          translatedRecommendations,
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultsScreen(
                evaluation: fullEvaluation,
                species: species,
                results: results,
                structuredJson: structuredJson,
              ),
            ),
          );
        }
      } else {
        // Error al obtener detalles
        if (mounted) {
          CustomSnackbar.showError(
            context,
            loc.translate('error_loading_evaluation'),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar loading si está abierto
        CustomSnackbar.showError(
          context,
          'Error: ${e.toString()}',
        );
      }
      print('❌ Error al cargar evaluación: $e');
    }
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
            Text('Todos los Reportes (Admin)'),
          ],
        ),
        backgroundColor: BianTheme.primaryRed,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshReports,
              child: _allReports.isEmpty
                  ? _buildEmptyState(loc)
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Estadísticas
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: BianTheme.primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: BianTheme.primaryRed.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                icon: Icons.assessment,
                                label: 'Total Reportes',
                                value: '$_reportTotal',
                              ),
                              _buildStatItem(
                                icon: Icons.people,
                                label: 'Usuarios únicos',
                                value: '${_getUniqueUsersCount()}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Lista de reportes
                        ..._allReports.map((report) => _buildReportCard(report)),

                        // Botón para cargar más
                        if (_hasMoreReports)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: _isLoadingMore
                                ? const Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: _loadAllReports,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: BianTheme.infoBlue,
                                      minimumSize: const Size(double.infinity, 48),
                                    ),
                                    child: Text(loc.translate('load_more')),
                                  ),
                          ),
                      ],
                    ),
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
        Icon(icon, color: BianTheme.primaryRed, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: BianTheme.primaryRed,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: BianTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  int _getUniqueUsersCount() {
    // Contar usuarios únicos basados en documento de identidad
    final uniqueDocuments = _allReports
        .map((r) => r.evaluatorDocument)
        .where((doc) => doc.isNotEmpty)
        .toSet();
    return uniqueDocuments.length;
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: BianTheme.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay reportes en el sistema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: BianTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Evaluation evaluation) {
    final score = evaluation.overallScore ?? 0.0;

    Color scoreColor;
    if (score >= 90) {
      scoreColor = BianTheme.successGreen;
    } else if (score >= 75) {
      scoreColor = const Color(0xFF4CAF50);
    } else if (score >= 60) {
      scoreColor = BianTheme.warningYellow;
    } else {
      scoreColor = BianTheme.errorRed;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewReport(evaluation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${score.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    evaluation.speciesId == 'birds'
                        ? 'assets/icons/ave.svg'
                        : 'assets/icons/cerdo.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      BianTheme.primaryRed,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                evaluation.farmName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                evaluation.farmLocation,
                style: TextStyle(
                  fontSize: 13,
                  color: BianTheme.mediumGray,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 14,
                    color: BianTheme.mediumGray,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      evaluation.evaluatorName ?? 'Usuario',
                      style: TextStyle(
                        fontSize: 12,
                        color: BianTheme.mediumGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: BianTheme.mediumGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: BianTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _recalculateResults(Evaluation evaluation, Species species) {
    int totalQuestions = 0;
    int positiveResponses = 0;
    final categoryScores = <String, double>{};

    for (var category in species.categories) {
      int categoryTotal = 0;
      int categoryPositive = 0;

      for (var field in category.fields) {
        if (field.type == FieldType.yesNo) {
          final key = '${category.id}_${field.id}';
          final value = evaluation.responses[key];

          if (value != null) {
            categoryTotal++;
            totalQuestions++;

            bool isPositive = false;
            if (field.id.contains('access') ||
                field.id.contains('quality') ||
                field.id.contains('sufficient') ||
                field.id.contains('health') ||
                field.id.contains('vaccination') ||
                field.id.contains('natural_behavior') ||
                field.id.contains('movement') ||
                field.id.contains('ventilation') ||
                field.id.contains('training') ||
                field.id.contains('records') ||
                field.id.contains('biosecurity') ||
                field.id.contains('handling') ||
                field.id.contains('lighting') ||
                field.id.contains('enrichment') ||
                field.id.contains('resting_area') ||
                field.id.contains('castration')) {
              isPositive = value == true;
            } else {
              isPositive = value == false;
            }

            if (isPositive) {
              categoryPositive++;
              positiveResponses++;
            }
          }
        }
      }

      if (categoryTotal > 0) {
        categoryScores[category.id] = (categoryPositive / categoryTotal) * 100;
      }
    }

    final overallScore = totalQuestions > 0 ? (positiveResponses / totalQuestions) * 100 : 0;

    String complianceLevel;
    if (overallScore >= 90) {
      complianceLevel = 'excellent';
    } else if (overallScore >= 75) {
      complianceLevel = 'good';
    } else if (overallScore >= 60) {
      complianceLevel = 'acceptable';
    } else if (overallScore >= 40) {
      complianceLevel = 'needs_improvement';
    } else {
      complianceLevel = 'critical';
    }

    final recommendationKeys = <String>[];
    if (overallScore < 60) recommendationKeys.add('immediate_attention_required');
    if (categoryScores['feeding'] != null && categoryScores['feeding']! < 70) {
      recommendationKeys.add('improve_feeding_practices');
    }
    if (categoryScores['health'] != null && categoryScores['health']! < 70) {
      recommendationKeys.add('strengthen_health_program');
    }
    if (categoryScores['infrastructure'] != null && categoryScores['infrastructure']! < 70) {
      recommendationKeys.add('improve_infrastructure');
    }
    if (categoryScores['management'] != null && categoryScores['management']! < 70) {
      recommendationKeys.add('train_staff_welfare');
    }
    if (recommendationKeys.isEmpty) recommendationKeys.add('maintain_current_practices');

    return {
      'overall_score': overallScore,
      'compliance_level': complianceLevel,
      'category_scores': categoryScores,
      'recommendations': recommendationKeys,
      'critical_points': [],
      'strong_points': [],
    };
  }

  List<String> _translateRecommendations(List recommendationKeys, String language) {
    final translations = <String, String>{
      'immediate_attention_required': language == 'es'
          ? 'Se requiere atención inmediata para mejorar las condiciones de bienestar animal'
          : 'Immediate attention required to improve animal welfare conditions',
      'improve_feeding_practices': language == 'es'
          ? 'Mejorar las prácticas de alimentación y asegurar acceso constante a agua y alimento de calidad'
          : 'Improve feeding practices and ensure constant access to quality water and food',
      'strengthen_health_program': language == 'es'
          ? 'Fortalecer el programa de salud animal, incluyendo vacunación y control de enfermedades'
          : 'Strengthen animal health program, including vaccination and disease control',
      'improve_infrastructure': language == 'es'
          ? 'Mejorar las instalaciones para proporcionar espacios adecuados, ventilación y condiciones ambientales óptimas'
          : 'Improve facilities to provide adequate space, ventilation and optimal environmental conditions',
      'train_staff_welfare': language == 'es'
          ? 'Capacitar al personal en bienestar animal y mantener registros actualizados'
          : 'Train staff in animal welfare and maintain updated records',
      'maintain_current_practices': language == 'es'
          ? 'Mantener las buenas prácticas actuales y continuar monitoreando el bienestar animal'
          : 'Maintain current good practices and continue monitoring animal welfare',
    };

    final translatedRecommendations = <String>[];
    for (var key in recommendationKeys) {
      if (translations.containsKey(key)) {
        translatedRecommendations.add(translations[key]!);
      }
    }

    return translatedRecommendations;
  }
}
