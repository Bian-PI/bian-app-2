import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/models/species_model.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import 'package:uuid/uuid.dart';

class EvaluationScreen extends StatefulWidget {
  final Species species;

  const EvaluationScreen({
    super.key,
    required this.species,
  });

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final _uuid = const Uuid();
  
  int _currentCategoryIndex = 0;
  late Evaluation _evaluation;
  
  final _farmNameController = TextEditingController();
  final _farmLocationController = TextEditingController();
  final _evaluatorNameController = TextEditingController();
  
  final Map<String, TextEditingController> _textControllers = {};
  
  bool _showInfoDialog = true;

  @override
  void initState() {
    super.initState();
    _initializeEvaluation();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showInfoDialog) {
        _showWelcomeDialog();
      }
    });
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _evaluatorNameController.dispose();
    _textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeEvaluation() {
    _evaluation = Evaluation(
      id: _uuid.v4(),
      speciesId: widget.species.id,
      farmName: '',
      farmLocation: '',
      evaluationDate: DateTime.now(),
      evaluatorName: '',
      responses: {},
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
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
                );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 12),
            Text(AppLocalizations.of(context).translate('draft_saved')),
          ],
        ),
        backgroundColor: BianTheme.successGreen,
      ),
    );
  }

  Map<String, dynamic> _generateEvaluationJSON() {
    final loc = AppLocalizations.of(context);
    
    final jsonData = <String, dynamic>{
      'id': _evaluation.id,
      'fecha_evaluacion': _evaluation.evaluationDate.toIso8601String(),
      'especie': widget.species.namePlural,
      'granja': {
        'nombre': _evaluation.farmName,
        'ubicacion': _evaluation.farmLocation,
      },
      'evaluador': _evaluation.evaluatorName,
      'categorias': {},
    };

    for (var category in widget.species.categories) {
      final categoryData = <String, dynamic>{};
      
      for (var field in category.fields) {
        final key = '${category.id}_${field.id}';
        final value = _evaluation.responses[key];
        
        String processedValue;
        if (value == null) {
          processedValue = 'No respondido';
        } else if (value is bool) {
          processedValue = value ? loc.translate('yes') : loc.translate('no');
        } else if (value is num) {
          if (field.type == FieldType.percentage || 
              (field.unit != null && !field.unit!.contains('cm') && !field.unit!.contains('m'))) {
            processedValue = value.toString();
          } else {
            processedValue = value.toInt().toString();
          }
          if (field.unit != null) {
            processedValue += ' ${field.unit}';
          }
        } else {
          processedValue = value.toString();
        }
        
        categoryData[field.id] = processedValue;
      }
      
      jsonData['categorias'][category.id] = categoryData;
    }

    return jsonData;
  }

  Map<String, dynamic> _calculateResults() {
    final loc = AppLocalizations.of(context);
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
              criticalPoints.add(loc.translate(field.id));
            }
          }
        }
      }

      if (categoryTotal > 0) {
        final score = (categoryPositive / categoryTotal) * 100;
        categoryScores[category.id] = score;
        
        if (score >= 80) {
          strongPoints.add(loc.translate(category.id));
        }
      }
    }

    final overallScore = totalQuestions > 0 ? (positiveResponses / totalQuestions) * 100 : 0;

    String complianceLevel;
    if (overallScore >= 90) {
      complianceLevel = loc.translate('excellent');
    } else if (overallScore >= 75) {
      complianceLevel = loc.translate('good');
    } else if (overallScore >= 60) {
      complianceLevel = loc.translate('acceptable');
    } else if (overallScore >= 40) {
      complianceLevel = loc.translate('needs_improvement');
    } else {
      complianceLevel = loc.translate('critical');
    }

    final recommendations = <String>[];
    
    if (overallScore < 60) {
      recommendations.add('Se requiere atención inmediata en los puntos críticos identificados.');
    }
    
    if (categoryScores['feeding'] != null && categoryScores['feeding']! < 70) {
      recommendations.add('Mejorar las prácticas de alimentación y acceso al agua.');
    }
    
    if (categoryScores['health'] != null && categoryScores['health']! < 70) {
      recommendations.add('Fortalecer el programa sanitario y de vacunación.');
    }
    
    if (categoryScores['infrastructure'] != null && categoryScores['infrastructure']! < 70) {
      recommendations.add('Realizar mejoras en la infraestructura del galpón/corral.');
    }
    
    if (categoryScores['management'] != null && categoryScores['management']! < 70) {
      recommendations.add('Capacitar al personal en manejo y bienestar animal.');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Mantener las buenas prácticas actuales y realizar monitoreo continuo.');
    }

    return {
      'puntuacion_general': overallScore.toStringAsFixed(1),
      'nivel_cumplimiento': complianceLevel,
      'puntuaciones_por_categoria': categoryScores.map((key, value) => MapEntry(key, value.toStringAsFixed(1))),
      'puntos_criticos': criticalPoints.take(5).toList(),
      'puntos_fuertes': strongPoints,
      'recomendaciones': recommendations,
    };
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
      final evaluationJSON = _generateEvaluationJSON();
      final results = _calculateResults();
      
      evaluationJSON['resultados'] = results;

      print('═══════════════════════════════════════════════════════════');
      print('REPORTE COMPLETO DE EVALUACIÓN - BIAN');
      print('═══════════════════════════════════════════════════════════');
      print(JsonEncoder.withIndent('  ').convert(evaluationJSON));
      print('═══════════════════════════════════════════════════════════');

      setState(() {
        _evaluation = _evaluation.copyWith(
          status: 'completed',
          overallScore: double.parse(results['puntuacion_general']),
          updatedAt: DateTime.now(),
        );
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(loc.translate('evaluation_completed')),
              ],
            ),
            backgroundColor: BianTheme.successGreen,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(Duration(milliseconds: 800));
        
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentCategory = widget.species.categories[_currentCategoryIndex];
    final progress = _evaluation.getProgress(widget.species);

    return WillPopScope(
      onWillPop: () async {
        if (_evaluation.responses.isNotEmpty) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(loc.translate('exit_without_saving')),
              content: Text(loc.translate('data_will_be_lost')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(loc.translate('cancel')),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: BianTheme.errorRed,
                  ),
                  child: Text(loc.translate('exit')),
                ),
              ],
            ),
          );
          return confirm ?? false;
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
                  Text(
                    '${loc.translate('category')} ${_currentCategoryIndex + 1} ${loc.translate('of')} ${widget.species.categories.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: BianTheme.mediumGray,
                    ),
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