// lib/features/home/offline_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/species_model.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/app_mode_provider.dart';
import '../evaluation/evaluation_screen.dart';
import '../evaluation/results_screen.dart';
import '../auth/login_screen.dart';

class OfflineHomeScreen extends StatefulWidget {
  const OfflineHomeScreen({super.key});

  @override
  State<OfflineHomeScreen> createState() => _OfflineHomeScreenState();
}

class _OfflineHomeScreenState extends State<OfflineHomeScreen>
    with WidgetsBindingObserver {
  List<Evaluation> _localReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocalReports();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App cerrada o en segundo plano - limpiar reportes
      LocalReportsStorage.clearAllLocalReports();
    }
  }

  Future<void> _loadLocalReports() async {
    setState(() => _isLoading = true);
    final reports = await LocalReportsStorage.getAllLocalReports();
    setState(() {
      _localReports = reports;
      _isLoading = false;
    });
  }

  void _navigateToEvaluation(Species species) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

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
    final species =
        report.speciesId == 'birds' ? Species.birds() : Species.pigs();
    final results = _recalculateResults(report, species);
    final translatedRecommendations =
        _translateRecommendations(results['recommendations'], report.language);
    final structuredJson = await report.generateStructuredJSON(
        species, results, translatedRecommendations);

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
    if (categoryScores['feeding'] != null && categoryScores['feeding']! < 70)
      recommendationKeys.add('improve_feeding_practices');
    if (categoryScores['health'] != null && categoryScores['health']! < 70)
      recommendationKeys.add('strengthen_health_program');
    if (categoryScores['infrastructure'] != null &&
        categoryScores['infrastructure']! < 70)
      recommendationKeys.add('improve_infrastructure');
    if (categoryScores['management'] != null &&
        categoryScores['management']! < 70)
      recommendationKeys.add('train_staff_welfare');
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

    return recommendationKeys
        .map((key) => translations[key] ?? key.toString())
        .toList();
  }

// lib/features/home/offline_home_screen.dart - ACTUALIZAR TRADUCCIONES

// En el método _deleteLocalReport:
  Future<void> _deleteLocalReport(String id) async {
    final loc = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('delete_local_report')),
        content: Text(loc.translate('delete_local_report_confirm')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(loc.translate('cancel'))),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: BianTheme.errorRed),
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('delete')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await LocalReportsStorage.deleteLocalReport(id);
      _loadLocalReports();
    }
  }

// En el método _exitOfflineMode:

// lib/features/home/offline_home_screen.dart - ACTUALIZAR con WillPopScope

// ✅ ENVOLVER EL Scaffold CON WillPopScope:

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: () async {
        // Mostrar diálogo confirmando salida del modo offline
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: BianTheme.warningYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.exit_to_app,
                    color: BianTheme.warningYellow,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loc.translate('exit_offline_mode'),
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
                  loc.translate('exit_offline_mode_warning'),
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BianTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: BianTheme.errorRed.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: BianTheme.errorRed, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _localReports.isEmpty
                              ? 'Se cerrará el modo sin conexión'
                              : 'Se eliminarán ${_localReports.length} reporte(s) local(es)',
                          style: TextStyle(
                              fontSize: 12,
                              color: BianTheme.darkGray,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(loc.translate('cancel')),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: Icon(Icons.exit_to_app),
                label: Text(loc.translate('exit')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BianTheme.errorRed,
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {
          // Limpiar reportes locales
          await LocalReportsStorage.clearAllLocalReports();

          // Cambiar modo a online
          if (mounted) {
            Provider.of<AppModeProvider>(context, listen: false)
                .setMode(AppMode.online);

            // Navegar a LoginScreen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
          return false; // No permitir el pop normal, ya navegamos manualmente
        }

        return false; // No salir si canceló
      },
      child: Scaffold(
        appBar: AppBar(
          // ✅ IMPORTANTE: Remover el leading para que use el botón de retroceso por defecto
          // que será interceptado por WillPopScope
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
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                // Usar la misma lógica del WillPopScope
                await (this as State)
                    .context
                    .findAncestorWidgetOfExactType<WillPopScope>()
                    ?.onWillPop
                    ?.call();
              },
              tooltip: loc.translate('exit'),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: BianTheme.warningYellow.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: BianTheme.warningYellow),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      loc.translate('offline_reports_lost_on_close'),
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
            Expanded(
              child: SingleChildScrollView(
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
                        onTap: () => _navigateToEvaluation(Species.birds())),
                    const SizedBox(height: 16),
                    _buildSpeciesCard(
                        species: Species.pigs(),
                        onTap: () => _navigateToEvaluation(Species.pigs())),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(loc.translate('local_reports'),
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text('${_localReports.length}/10',
                            style: TextStyle(
                                color: BianTheme.mediumGray, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_localReports.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: BianTheme.lightGray.withOpacity(0.5)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.assignment_outlined,
                                size: 64,
                                color: BianTheme.mediumGray.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(loc.translate('no_local_reports'),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: BianTheme.mediumGray)),
                          ],
                        ),
                      )
                    else
                      ..._localReports
                          .map((report) => _buildReportCard(report)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesCard(
      {required Species species, required VoidCallback onTap}) {
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
              color:
                  Color(int.parse(species.gradientColors[0])).withOpacity(0.3),
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
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)
                        .translate('${species.id}_subtitle'),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 20),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('${report.overallScore!.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: scoreColor)),
                      Text('%',
                          style: TextStyle(fontSize: 12, color: scoreColor)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.farmName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: BianTheme.mediumGray),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(report.farmLocation,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: BianTheme.mediumGray),
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: BianTheme.errorRed),
                  onPressed: () => _deleteLocalReport(report.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
