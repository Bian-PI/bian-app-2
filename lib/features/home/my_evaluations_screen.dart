import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/models/species_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/api/api_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../core/storage/reports_storage.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/storage/secure_storage.dart';
import '../evaluation/results_screen.dart';
import 'package:intl/intl.dart';

/// Pantalla dedicada para mostrar todas las evaluaciones del usuario actual
/// Separada del HomeScreen para mejor organización y rendimiento
class MyEvaluationsScreen extends StatefulWidget {
  const MyEvaluationsScreen({super.key});

  @override
  State<MyEvaluationsScreen> createState() => _MyEvaluationsScreenState();
}

class _MyEvaluationsScreenState extends State<MyEvaluationsScreen> {
  final _apiService = ApiService();
  final _storage = SecureStorage();

  List<Evaluation> _serverReports = [];
  List<Evaluation> _localReports = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _reportTotal = 0;
  int _reportOffset = 0;
  bool _hasMoreReports = false;
  final int _reportLimit = 20;

  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
  }

  Future<void> _loadEvaluations() async {
    setState(() => _isLoading = true);

    try {
      // Obtener ID del usuario actual
      final user = await _storage.getUser();
      if (user == null) {
        print('⚠️ No hay usuario logueado');
        if (mounted) {
          CustomSnackbar.showError(
            context,
            AppLocalizations.of(context).translate('no_user_logged_in'),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      _userId = user.id.toString();
      print(
          '👤 Cargando evaluaciones SOLO del servidor para usuario: ${user.name} (ID: $_userId)');

      // SOLO cargar reportes del servidor (NO locales)
      final result = await _apiService.getUserEvaluations(
        limit: _reportLimit,
        offset: 0,
      );

      if (result['success'] == true) {
        final evaluationsData = result['evaluations'] as List;
        final serverReports =
            evaluationsData.map((e) => Evaluation.fromJson(e)).toList();

        final total = result['total'] ?? 0;
        final hasMore = result['hasMore'] ?? false;

        print('✅ Reportes del servidor: ${serverReports.length} de $total');

        setState(() {
          _serverReports = serverReports;
          _localReports = []; // NO mostrar locales aquí
          _reportTotal = total;
          _hasMoreReports = hasMore;
          _reportOffset = serverReports.length;
          _isLoading = false;
        });
      } else {
        print('⚠️ Error cargando reportes del servidor: ${result['message']}');

        setState(() {
          _serverReports = [];
          _localReports = [];
          _isLoading = false;
        });

        if (mounted) {
          CustomSnackbar.showError(
            context,
            AppLocalizations.of(context).translate('error_loading_evaluations'),
          );
        }
      }
    } catch (e) {
      print('❌ Error cargando evaluaciones: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        CustomSnackbar.showError(
          context,
          AppLocalizations.of(context).translate('connection_error'),
        );
      }
    }
  }

  Future<void> _loadMoreReports() async {
    if (_isLoadingMore || !_hasMoreReports) return;

    setState(() => _isLoadingMore = true);

    try {
      final result = await _apiService.getUserEvaluations(
        limit: _reportLimit,
        offset: _reportOffset,
      );

      if (result['success'] == true) {
        final evaluationsData = result['evaluations'] as List;
        final newReports =
            evaluationsData.map((e) => Evaluation.fromJson(e)).toList();

        setState(() {
          _serverReports.addAll(newReports);
          _reportOffset += newReports.length;
          _hasMoreReports = result['hasMore'] ?? false;
          _isLoadingMore = false;
        });

        print(
            '✅ Más reportes cargados: +${newReports.length} (total: ${_serverReports.length})');
      }
    } catch (e) {
      print('❌ Error cargando más reportes: $e');
      setState(() => _isLoadingMore = false);

      if (mounted) {
        CustomSnackbar.showError(
          context,
          AppLocalizations.of(context).translate('error_loading_more'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('my_evaluations')),
        backgroundColor: BianTheme.primaryRed,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEvaluations,
              child: _buildEvaluationsList(loc),
            ),
    );
  }

  Widget _buildEvaluationsList(AppLocalizations loc) {
    final totalEvaluations = _localReports.length + _serverReports.length;

    if (totalEvaluations == 0) {
      return _buildEmptyState(loc);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: totalEvaluations + (_hasMoreReports ? 1 : 0),
      itemBuilder: (context, index) {
        // Primero mostrar reportes locales
        if (index < _localReports.length) {
          return _buildLocalReportCard(_localReports[index], loc);
        }

        // Luego reportes del servidor
        final serverIndex = index - _localReports.length;
        if (serverIndex < _serverReports.length) {
          return _buildServerReportCard(_serverReports[serverIndex], loc);
        }

        // Botón "Cargar más"
        return _buildLoadMoreButton(loc);
      },
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
              Icons.assignment_outlined,
              size: 80,
              color: BianTheme.lightGray,
            ),
            const SizedBox(height: 16),
            Text(
              loc.translate('no_evaluations_yet'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: BianTheme.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              loc.translate('start_evaluation_to_see_here'),
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

  Widget _buildLocalReportCard(Evaluation evaluation, AppLocalizations loc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: BianTheme.warningYellow,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navegar a detalles del reporte local
          _showLocalReportDetails(evaluation, loc);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BianTheme.warningYellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sync,
                          size: 14,
                          color: BianTheme.warningYellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          loc.translate('pending_sync'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: BianTheme.warningYellow,
                          ),
                        ),
                      ],
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

  Widget _buildServerReportCard(Evaluation evaluation, AppLocalizations loc) {
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
        onTap: () {
          // Navegar a ResultsScreen con el reporte completo reconstruido
          _viewServerReport(evaluation);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  const SizedBox(width: 16),
                  Icon(
                    Icons.cloud_done,
                    size: 14,
                    color: BianTheme.successGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    loc.translate('synced'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: BianTheme.successGreen,
                      fontWeight: FontWeight.w600,
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

  Widget _buildLoadMoreButton(AppLocalizations loc) {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: _loadMoreReports,
          icon: const Icon(Icons.refresh),
          label: Text(loc.translate('load_more')),
          style: OutlinedButton.styleFrom(
            foregroundColor: BianTheme.primaryRed,
            side: const BorderSide(color: BianTheme.primaryRed),
          ),
        ),
      ),
    );
  }

  void _showLocalReportDetails(Evaluation evaluation, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('local_report')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evaluation.farmName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${loc.translate('location')}: ${evaluation.farmLocation}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${loc.translate('date')}: ${DateFormat('dd/MM/yyyy').format(evaluation.evaluationDate)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BianTheme.warningYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: BianTheme.warningYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.translate('pending_sync_message'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('close')),
          ),
        ],
      ),
    );
  }

  /// Obtiene los detalles completos del servidor y muestra el reporte en ResultsScreen
  void _viewServerReport(Evaluation evaluation) async {
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
        final species = fullEvaluation.speciesId == 'birds'
            ? Species.birds()
            : Species.pigs();

        print('📊 DEBUG Final - overallScore: ${fullEvaluation.overallScore}');

        print(
            '📊 DEBUG Final - categoryScores: ${fullEvaluation.categoryScores}');

        print(
            '📊 DEBUG Final - responses length: ${fullEvaluation.responses.length}');

        Map<String, dynamic> results;

        // CONFIAR en lo que el backend envía - ya se parseó correctamente

        if (fullEvaluation.overallScore != null &&
            fullEvaluation.categoryScores != null &&
            fullEvaluation.categoryScores!.isNotEmpty) {
          print('✅ USANDO datos del servidor directamente');

          results = {
            'overall_score': fullEvaluation.overallScore!,
            'compliance_level':
                _getComplianceLevel(fullEvaluation.overallScore!),
            'category_scores': fullEvaluation.categoryScores!,
            'recommendations': _generateRecommendationKeys(
              fullEvaluation.overallScore!,
              fullEvaluation.categoryScores!,
            ),
            'critical_points': [],
            'strong_points': [],
          };

          print(
              '✅ Results del servidor: overall=${results['overall_score']}%, categories=${results['category_scores']}');
        } else {
          // Solo recalcular si el servidor no envió los datos completos

          print('⚠️ Servidor no envió scores completos, recalculando...');

          results = _recalculateResults(fullEvaluation, species);

          print('📊 Results recalculados: ${results}');
        }
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

  String _getComplianceLevel(double overallScore) {
    if (overallScore >= 90) {
      return 'excellent';
    } else if (overallScore >= 75) {
      return 'good';
    } else if (overallScore >= 60) {
      return 'acceptable';
    } else if (overallScore >= 40) {
      return 'needs_improvement';
    } else {
      return 'critical';
    }
  }

  List<String> _generateRecommendationKeys(
      double overallScore, Map<String, double> categoryScores) {
    final recommendationKeys = <String>[];
    if (overallScore < 60)
      recommendationKeys.add('immediate_attention_required');
    if (categoryScores['feeding'] != null && categoryScores['feeding']! < 70) {
      recommendationKeys.add('improve_feeding_practices');
    }
    if (categoryScores['health'] != null && categoryScores['health']! < 70) {
      recommendationKeys.add('strengthen_health_program');
    }
    if (categoryScores['infrastructure'] != null &&
        categoryScores['infrastructure']! < 70) {
      recommendationKeys.add('improve_infrastructure');
    }
    if (categoryScores['management'] != null &&
        categoryScores['management']! < 70) {
      recommendationKeys.add('train_staff_welfare');
    }
    if (recommendationKeys.isEmpty)
      recommendationKeys.add('maintain_current_practices');
    return recommendationKeys;
  }

  Map<String, dynamic> _recalculateResults(
      Evaluation evaluation, Species species) {
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

    final overallScore =
        totalQuestions > 0 ? (positiveResponses / totalQuestions) * 100 : 0;

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
    if (overallScore < 60)
      recommendationKeys.add('immediate_attention_required');
    if (categoryScores['feeding'] != null && categoryScores['feeding']! < 70) {
      recommendationKeys.add('improve_feeding_practices');
    }
    if (categoryScores['health'] != null && categoryScores['health']! < 70) {
      recommendationKeys.add('strengthen_health_program');
    }
    if (categoryScores['infrastructure'] != null &&
        categoryScores['infrastructure']! < 70) {
      recommendationKeys.add('improve_infrastructure');
    }
    if (categoryScores['management'] != null &&
        categoryScores['management']! < 70) {
      recommendationKeys.add('train_staff_welfare');
    }
    if (recommendationKeys.isEmpty)
      recommendationKeys.add('maintain_current_practices');

    return {
      'overall_score': overallScore,
      'compliance_level': complianceLevel,
      'category_scores': categoryScores,
      'recommendations': recommendationKeys,
      'critical_points': [],
      'strong_points': [],
    };
  }

  List<String> _translateRecommendations(
      List recommendationKeys, String language) {
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
