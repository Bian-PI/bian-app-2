import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/models/species_model.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/storage/drafts_storage.dart';
import '../../core/storage/reports_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import 'results_screen.dart';
import 'package:uuid/uuid.dart';
import '../../core/storage/local_reports_storage.dart';
import '../../core/utils/location_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/models/user_model.dart';
import '../../core/api/api_service.dart';
import 'package:intl/intl.dart';

class EvaluationScreen extends StatefulWidget {
  final Species species;
  final Evaluation? draftToEdit;
  final String currentLanguage;
  final bool isOfflineMode;

  const EvaluationScreen({
    super.key,
    required this.species,
    this.draftToEdit,
    required this.currentLanguage,
    this.isOfflineMode = false,
  });

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final _uuid = const Uuid();
  final _scrollController = ScrollController();
  final _storage = SecureStorage();

  int _currentCategoryIndex = 0;
  late Evaluation _evaluation;

  final _farmNameController = TextEditingController();
  final _farmLocationController = TextEditingController();
  final _evaluatorNameController = TextEditingController();
  final _evaluatorDocumentController = TextEditingController();

  final Map<String, TextEditingController> _textControllers = {};

  bool _showInfoDialog = true;
  bool _hasUnsavedChanges = false;
  bool _isGettingLocation = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeEvaluation();
    _loadCurrentUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.draftToEdit == null && _showInfoDialog) {
        _showWelcomeDialog();
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = await _storage.getUser();
    if (mounted && user != null) {
      setState(() {
        _currentUser = user;
      });
      print('✅ Usuario logueado cargado: ${user.name}, documento: ${user.document}');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _evaluatorNameController.dispose();
    _evaluatorDocumentController.dispose();
    _textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeEvaluation() {
    if (widget.draftToEdit != null) {
      _evaluation = widget.draftToEdit!;
      _farmNameController.text = _evaluation.farmName;
      _farmLocationController.text = _evaluation.farmLocation;
      _evaluatorNameController.text = _evaluation.evaluatorName;
      _showInfoDialog = false;
      
      for (var category in widget.species.categories) {
        for (var field in category.fields) {
          final key = '${category.id}_${field.id}';
          final value = _evaluation.responses[key];
          if (value != null && (field.type == FieldType.number || 
              field.type == FieldType.percentage || 
              field.type == FieldType.text)) {
            _textControllers[key] = TextEditingController(text: value.toString());
          }
        }
      }
    } else {
      _evaluation = Evaluation(
        id: _uuid.v4(),
        speciesId: widget.species.id,
        farmName: '',
        farmLocation: '',
        evaluationDate: DateTime.now(),
        evaluatorName: '',
        evaluatorDocument: '',
        responses: {},
        status: 'draft',
        language: widget.currentLanguage,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  void _showWelcomeDialog() {
    final loc = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(int.parse(widget.species.gradientColors[0])).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                widget.species.iconPath,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  Color(int.parse(widget.species.gradientColors[0])),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${loc.translate('evaluation_of')} ${widget.species.namePlural}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.translate('welcome_evaluation'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                loc.translate('categories_to_evaluate', [widget.species.categories.length.toString()]),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              ...widget.species.categories.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getIconData(cat.icon),
                      size: 20,
                      color: Color(int.parse(widget.species.gradientColors[0])),
                    ),
                    const SizedBox(width: 12),
                    Text(loc.translate(cat.id)),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BianTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: BianTheme.infoBlue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: BianTheme.infoBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        loc.translate('first_enter_farm_data'),
                        style: TextStyle(
                          fontSize: 12,
                          color: BianTheme.darkGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _showInfoDialog = false);
              Navigator.pop(context);
              _showFarmInfoDialog();
            },
            child: Text(loc.translate('start')),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final loc = AppLocalizations.of(context);

    setState(() => _isGettingLocation = true);

    final location = await LocationService.getCurrentLocation();

    setState(() => _isGettingLocation = false);

    if (location != null) {
      setState(() {
        _farmLocationController.text = location;
      });

      if (mounted) {
        CustomSnackbar.showSuccess(
          context,
          '${loc.translate('location')}: $location',
        );
      }
    } else {
      if (mounted) {
        final permissionStatus = await LocationService.checkAndRequestPermission();

        String message;
        String actionLabel;
        VoidCallback onAction;

        switch (permissionStatus) {
          case LocationPermissionStatus.serviceDisabled:
            message = loc.translate('gps_disabled');
            actionLabel = loc.translate('enable_gps');
            onAction = () => LocationService.openLocationSettings();
            break;
          case LocationPermissionStatus.deniedForever:
            message = loc.translate('permission_denied_permanently');
            actionLabel = loc.translate('open_settings');
            onAction = () => LocationService.openAppSettings();
            break;
          case LocationPermissionStatus.denied:
          case LocationPermissionStatus.granted:
          // Si fue denegado o cualquier otro error
            message = loc.translate('location_permission_denied');
            actionLabel = loc.translate('open_settings');
            onAction = () => LocationService.openAppSettings();
            break;
        }

        CustomSnackbar.show(
          context,
          message,
          isError: true,
          actionLabel: actionLabel,
          onActionPressed: onAction,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  void _showFarmInfoDialog() {
    final loc = AppLocalizations.of(context);

    // Pre-rellenar datos del usuario logueado si existen (solo en modo online)
    final bool hasUserDocument = !widget.isOfflineMode &&
                                   _currentUser != null &&
                                   _currentUser!.document != null &&
                                   _currentUser!.document!.isNotEmpty;

    if (!widget.isOfflineMode && _currentUser != null) {
      _evaluatorNameController.text = _currentUser!.name;
      if (hasUserDocument) {
        _evaluatorDocumentController.text = _currentUser!.document!;
      }
      print('✅ Datos del usuario autocompletados en formulario');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(loc.translate('farm_information')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Solo mostrar campo de documento en modo ONLINE si el usuario NO lo tiene
                if (!widget.isOfflineMode && !hasUserDocument)
                  TextField(
                    controller: _evaluatorDocumentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '${loc.translate('document')} *',
                      hintText: '1234567890',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                if (!widget.isOfflineMode && !hasUserDocument) const SizedBox(height: 16),

                TextField(
                  controller: _farmNameController,
                  decoration: InputDecoration(
                    labelText: '${loc.translate('farm_name')} *',
                    hintText: loc.translate('farm_name_example'),
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _farmLocationController,
                  decoration: InputDecoration(
                    labelText: '${loc.translate('location')} *',
                    hintText: loc.translate('location_example'),
                    prefixIcon: Icon(Icons.location_on),
                    suffixIcon: _isGettingLocation
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  BianTheme.primaryRed,
                                ),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: () async {
                              setDialogState(() => _isGettingLocation = true);
                              setState(() => _isGettingLocation = true);
                              await _getCurrentLocation();
                              setDialogState(() => _isGettingLocation = false);
                              setState(() => _isGettingLocation = false);
                            },
                            tooltip: loc.translate('get_current_location'),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _evaluatorNameController,
                  decoration: InputDecoration(
                    labelText: '${loc.translate('evaluator_name')} *',
                    hintText: loc.translate('evaluator_name_hint'),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(loc.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                // Determinar si el usuario tiene documento guardado (solo en modo online)
                final bool hasUserDocument = !widget.isOfflineMode &&
                                               _currentUser != null &&
                                               _currentUser!.document != null &&
                                               _currentUser!.document!.isNotEmpty;

                // Validar campos obligatorios básicos
                if (_farmNameController.text.trim().isEmpty ||
                    _farmLocationController.text.trim().isEmpty ||
                    _evaluatorNameController.text.trim().isEmpty) {
                  CustomSnackbar.showError(
                    context,
                    loc.translate('complete_all_fields'),
                  );
                  return;
                }

                // Validar documento solo en modo ONLINE si NO tiene documento de usuario
                if (!widget.isOfflineMode && !hasUserDocument && _evaluatorDocumentController.text.trim().isEmpty) {
                  CustomSnackbar.showError(
                    context,
                    loc.translate('complete_all_fields'),
                  );
                  return;
                }

                // Validar longitud de documento solo en modo ONLINE si se ingresó uno nuevo
                if (!widget.isOfflineMode && !hasUserDocument && _evaluatorDocumentController.text.trim().length < 6) {
                  CustomSnackbar.showError(
                    context,
                    loc.translate('invalid_document'),
                  );
                  return;
                }

                // Validar nombre de granja (mínimo 3 caracteres)
                if (_farmNameController.text.trim().length < 3) {
                  CustomSnackbar.showError(
                    context,
                    loc.translate('min_length', ['3']),
                  );
                  return;
                }

                // Validar ubicación (mínimo 3 caracteres)
                if (_farmLocationController.text.trim().length < 3) {
                  CustomSnackbar.showError(
                    context,
                    loc.translate('min_length', ['3']),
                  );
                  return;
                }

                // Validar nombre evaluador (debe tener al menos 2 palabras)
                final evaluatorName = _evaluatorNameController.text.trim();
                if (evaluatorName.split(' ').where((word) => word.isNotEmpty).length < 2) {
                  CustomSnackbar.showError(
                    context,
                    loc.translate('name_format'),
                  );
                  return;
                }

                // En modo offline, usar el nombre del evaluador como identificador temporal
                // En modo online, usar documento del usuario si está disponible, sino el ingresado
                final documentToUse = widget.isOfflineMode
                    ? evaluatorName.hashCode.abs().toString() // ID temporal basado en el nombre
                    : (hasUserDocument
                        ? _currentUser!.document!
                        : _evaluatorDocumentController.text.trim());

                setState(() {
                  _evaluation = _evaluation.copyWith(
                    farmName: _farmNameController.text.trim(),
                    farmLocation: _farmLocationController.text.trim(),
                    evaluatorName: _evaluatorNameController.text.trim(),
                    evaluatorDocument: documentToUse,
                    language: widget.currentLanguage,
                  );
                  _hasUnsavedChanges = true;
                });

                Navigator.pop(context);
              },
              child: Text(loc.translate('continue')),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'medical_services':
        return Icons.medical_services;
      case 'psychology':
        return Icons.psychology;
      case 'home_work':
        return Icons.home_work;
      case 'agriculture':
        return Icons.agriculture;
      default:
        return Icons.help_outline;
    }
  }

  void _updateResponse(String categoryId, String fieldId, dynamic value) {
    setState(() {
      _evaluation.responses['${categoryId}_$fieldId'] = value;
      _evaluation = _evaluation.copyWith(
        updatedAt: DateTime.now(),
      );
      _hasUnsavedChanges = true;
    });
  }

  bool _validateCurrentCategory() {
    final loc = AppLocalizations.of(context);
    final currentCategory = widget.species.categories[_currentCategoryIndex];
    
    for (var field in currentCategory.fields) {
      if (field.required) {
        final key = '${currentCategory.id}_${field.id}';
        final value = _evaluation.responses[key];
        
        if (value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.translate('complete_required_fields')),
              backgroundColor: BianTheme.warningYellow,
            ),
          );
          return false;
        }
      }
    }
    
    return true;
  }

  Future<void> _saveDraft() async {
    final loc = AppLocalizations.of(context);
    
    if (widget.draftToEdit == null) {
      final canAdd = await DraftsStorage.canAddNewDraft();
      if (!canAdd) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Límite de borradores'),
            content: Text('Ya tienes 2 borradores guardados. Se eliminará el más antiguo para guardar este.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(loc.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(loc.translate('accept')),
              ),
            ],
          ),
        );
        if (confirm != true) return;
      }
    }
    
    final success = await DraftsStorage.saveDraft(_evaluation);
    
    if (!mounted) return;
    
    if (success) {
      setState(() => _hasUnsavedChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.save, color: Colors.white),
              SizedBox(width: 12),
              Text(loc.translate('draft_saved')),
            ],
          ),
          backgroundColor: BianTheme.successGreen,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar borrador'),
          backgroundColor: BianTheme.errorRed,
        ),
      );
    }
  }

  Map<String, dynamic> _calculateResults() {
    int totalQuestions = 0;
    int positiveResponses = 0;
    final categoryScores = <String, double>{};
    final criticalPoints = <String>[];
    final strongPoints = <String>[];

    for (var category in widget.species.categories) {
      int categoryTotal = 0;
      int categoryPositive = 0;

      for (var field in category.fields) {
        if (field.type == FieldType.yesNo) {
          final key = '${category.id}_${field.id}';
          final value = _evaluation.responses[key];
          
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
    
    if (overallScore < 60) {
      recommendationKeys.add('immediate_attention_required');
    }
    
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

    if (recommendationKeys.isEmpty) {
      recommendationKeys.add('maintain_current_practices');
    }

    return {
      'overall_score': overallScore,
      'overall_score_formatted': overallScore.toStringAsFixed(1),
      'compliance_level': complianceLevel,
      'category_scores': categoryScores,
      'critical_points': criticalPoints.take(10).toList(),
      'strong_points': strongPoints,
      'recommendations': recommendationKeys,
    };
  }

  List<String> _translateRecommendations(List recommendationKeys) {
    final translations = <String, String>{
      'immediate_attention_required': widget.currentLanguage == 'es' 
          ? 'Se requiere atención inmediata para mejorar las condiciones de bienestar animal'
          : 'Immediate attention required to improve animal welfare conditions',
      'improve_feeding_practices': widget.currentLanguage == 'es'
          ? 'Mejorar las prácticas de alimentación y asegurar acceso constante a agua y alimento de calidad'
          : 'Improve feeding practices and ensure constant access to quality water and food',
      'strengthen_health_program': widget.currentLanguage == 'es'
          ? 'Fortalecer el programa de salud animal, incluyendo vacunación y control de enfermedades'
          : 'Strengthen animal health program, including vaccination and disease control',
      'improve_infrastructure': widget.currentLanguage == 'es'
          ? 'Mejorar las instalaciones para proporcionar espacios adecuados, ventilación y condiciones ambientales óptimas'
          : 'Improve facilities to provide adequate space, ventilation and optimal environmental conditions',
      'train_staff_welfare': widget.currentLanguage == 'es'
          ? 'Capacitar al personal en bienestar animal y mantener registros actualizados'
          : 'Train staff in animal welfare and maintain updated records',
      'maintain_current_practices': widget.currentLanguage == 'es'
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

  Future<void> _completeEvaluation() async {
    final loc = AppLocalizations.of(context);
    
    if (!_evaluation.isComplete(widget.species)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate('complete_required_fields')),
          backgroundColor: BianTheme.warningYellow,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(loc.translate('finish_evaluation')),
        content: Text(loc.translate('finish_evaluation_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('finish')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final results = _calculateResults();
      final translatedRecommendations = _translateRecommendations(results['recommendations']);
      
      final structuredJson = await _evaluation.generateStructuredJSON(
        widget.species,
        results,
        translatedRecommendations,
        isOfflineMode: widget.isOfflineMode,
      );

      _logEvaluationResults(structuredJson);

      final completedEvaluation = _evaluation.copyWith(
        status: 'completed',
        overallScore: results['overall_score'],
        categoryScores: Map<String, double>.from(results['category_scores']),
        updatedAt: DateTime.now(),
      );

      // Eliminar borrador
      await DraftsStorage.deleteDraft(_evaluation.id);

      if (widget.isOfflineMode) {
        // Modo offline: guardar como pendiente de sincronización
        print('🔍 DEBUG: Guardando evaluación en modo offline...');
        print('🔍 DEBUG: Evaluation ID: ${completedEvaluation.id}');
        print('🔍 DEBUG: Farm Name: ${completedEvaluation.farmName}');

        final saveResult = await LocalReportsStorage.saveLocalReport(completedEvaluation);
        print('📴 Modo offline: Evaluación guardada como pendiente - Result: $saveResult');

        // Verificar que se guardó correctamente
        final allReports = await LocalReportsStorage.getAllLocalReports();
        print('🔍 DEBUG: Total reportes locales después de guardar: ${allReports.length}');
        final justSaved = await LocalReportsStorage.getLocalReportById(completedEvaluation.id);
        print('🔍 DEBUG: Reporte recién guardado encontrado: ${justSaved != null}');
      } else {
        // Modo online: intentar sincronizar INMEDIATAMENTE
        print('🌐 Modo online: Sincronizando evaluación al servidor...');
        final syncSuccess = await _syncEvaluationToServer(completedEvaluation, structuredJson);

        if (syncSuccess) {
          print('✅ Evaluación sincronizada exitosamente con el servidor');
          // Guardar también localmente para acceso offline
          await ReportsStorage.saveReport(completedEvaluation);

          // Mostrar feedback de éxito
          if (mounted) {
            CustomSnackbar.showSuccess(
              context,
              AppLocalizations.of(context).translate('evaluation_synced_successfully'),
            );
          }
        } else {
          print('⚠️ Error al sincronizar, guardando como pendiente');
          // Si falla, guardar como pendiente para reintento posterior
          await LocalReportsStorage.saveLocalReport(completedEvaluation);

          // Mostrar feedback de que se guardó localmente
          if (mounted) {
            CustomSnackbar.show(
              context,
              AppLocalizations.of(context).translate('saved_locally_will_sync_later'),
              isWarning: true,
              duration: const Duration(seconds: 4),
            );
          }
        }
      }

      setState(() => _hasUnsavedChanges = false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              evaluation: completedEvaluation,
              species: widget.species,
              results: results,
              structuredJson: structuredJson,
            ),
          ),
        );
      }
    }
  }

  /// Sincroniza la evaluación con el backend Java automáticamente
  Future<bool> _syncEvaluationToServer(
    Evaluation evaluation,
    Map<String, dynamic> structuredJson,
  ) async {
    try {
      final user = await _storage.getUser();
      if (user == null) {
        print('❌ No hay usuario para sincronizar');
        return false;
      }

      // Asegurar que se pase un int no nulo al backend; usar 0 como fallback si user.id es null
      final userId = user.id ?? 0;
      if (userId == 0) {
        print('⚠️ Usuario cargado pero sin ID, usando 0 como fallback.');
      }

      // Preparar datos en formato del backend
      final evaluationData = await _prepareEvaluationData(evaluation, structuredJson, userId);

      print('📤 Enviando evaluación al backend Java...');
      final apiService = ApiService();
      final result = await apiService.createEvaluationReport(evaluationData);

      if (result['success'] == true) {
        print('✅ Sincronización exitosa con backend Java');
        return true;
      } else {
        print('❌ Error del servidor: ${result['message'] ?? 'Error desconocido'}');
        return false;
      }
    } catch (e, stackTrace) {
      print('❌ Excepción sincronizando: $e');
      print('📚 StackTrace: $stackTrace');
      return false;
    }
  }

  /// Prepara los datos para el backend Java
  Future<Map<String, dynamic>> _prepareEvaluationData(
    Evaluation evaluation,
    Map<String, dynamic> structuredJson,
    int userId,
  ) async {
    // El structuredJson ya contiene todo lo necesario, solo actualizamos user_id
    structuredJson['user_id'] = userId.toString();

    print('📤 Datos preparados para envío: $structuredJson');
    return structuredJson;
  }

  void printJson(dynamic data, {String indent = ''}) {
    if (data is Map) {
      data.forEach((key, value) {
        print('$indent$key:');
        printJson(value, indent: '$indent  ');
      });
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        print('$indent[$i]:');
        printJson(data[i], indent: '$indent  ');
      }
    } else {
      print('$indent$data');
    }
  }

  void _logEvaluationResults(Map<String, dynamic> json) {
    print('\n');
    printJson(json);
    print('\n');
    print('╔═══════════════════════════════════════════════════════════════╗');
    print('║              EVALUACIÓN COMPLETADA - BIAN                     ║');
    print('╚═══════════════════════════════════════════════════════════════╝');
    print('');
    print('📋 INFORMACIÓN GENERAL:');
    print('   Fecha: ${json['evaluation_date']}');
    print('   Idioma: ${json['language']}');
    print('   Especie: ${json['species']}');
    print('   Granja: ${json['farm_name']}');
    print('   Ubicación: ${json['farm_location']}');
    print('   Evaluador: ${json['evaluator_name']}');
    print('');
    print('🎯 RESULTADOS:');
    print('   Puntuación General: ${json['overall_score']}%');
    print('   Nivel de Cumplimiento: ${json['compliance_level']}');
    print('');
    print('📊 PUNTUACIONES POR CATEGORÍA:');
    
    final categories = Map<String, dynamic>.from(json['categories']);
    categories.forEach((categoryId, categoryData) {
      final data = categoryData as Map<String, dynamic>;
      final score = data['score'];
      print('   ├─ ${categoryId.toUpperCase()}: ${score ?? 'N/A'}%');
      
      data.forEach((key, value) {
        if (key != 'score') {
          print('   │  └─ $key: $value');
        }
      });
    });
    
    print('');
    print('⚠️  PUNTOS CRÍTICOS:');
    final criticalPoints = json['critical_points'] as List;
    if (criticalPoints.isEmpty) {
      print('   ✓ Ninguno');
    } else {
      for (var point in criticalPoints) {
        print('   • $point');
      }
    }
    
    print('');
    print('✨ PUNTOS FUERTES:');
    final strongPoints = json['strong_points'] as List;
    if (strongPoints.isEmpty) {
      print('   - Ninguno destacable');
    } else {
      for (var point in strongPoints) {
        print('   • $point');
      }
    }
    
    print('');
    print('💡 RECOMENDACIONES:');
    final recommendations = json['recommendations'] as List;
    for (int i = 0; i < recommendations.length; i++) {
      print('   ${i + 1}. ${recommendations[i]}');
    }
    
    print('');
    print('═══════════════════════════════════════════════════════════════');
    print('');
  }

  @override
Widget build(BuildContext context) {
  final loc = AppLocalizations.of(context);
  final currentCategory = widget.species.categories[_currentCategoryIndex];
  final progress = _evaluation.getProgress(widget.species);

  return WillPopScope(
    onWillPop: () async {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        FocusScope.of(context).unfocus();
        return false;
      }

      if (_hasUnsavedChanges) {
        final confirm = await showDialog<String>(
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
                    color: BianTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: BianTheme.errorRed,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loc.translate('exit_question'),
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
                  loc.translate('lose_progress_warning'),
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BianTheme.infoBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: BianTheme.infoBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: BianTheme.infoBlue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.isOfflineMode
                              ? loc.translate('cannot_save_drafts_offline')
                              : 'Puedes guardar un borrador para continuar después',
                          style: TextStyle(fontSize: 12, color: BianTheme.darkGray),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: Text(loc.translate('cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'discard'),
                style: TextButton.styleFrom(
                  foregroundColor: BianTheme.errorRed,
                ),
                child: Text(loc.translate('exit_and_lose_progress')),
              ),
              if (!widget.isOfflineMode)
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, 'save'),
                  icon: Icon(Icons.save),
                  label: Text(loc.translate('save_draft')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BianTheme.successGreen,
                  ),
                ),
            ],
          ),
        );

        if (confirm == 'save') {
          await _saveDraft();
          return true;
        } else if (confirm == 'discard') {
          return true;
        }
        return false;
      }

      return true;
    },
    child: Scaffold(
        appBar: AppBar(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${loc.translate('evaluation')} ${widget.species.namePlural}',
        style: TextStyle(fontSize: 18),
      ),
      if (_evaluation.farmName.isNotEmpty)
        Text(
          _evaluation.farmName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
    ],
  ),
  actions: [
    if (_hasUnsavedChanges && !widget.isOfflineMode)
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: BianTheme.warningYellow,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    if (!widget.isOfflineMode)
      IconButton(
        icon: Icon(Icons.save_outlined),
        onPressed: _saveDraft,
        tooltip: loc.translate('save_draft'),
      ),
    IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: _showWelcomeDialog,
      tooltip: loc.translate('information'),
    ),
  ],
),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: BianTheme.lightGray,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(int.parse(widget.species.gradientColors[0])),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse(widget.species.gradientColors[0])),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${loc.translate('category')} ${_currentCategoryIndex + 1} ${loc.translate('of')} ${widget.species.categories.length}',
                        style: TextStyle(
                          fontSize: 12,
                          color: BianTheme.mediumGray,
                        ),
                      ),
                      if (widget.draftToEdit != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: BianTheme.infoBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_note, size: 14, color: BianTheme.infoBlue),
                              SizedBox(width: 4),
                              Text(
                                'Borrador',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: BianTheme.infoBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(int.parse(widget.species.gradientColors[0])),
                    Color(int.parse(widget.species.gradientColors[1])),
                  ],
                ),
                boxShadow: BianTheme.elevatedShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(currentCategory.icon),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.translate(currentCategory.nameKey ?? currentCategory.id),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${currentCategory.fields.length} ${loc.translate('indicators')}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            // Mostrar peso si existe (metodología ICA)
                            if (currentCategory.weight < 1.0) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Peso: ${(currentCategory.weight * 100).toInt()}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: currentCategory.fields.length,
                itemBuilder: (context, index) {
                  final field = currentCategory.fields[index];
                  final key = '${currentCategory.id}_${field.id}';
                  final value = _evaluation.responses[key];

                  return _buildFieldWidget(
                    field,
                    key,
                    value,
                    currentCategory.id,
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentCategoryIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentCategoryIndex--;
                          });
                          _scrollController.animateTo(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                        label: Text(loc.translate('previous')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(int.parse(widget.species.gradientColors[0])),
                          side: BorderSide(
                            color: Color(int.parse(widget.species.gradientColors[0])),
                          ),
                          minimumSize: Size(0, 52),
                        ),
                      ),
                    ),
                  if (_currentCategoryIndex > 0) SizedBox(width: 12),
                  Expanded(
                    flex: _currentCategoryIndex == 0 ? 1 : 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_currentCategoryIndex < widget.species.categories.length - 1) {
                          if (_validateCurrentCategory()) {
                            setState(() {
                              _currentCategoryIndex++;
                            });
                            _scrollController.animateTo(
                              0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        } else {
                          _completeEvaluation();
                        }
                      },
                      icon: Icon(
                        _currentCategoryIndex < widget.species.categories.length - 1
                            ? Icons.arrow_forward
                            : Icons.check_circle,
                      ),
                      label: Text(
                        _currentCategoryIndex < widget.species.categories.length - 1
                            ? loc.translate('next')
                            : loc.translate('finish'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(int.parse(widget.species.gradientColors[0])),
                        minimumSize: Size(0, 52),
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

  Widget _buildFieldWidget(
    EvaluationField field,
    String key,
    dynamic value,
    String categoryId,
  ) {
    final loc = AppLocalizations.of(context);
    final bool isICAScale = field.type == FieldType.scale0to2;
    
    // Obtener la pregunta del indicador
    String questionText = '';
    if (field.question != null) {
      questionText = loc.translate(field.question!);
      // Si no hay traducción, usar el ID como fallback
      if (questionText == field.question) {
        questionText = loc.translate(field.id);
      }
    } else {
      questionText = loc.translate(field.id);
    }
    
    // Obtener descripción del indicador (solo para ICA)
    String? descriptionText;
    if (isICAScale && field.description != null) {
      descriptionText = loc.translate(field.description!);
      if (descriptionText == field.description) {
        descriptionText = null; // No mostrar si no hay traducción
      }
    }
    
    // Obtener método de evaluación
    String? methodText;
    if (isICAScale && field.evaluationMethod != null) {
      switch (field.evaluationMethod!) {
        case EvaluationMethod.visualInspectionWithSampling:
          methodText = loc.translate('method_visual_sampling');
          if (methodText == 'method_visual_sampling') {
            methodText = 'Inspección visual con muestreo';
          }
          break;
        case EvaluationMethod.visualInspectionNoSampling:
          methodText = loc.translate('method_visual_no_sampling');
          if (methodText == 'method_visual_no_sampling') {
            methodText = 'Inspección visual sin muestreo';
          }
          break;
        case EvaluationMethod.documentInspection:
          methodText = loc.translate('method_document');
          if (methodText == 'method_document') {
            methodText = 'Inspección documental';
          }
          break;
        case EvaluationMethod.visualAndDocumental:
          methodText = loc.translate('method_visual_document');
          if (methodText == 'method_visual_document') {
            methodText = 'Inspección visual y documental';
          }
          break;
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value != null
              ? Color(int.parse(widget.species.gradientColors[0])).withOpacity(0.3)
              : BianTheme.lightGray,
          width: value != null ? 2 : 1,
        ),
        boxShadow: value != null
            ? [
                BoxShadow(
                  color: Color(int.parse(widget.species.gradientColors[0])).withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : BianTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con label y badge de requerido
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label del indicador
                    Text(
                      loc.translate(field.label),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: BianTheme.darkGray,
                      ),
                    ),
                    // Método de evaluación (solo ICA)
                    if (methodText != null) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 14,
                            color: BianTheme.mediumGray,
                          ),
                          SizedBox(width: 4),
                          Text(
                            methodText,
                            style: TextStyle(
                              fontSize: 11,
                              color: BianTheme.mediumGray,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Badges
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge de puntaje máximo (solo ICA)
                  if (isICAScale) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(int.parse(widget.species.gradientColors[0])).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Max: ${field.maxScore}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(int.parse(widget.species.gradientColors[0])),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  if (field.required)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: BianTheme.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        loc.translate('required'),
                        style: TextStyle(
                          fontSize: 10,
                          color: BianTheme.errorRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          // Descripción del indicador (solo si existe y es ICA)
          if (descriptionText != null) ...[
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BianTheme.backgroundGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: BianTheme.mediumGray,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      descriptionText,
                      style: TextStyle(
                        fontSize: 12,
                        color: BianTheme.darkGray.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Pregunta de evaluación
          if (questionText.isNotEmpty) ...[
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(int.parse(widget.species.gradientColors[0])).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(int.parse(widget.species.gradientColors[0])).withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 18,
                    color: Color(int.parse(widget.species.gradientColors[0])),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      questionText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: BianTheme.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: 16),
          _buildInputWidget(field, key, value, categoryId),
        ],
      ),
    );
  }

  Widget _buildInputWidget(
    EvaluationField field,
    String key,
    dynamic value,
    String categoryId,
  ) {
    final loc = AppLocalizations.of(context);
    
    switch (field.type) {
      // ═══════════════════════════════════════════════════════════════
      // ESCALA ICA 0-2 (Nueva para metodología ICA)
      // ═══════════════════════════════════════════════════════════════
      case FieldType.scale0to2:
        return _buildScale0to2Widget(field, key, value, categoryId);

      case FieldType.yesNo:
        return Row(
          children: [
            Expanded(
              child: _buildYesNoButton(
                label: loc.translate('yes'),
                icon: Icons.check_circle,
                isSelected: value == true,
                color: BianTheme.successGreen,
                onTap: () => _updateResponse(categoryId, field.id, true),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildYesNoButton(
                label: loc.translate('no'),
                icon: Icons.cancel,
                isSelected: value == false,
                color: BianTheme.errorRed,
                onTap: () => _updateResponse(categoryId, field.id, false),
              ),
            ),
          ],
        );

      case FieldType.number:
      case FieldType.percentage:
        if (!_textControllers.containsKey(key)) {
          _textControllers[key] = TextEditingController(text: value?.toString() ?? '');
        }
        
        return TextField(
          controller: _textControllers[key],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: field.type == FieldType.percentage
                ? 'Ej: 2.5'
                : loc.translate('enter_value'),
            suffixText: field.unit != null ? loc.translate(field.unit!) : null,
            suffixIcon: Icon(
              field.type == FieldType.percentage
                  ? Icons.percent
                  : Icons.numbers,
              color: BianTheme.mediumGray,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(int.parse(widget.species.gradientColors[0])),
                width: 2,
              ),
            ),
          ),
          onChanged: (text) {
            if (text.isNotEmpty) {
              final numValue = double.tryParse(text);
              _updateResponse(categoryId, field.id, numValue);
            } else {
              _updateResponse(categoryId, field.id, null);
            }
          },
        );

      case FieldType.text:
        if (!_textControllers.containsKey(key)) {
          _textControllers[key] = TextEditingController(text: value?.toString() ?? '');
        }
        
        return TextField(
          controller: _textControllers[key],
          decoration: InputDecoration(
            hintText: loc.translate('write_answer'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(int.parse(widget.species.gradientColors[0])),
                width: 2,
              ),
            ),
          ),
          maxLines: 3,
          onChanged: (text) {
            _updateResponse(categoryId, field.id, text.isNotEmpty ? text : null);
          },
        );

      case FieldType.select:
        // TODO: Implementar si se necesita
        return SizedBox();

      default:
        return SizedBox();
    }
  }

  /// Widget para escala ICA 0-2
  /// 0 = No cumple (rojo)
  /// 1 = Cumple parcialmente (amarillo)
  /// 2 = Cumple totalmente (verde)
  Widget _buildScale0to2Widget(
    EvaluationField field,
    String key,
    dynamic value,
    String categoryId,
  ) {
    final loc = AppLocalizations.of(context);
    final int? currentValue = value is int ? value : (value is double ? value.toInt() : null);
    
    // Colores para cada nivel
    final colors = [
      BianTheme.errorRed,      // 0 - No cumple
      Colors.amber.shade700,   // 1 - Cumple parcialmente  
      BianTheme.successGreen,  // 2 - Cumple totalmente
    ];
    
    // Iconos para cada nivel
    final icons = [
      Icons.cancel,           // 0
      Icons.remove_circle,    // 1
      Icons.check_circle,     // 2
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botones de selección 0, 1, 2
        Row(
          children: List.generate(3, (index) {
            final isSelected = currentValue == index;
            final color = colors[index];
            
            // Obtener etiqueta traducida para cada nivel
            String label;
            switch (index) {
              case 0:
                label = loc.translate('${field.id}_0');
                // Si no hay traducción específica, usar genérica
                if (label == '${field.id}_0') {
                  label = loc.translate('scale_0');
                  if (label == 'scale_0') label = 'No cumple (0)';
                }
                break;
              case 1:
                label = loc.translate('${field.id}_1');
                if (label == '${field.id}_1') {
                  label = loc.translate('scale_1');
                  if (label == 'scale_1') label = 'Parcial (1)';
                }
                break;
              case 2:
                label = loc.translate('${field.id}_2');
                if (label == '${field.id}_2') {
                  label = loc.translate('scale_2');
                  if (label == 'scale_2') label = 'Cumple (2)';
                }
                break;
              default:
                label = index.toString();
            }

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 4,
                  right: index == 2 ? 0 : 4,
                ),
                child: InkWell(
                  onTap: () => _updateResponse(categoryId, field.id, index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.15) : BianTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : BianTheme.lightGray,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Número grande
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected ? color : BianTheme.mediumGray.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              index.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : BianTheme.mediumGray,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Icono
                        Icon(
                          icons[index],
                          color: isSelected ? color : BianTheme.mediumGray,
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        // Label corto
                        Text(
                          _getShortScaleLabel(index, loc),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? color : BianTheme.mediumGray,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        
        // Mostrar descripción del nivel seleccionado
        if (currentValue != null) ...[
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors[currentValue].withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors[currentValue].withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icons[currentValue],
                  color: colors[currentValue],
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getScaleDescription(field.id, currentValue, loc),
                    style: TextStyle(
                      fontSize: 12,
                      color: BianTheme.darkGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Obtiene etiqueta corta para la escala
  String _getShortScaleLabel(int value, AppLocalizations loc) {
    switch (value) {
      case 0:
        return 'No cumple';
      case 1:
        return 'Parcial';
      case 2:
        return 'Cumple';
      default:
        return value.toString();
    }
  }

  /// Obtiene la descripción del nivel seleccionado
  String _getScaleDescription(String fieldId, int value, AppLocalizations loc) {
    // Intentar obtener traducción específica del indicador
    final specificKey = '${fieldId}_$value';
    final specificTranslation = loc.translate(specificKey);
    
    if (specificTranslation != specificKey) {
      return specificTranslation;
    }
    
    // Usar descripciones genéricas
    switch (value) {
      case 0:
        return loc.translate('scale_0_desc') != 'scale_0_desc' 
            ? loc.translate('scale_0_desc')
            : 'No cumple con el criterio evaluado. Requiere intervención inmediata.';
      case 1:
        return loc.translate('scale_1_desc') != 'scale_1_desc'
            ? loc.translate('scale_1_desc')
            : 'Cumple parcialmente con el criterio. Se recomienda mejorar.';
      case 2:
        return loc.translate('scale_2_desc') != 'scale_2_desc'
            ? loc.translate('scale_2_desc')
            : 'Cumple totalmente con el criterio evaluado.';
      default:
        return '';
    }
  }

  Widget _buildYesNoButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : BianTheme.backgroundGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : BianTheme.lightGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : BianTheme.mediumGray,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : BianTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}