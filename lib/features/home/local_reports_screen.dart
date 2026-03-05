import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/models/species_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/api/api_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../evaluation/results_screen.dart';

class LocalReportsScreen extends StatefulWidget {
  const LocalReportsScreen({super.key});

  @override
  State<LocalReportsScreen> createState() => _LocalReportsScreenState();
}

class _LocalReportsScreenState extends State<LocalReportsScreen> {
  final _apiService = ApiService();
  List<Evaluation> _localReports = [];
  List<String> _pendingSyncIds = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _syncingReportId; // ID del reporte que se está sincronizando

  @override
  void initState() {
    super.initState();
    _loadLocalReports();
  }

  Future<void> _loadLocalReports() async {
    setState(() => _isLoading = true);

    // SOLO cargar reportes pendientes de sincronización (no sincronizados)
    final reports = await LocalReportsStorage.getPendingSyncReports();
    final pendingIds = await LocalReportsStorage.getPendingSyncIds();

    setState(() {
      _localReports = reports;
      _pendingSyncIds = pendingIds;
      _isLoading = false;
    });
  }

  Future<void> _syncReport(Evaluation report) async {
    AppLocalizations.of(context);

    setState(() => _syncingReportId = report.id);

    try {
      print('📤 Sincronizando reporte: ${report.id}');

      final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
      final results = _recalculateResults(report, species);
      final translatedRecommendations = _translateRecommendations(
        results['recommendations'],
        report.language,
      );

      final structuredJson = await report.generateStructuredJSON(
        species,
        results,
        translatedRecommendations,
      );

      // Enviar al servidor
      final result = await _apiService.syncOfflineReport(structuredJson);

      if (result['success'] == true) {
        // Marcar como sincronizado
        await LocalReportsStorage.markAsSynced(report.id);

        if (mounted) {
          CustomSnackbar.showSuccess(
            context,
            '✓ Reporte sincronizado exitosamente',
          );
        }

        // Recargar la lista
        await _loadLocalReports();
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } catch (e) {
      print('❌ Error sincronizando reporte: $e');
      if (mounted) {
        CustomSnackbar.showError(
          context,
          'Error al sincronizar: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _syncingReportId = null);
      }
    }
  }

  Future<void> _syncAllReports() async {
    final loc = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('confirm')),
        content: Text(
          '¿Deseas sincronizar todos los reportes pendientes (${_pendingSyncIds.length}) con el servidor?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sincronizar todo'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSyncing = true);

    int successCount = 0;
    int errorCount = 0;

    for (var report in _localReports) {
      if (_pendingSyncIds.contains(report.id)) {
        try {
          final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
          final results = _recalculateResults(report, species);
          final translatedRecommendations = _translateRecommendations(
            results['recommendations'],
            report.language,
          );

          final structuredJson = await report.generateStructuredJSON(
            species,
            results,
            translatedRecommendations,
          );

          final result = await _apiService.syncOfflineReport(structuredJson);

          if (result['success'] == true) {
            await LocalReportsStorage.markAsSynced(report.id);
            successCount++;
          } else {
            errorCount++;
          }
        } catch (e) {
          print('❌ Error sincronizando ${report.id}: $e');
          errorCount++;
        }
      }
    }

    setState(() => _isSyncing = false);

    if (mounted) {
      if (errorCount == 0) {
        CustomSnackbar.showSuccess(
          context,
          '✓ Todos los reportes sincronizados ($successCount)',
        );
      } else {
        CustomSnackbar.showWarning(
          context,
          'Sincronizados: $successCount, Errores: $errorCount',
        );
      }
    }

    await _loadLocalReports();
  }

  void _viewReport(Evaluation report) async {
    final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
    
    // Primero intentar usar los datos ya calculados de la evaluación
    Map<String, dynamic> results;
    
    if (report.overallScore != null && report.overallScore! > 0 && 
        report.categoryScores != null && report.categoryScores!.isNotEmpty) {
      // Usar datos guardados
      results = {
        'overall_score': report.overallScore,
        'category_scores': report.categoryScores,
        'compliance_level': _getComplianceLevel(report.overallScore!, report.speciesId == 'pigs'),
        'recommendations': [],
        'critical_points': _extractCriticalPoints(report, species),
        'strong_points': _extractStrongPoints(report, species),
        'is_ica_evaluation': report.speciesId == 'birds',
        'is_eba_evaluation': report.speciesId == 'pigs',
      };
    } else {
      // Recalcular si no hay datos
      results = _recalculateResults(report, species);
    }
    
    final translatedRecommendations = _translateRecommendations(
      results['recommendations'] ?? [],
      report.language,
    );

    final structuredJson = await report.generateStructuredJSON(
      species,
      results,
      translatedRecommendations,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          evaluation: report,
          species: species,
          results: results,
          structuredJson: structuredJson,
          isLocal: true,
        ),
      ),
    );
  }
  
  String _getComplianceLevel(double score, bool isEBA) {
    if (isEBA) {
      // EBA 5 niveles
      if (score >= 90) return 'excellent';
      if (score >= 75) return 'good';
      if (score >= 50) return 'acceptable';
      if (score >= 25) return 'needs_improvement';
      return 'critical';
    } else {
      // ICA 4 niveles
      if (score >= 90) return 'excellent';
      if (score >= 76) return 'good';
      if (score >= 50) return 'acceptable';
      return 'critical';
    }
  }
  
  List<String> _extractCriticalPoints(Evaluation evaluation, Species species) {
    final criticalPoints = <String>[];
    final isEBA = species.id == 'pigs';
    
    for (var category in species.categories) {
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = evaluation.responses[key];
        
        if (value != null) {
          if (isEBA) {
            // EBA: 0-1 es crítico (escala 0-4)
            if (value is int && value <= 1) {
              criticalPoints.add('${category.id}_${field.id}');
            }
          } else {
            // ICA: respuesta negativa en campos de "buena práctica" es crítico
            if (field.type == FieldType.yesNo) {
              bool isCritical = false;
              if (field.id.contains('access') || field.id.contains('quality') ||
                  field.id.contains('sufficient') || field.id.contains('health')) {
                isCritical = value == false;
              } else {
                isCritical = value == true;
              }
              if (isCritical) {
                criticalPoints.add('${category.id}_${field.id}');
              }
            }
          }
        }
      }
    }
    
    return criticalPoints.take(10).toList();
  }
  
  List<String> _extractStrongPoints(Evaluation evaluation, Species species) {
    final strongPoints = <String>[];
    final isEBA = species.id == 'pigs';
    final categoryScores = evaluation.categoryScores ?? {};
    
    for (var category in species.categories) {
      final score = categoryScores[category.id] ?? 0.0;
      if (score >= 80) {
        strongPoints.add(category.id);
      }
    }
    
    return strongPoints;
  }

  Map<String, dynamic> _recalculateResults(Evaluation evaluation, Species species) {
    final isEBA = species.id == 'pigs';
    
    if (isEBA) {
      return _recalculateEBAResults(evaluation, species);
    } else {
      return _recalculateICAResults(evaluation, species);
    }
  }
  
  Map<String, dynamic> _recalculateEBAResults(Evaluation evaluation, Species species) {
    final categoryScores = <String, double>{};
    final criticalPoints = <String>[];
    final strongPoints = <String>[];
    double totalWeightedScore = 0;
    double totalWeight = 0;
    
    for (var category in species.categories) {
      int categoryObtained = 0;
      int categoryMax = 0;
      
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = evaluation.responses[key];
        
        if (value != null && value is int) {
          categoryObtained += value;
          categoryMax += field.maxScore;
          
          // Punto crítico si score <= 1 (de 4)
          if (value <= 1) {
            criticalPoints.add('${category.id}_${field.id}');
          }
        }
      }
      
      if (categoryMax > 0) {
        final score = (categoryObtained / categoryMax) * 100;
        categoryScores[category.id] = score;
        
        // Calcular score ponderado
        totalWeightedScore += score * category.weight;
        totalWeight += category.weight;
        
        // Punto fuerte si >= 80%
        if (score >= 80) {
          strongPoints.add(category.id);
        }
      }
    }
    
    final overallScore = totalWeight > 0 ? totalWeightedScore / totalWeight : 0.0;
    
    return {
      'overall_score': overallScore,
      'category_scores': categoryScores,
      'compliance_level': _getComplianceLevel(overallScore, true),
      'recommendations': [],
      'critical_points': criticalPoints.take(10).toList(),
      'strong_points': strongPoints,
      'is_eba_evaluation': true,
      'is_ica_evaluation': false,
    };
  }
  
  Map<String, dynamic> _recalculateICAResults(Evaluation evaluation, Species species) {
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
      'is_ica_evaluation': true,
      'is_eba_evaluation': false,
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes Locales'),
        actions: [
          if (_pendingSyncIds.isNotEmpty && !_isSyncing)
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: _syncAllReports,
              tooltip: 'Sincronizar todos',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLocalReports,
              child: _localReports.isEmpty
                  ? _buildEmptyState(loc)
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (_pendingSyncIds.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: BianTheme.warningYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: BianTheme.warningYellow,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.sync,
                                  color: BianTheme.warningYellow,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_pendingSyncIds.length} reporte(s) pendiente(s)',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: BianTheme.warningYellow,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Estos reportes se crearon sin conexión y están listos para sincronizar',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ..._localReports.map((report) => _buildReportCard(report)),
                      ],
                    ),
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_done,
              size: 80,
              color: BianTheme.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay reportes locales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: BianTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los reportes creados sin conexión aparecerán aquí',
              style: TextStyle(
                fontSize: 14,
                color: BianTheme.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Evaluation report) {
    final isPending = _pendingSyncIds.contains(report.id);

    Color scoreColor;
    if (report.overallScore! >= 80) {
      scoreColor = BianTheme.successGreen;
    } else if (report.overallScore! >= 60) {
      scoreColor = BianTheme.warningYellow;
    } else {
      scoreColor = BianTheme.errorRed;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${report.overallScore!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                              fontSize: 12,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  report.farmName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (isPending)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: BianTheme.warningYellow.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.sync,
                                        size: 14,
                                        color: BianTheme.warningYellow,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Pendiente',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: BianTheme.warningYellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                report.speciesId == 'birds'
                                    ? 'assets/icons/ave.svg'
                                    : 'assets/icons/cerdo.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  BianTheme.primaryRed,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: BianTheme.mediumGray,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  report.farmLocation,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: BianTheme.mediumGray,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: BianTheme.mediumGray,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${report.evaluationDate.day}/${report.evaluationDate.month}/${report.evaluationDate.year}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: BianTheme.mediumGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isPending) ...[
                  const SizedBox(height: 12),
                  if (_syncingReportId == report.id)
                    const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _syncReport(report),
                      icon: const Icon(Icons.cloud_upload, size: 18),
                      label: const Text('Sincronizar ahora'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BianTheme.infoBlue,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
