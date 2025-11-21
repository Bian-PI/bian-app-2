// lib/features/evaluation/evaluation_screen.dart - SOLO AGREGAR ScrollController
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
  
  int _currentCategoryIndex = 0;
  late Evaluation _evaluation;
  
  final _farmNameController = TextEditingController();
  final _farmLocationController = TextEditingController();
  final _evaluatorNameController = TextEditingController();
  
  final Map<String, TextEditingController> _textControllers = {};
  
  bool _showInfoDialog = true;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeEvaluation();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.draftToEdit == null && _showInfoDialog) {
        _showWelcomeDialog();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _evaluatorNameController.dispose();
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

  void _showFarmInfoDialog() {
    final loc = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(loc.translate('farm_information')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              if (_farmNameController.text.isEmpty ||
                  _farmLocationController.text.isEmpty ||
                  _evaluatorNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.translate('complete_all_fields')),
                    backgroundColor: BianTheme.errorRed,
                  ),
                );
                return;
              }
              
              setState(() {
                _evaluation = _evaluation.copyWith(
                  farmName: _farmNameController.text,
                  farmLocation: _farmLocationController.text,
                  evaluatorName: _evaluatorNameController.text,
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
      );

      _logEvaluationResults(structuredJson);

      final completedEvaluation = _evaluation.copyWith(
        status: 'completed',
        overallScore: results['overall_score'],
        categoryScores: Map<String, double>.from(results['category_scores']),
        updatedAt: DateTime.now(),
      );
      
      if (widget.isOfflineMode) {
        await LocalReportsStorage.saveLocalReport(completedEvaluation);
      } else {
        await ReportsStorage.saveReport(completedEvaluation);
        await DraftsStorage.deleteDraft(_evaluation.id);
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
    print('   ID: ${json['evaluation_id']}');
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
    
    if (_hasUnsavedChanges && !widget.isOfflineMode) {
      final confirm = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(loc.translate('exit_without_saving')),
          content: Text(loc.translate('data_will_be_lost')),
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
              child: Text(loc.translate('exit')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'save'),
              child: Text(loc.translate('save_draft')),
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
                          loc.translate(currentCategory.id),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${currentCategory.fields.length} ${loc.translate('indicators')}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  loc.translate(field.id),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: BianTheme.darkGray,
                  ),
                ),
              ),
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
          SizedBox(height: 12),
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

      default:
        return SizedBox();
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