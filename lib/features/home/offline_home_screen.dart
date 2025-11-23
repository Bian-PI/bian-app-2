import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/storage/reports_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/species_model.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/app_mode_provider.dart';
import '../../core/utils/connectivity_service.dart';
import '../../core/api/api_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../evaluation/evaluation_screen.dart';
import '../evaluation/results_screen.dart';
import '../auth/login_screen.dart';

class OfflineHomeScreen extends StatefulWidget {
  const OfflineHomeScreen({super.key});

  @override
  State<OfflineHomeScreen> createState() => _OfflineHomeScreenState();
}

class _OfflineHomeScreenState extends State<OfflineHomeScreen> {
  List<Evaluation> _localReports = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  int _pendingSyncCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLocalReports();
  }

  Future<void> _loadLocalReports() async {
    setState(() => _isLoading = true);
    final reports = await LocalReportsStorage.getAllLocalReports();
    final pendingCount = await LocalReportsStorage.getPendingSyncCount();
    setState(() {
      _localReports = reports;
      _pendingSyncCount = pendingCount;
      _isLoading = false;
    });
  }

  void _navigateToEvaluation(Species species) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EvaluationScreen(
          species: species,
          currentLanguage: languageProvider.locale.languageCode,
          isOfflineMode: true,
        ),
      ),
    );

    _loadLocalReports();
  }

  void _viewReport(Evaluation report) async {
    final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
    final results = _recalculateResults(report, species);
    final translatedRecommendations = _translateRecommendations(
      results['recommendations'] ?? [], 
      report.language,
    );
    final structuredJson = await report.generateStructuredJSON(
      species,
      results,
      translatedRecommendations,
      isOfflineMode: true,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          evaluation: report,
          species: species,
          results: results,
          structuredJson: structuredJson,
        ),
      ),
    );
  }

  Map<String, dynamic> _recalculateResults(Evaluation evaluation, Species species) {
    int totalQuestions = 0;
    int positiveResponses = 0;
    final categoryScores = <String, double>{};
    final criticalPoints = <String>[];
    final strongPoints = <String>[];

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
            } else {
              criticalPoints.add('${category.id}_${field.id}');
            }
          }
        }
      }

      if (categoryTotal > 0) {
        final score = (categoryPositive / categoryTotal) * 100;
        categoryScores[category.id] = score;
        if (score >= 80) {
          strongPoints.add(category.id);
        }
      }
    }

    final overallScore = totalQuestions > 0 ? (positiveResponses / totalQuestions) * 100 : 0.0;

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
      'critical_points': criticalPoints,
      'strong_points': strongPoints,
      'recommendations': recommendationKeys,
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

    return recommendationKeys
        .where((key) => translations.containsKey(key))
        .map((key) => translations[key]!)
        .toList();
  }

  Future<void> _deleteLocalReport(String id) async {
    final loc = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(loc.translate('delete_local_report')),
        content: Text(loc.translate('delete_local_report_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BianTheme.errorRed),
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('delete')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await LocalReportsStorage.deleteLocalReport(id);
      _loadLocalReports();
      
      if (mounted) {
        CustomSnackbar.showSuccess(context, 'Reporte eliminado');
      }
    }
  }


  Future<void> _showSyncDialog() async {
    final loc = AppLocalizations.of(context);
    final connectivityService = Provider.of<ConnectivityService>(context, listen: false);

    final hasConnection = await connectivityService.checkConnection();

    if (!hasConnection) {
      if (!mounted) return;
      CustomSnackbar.showError(context, loc.translate('no_connection'));
      return;
    }

    if (_pendingSyncCount == 0) {
      if (!mounted) return;
      CustomSnackbar.showInfo(context, 'No hay reportes pendientes de sincronizar');
      return;
    }

    await showDialog(
      context: context,
      builder: (dialogContext) => _SyncReportsDialog(
        pendingReports: await LocalReportsStorage.getPendingSyncReports(),
        onSyncAll: () async {
          Navigator.pop(dialogContext);
          await _performSync();
        },
        onSyncSingle: (report) async {
          Navigator.pop(dialogContext);
          await _performSingleSync(report);
        },
      ),
    );
  }

  Future<void> _performSync() async {
    setState(() => _isSyncing = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BianTheme.successGreen,
                  BianTheme.successGreen.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: BianTheme.successGreen.withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Sincronizando Reportes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Subiendo a la nube...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final pendingReports = await LocalReportsStorage.getPendingSyncReports();
      final apiService = ApiService();

      int syncedCount = 0;
      int errorCount = 0;

      for (var report in pendingReports) {
        try {
          final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
          final results = _recalculateResults(report, species);
          final translatedRecommendations = _translateRecommendations(
            results['recommendations'] ?? [],
            report.language,
          );
          final structuredJson = await report.generateStructuredJSON(
            species,
            results,
            translatedRecommendations,
            isOfflineMode: true,
          );

          structuredJson['user_document'] = report.evaluatorDocument;

          final syncResult = await apiService.syncOfflineReport(structuredJson);

          if (syncResult['success'] == true) {
            await LocalReportsStorage.markAsSynced(report.id);

            await ReportsStorage.saveReport(report.copyWith(status: 'synced'));

            await LocalReportsStorage.deleteLocalReport(report.id);

            syncedCount++;
          } else {
            errorCount++;
            print('❌ Error sincronizando ${report.id}: ${syncResult['message']}');
          }
        } catch (e) {
          errorCount++;
          print('❌ Error sincronizando reporte: $e');
        }
      }

      if (mounted) Navigator.pop(context);

      await _loadLocalReports();

      if (mounted) {
        if (errorCount == 0 && syncedCount > 0) {
          CustomSnackbar.showSuccess(
            context,
            '$syncedCount reporte(s) sincronizado(s) correctamente',
            duration: Duration(seconds: 4),
          );
        } else if (errorCount > 0 && syncedCount > 0) {
          CustomSnackbar.showWarning(
            context,
            '$syncedCount sincronizado(s), $errorCount con error',
            duration: Duration(seconds: 4),
          );
        } else if (errorCount > 0 && syncedCount == 0) {
          CustomSnackbar.showError(
            context,
            'Error al sincronizar. Intenta más tarde.',
            duration: Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      print('💥 Error en sincronización: $e');
      if (mounted) {
        Navigator.pop(context);
        CustomSnackbar.showError(context, 'Error de conexión: $e');
      }
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  Future<bool> _handleExitOfflineMode() async {
    final loc = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: BianTheme.infoBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.login, color: BianTheme.infoBlue, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ir a Iniciar Sesión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Deseas ir a la pantalla de inicio de sesión?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            if (_localReports.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BianTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: BianTheme.successGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.save, color: BianTheme.successGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tus ${_localReports.length} reporte(s) local(es) se conservarán',
                        style: TextStyle(
                          fontSize: 12,
                          color: BianTheme.darkGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: Icon(Icons.login),
            label: Text('Ir a Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: BianTheme.primaryRed,
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (mounted) {
        Provider.of<AppModeProvider>(context, listen: false).setMode(AppMode.online);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: _handleExitOfflineMode,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              Icon(Icons.offline_bolt, color: Colors.white),
              const SizedBox(width: 8),
              Text(loc.translate('offline_mode_title')),
            ],
          ),
          backgroundColor: BianTheme.warningYellow,
          actions: [
            if (_pendingSyncCount > 0)
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.cloud_upload),
                    onPressed: _isSyncing ? null : _showSyncDialog,
                    tooltip: 'Sincronizar',
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: BianTheme.errorRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$_pendingSyncCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            IconButton(
              icon: Icon(Icons.login),
              onPressed: _handleExitOfflineMode,
              tooltip: 'Ir a Login',
            ),
          ],
        ),
        body: Column(
          children: [
            if (_pendingSyncCount > 0)
              InkWell(
                onTap: _isSyncing ? null : _showSyncDialog,
                child: Container(
                  color: BianTheme.successGreen.withOpacity(0.12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_upload, color: BianTheme.successGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$_pendingSyncCount reporte(s) listo(s) para sincronizar',
                          style: TextStyle(
                            fontSize: 13,
                            color: BianTheme.darkGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!_isSyncing)
                        Icon(Icons.chevron_right, color: BianTheme.successGreen, size: 20),
                      if (_isSyncing)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(BianTheme.successGreen),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadLocalReports,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.translate('create_new_evaluation'),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 24),
                      _buildSpeciesCard(
                        species: Species.birds(),
                        onTap: () => _navigateToEvaluation(Species.birds()),
                      ),
                      const SizedBox(height: 16),
                      _buildSpeciesCard(
                        species: Species.pigs(),
                        onTap: () => _navigateToEvaluation(Species.pigs()),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.translate('local_reports'),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '${_localReports.length}/$maxReports',
                            style: TextStyle(color: BianTheme.mediumGray, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (_localReports.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: BianTheme.lightGray.withOpacity(0.5)),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 64,
                                color: BianTheme.mediumGray.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loc.translate('no_local_reports'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: BianTheme.mediumGray,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Los reportes que crees se guardarán aquí',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: BianTheme.mediumGray,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ..._localReports.map((report) => _buildReportCard(report)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const int maxReports = 20;

  Widget _buildSpeciesCard({required Species species, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(int.parse(species.gradientColors[0])),
              Color(int.parse(species.gradientColors[1])),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(int.parse(species.gradientColors[0])).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SvgPicture.asset(
                species.iconPath,
                width: 40,
                height: 40,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate(species.id),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).translate('${species.id}_subtitle'),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Evaluation report) {
    Color scoreColor;
    if (report.overallScore! >= 80) {
      scoreColor = BianTheme.successGreen;
    } else if (report.overallScore! >= 60) {
      scoreColor = BianTheme.warningYellow;
    } else {
      scoreColor = BianTheme.errorRed;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _viewReport(report),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                            style: TextStyle(fontSize: 12, color: scoreColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.farmName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: BianTheme.mediumGray),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  report.farmLocation,
                                  style: TextStyle(fontSize: 12, color: BianTheme.mediumGray),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: BianTheme.mediumGray),
                              const SizedBox(width: 4),
                              Text(
                                '${report.evaluationDate.day}/${report.evaluationDate.month}/${report.evaluationDate.year}',
                                style: TextStyle(fontSize: 12, color: BianTheme.mediumGray),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: BianTheme.warningYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: BianTheme.warningYellow.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cloud_off,
                                size: 12,
                                color: BianTheme.warningYellow,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Local',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: BianTheme.warningYellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: BianTheme.errorRed),
                          onPressed: () => _deleteLocalReport(report.id),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performSingleSync(Evaluation report) async {
    setState(() => _isSyncing = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BianTheme.successGreen,
                  BianTheme.successGreen.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: BianTheme.successGreen.withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sincronizando...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final apiService = ApiService();
      final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
      final results = _recalculateResults(report, species);
      final translatedRecommendations = _translateRecommendations(
        results['recommendations'] ?? [],
        report.language,
      );
      final structuredJson = await report.generateStructuredJSON(
        species,
        results,
        translatedRecommendations,
        isOfflineMode: true,
      );

      final response = await apiService.submitEvaluation(structuredJson);

      if (response['success'] == true) {
        await LocalReportsStorage.markAsSynced(report.id);
        if (!mounted) return;
        Navigator.pop(context);
        CustomSnackbar.showSuccess(context, 'Reporte sincronizado correctamente');
      } else {
        throw Exception(response['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      CustomSnackbar.showError(context, 'Error: ${e.toString()}');
    } finally {
      setState(() => _isSyncing = false);
      await _loadLocalReports();
    }
  }
}

class _SyncReportsDialog extends StatelessWidget {
  final List<Evaluation> pendingReports;
  final VoidCallback onSyncAll;
  final Function(Evaluation) onSyncSingle;

  const _SyncReportsDialog({
    required this.pendingReports,
    required this.onSyncAll,
    required this.onSyncSingle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BianTheme.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.cloud_upload, color: BianTheme.successGreen, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sincronizar Reportes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${pendingReports.length} reporte(s) pendiente(s)',
                          style: TextStyle(fontSize: 12, color: BianTheme.mediumGray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pendingReports.length,
                itemBuilder: (context, index) {
                  final report = pendingReports[index];
                  return ListTile(
                    leading: Icon(Icons.description, color: BianTheme.infoBlue),
                    title: Text(
                      report.farmName,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${report.speciesId} - ${report.farmLocation}',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.upload, color: BianTheme.successGreen),
                      onPressed: () => onSyncSingle(report),
                      tooltip: 'Sincronizar',
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onSyncAll,
                      icon: Icon(Icons.cloud_done),
                      label: Text('Sincronizar Todos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BianTheme.successGreen,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}