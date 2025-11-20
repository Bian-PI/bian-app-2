import 'package:flutter/material.dart';
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
  
  bool _showInfoDialog = true;

  @override
  void initState() {
    super.initState();
    _initializeEvaluation();
    
    // Mostrar dialog de bienvenida
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
                'Evaluación de ${widget.species.namePlural}',
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
                'Esta evaluación está basada en la metodología del ICA (2024) y la Resolución 253 de 2020.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Se evaluarán ${widget.species.categories.length} categorías principales:',
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
                    Text(cat.name),
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
                        'Primero ingresa los datos de la granja, luego completa cada categoría.',
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
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _showInfoDialog = false);
              Navigator.pop(context);
              _showFarmInfoDialog();
            },
            child: Text('Comenzar'),
          ),
        ],
      ),
    );
  }

  void _showFarmInfoDialog() {
    AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Información de la Granja'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _farmNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Granja *',
                  hintText: 'Ej: Granja El Paraíso',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _farmLocationController,
                decoration: InputDecoration(
                  labelText: 'Ubicación *',
                  hintText: 'Ej: Ocaña, Norte de Santander',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _evaluatorNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Evaluador *',
                  hintText: 'Tu nombre',
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
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_farmNameController.text.isEmpty ||
                  _farmLocationController.text.isEmpty ||
                  _evaluatorNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor completa todos los campos'),
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
            child: Text('Continuar'),
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

  Future<void> _saveDraft() async {
    // TODO: Implementar guardado local
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 12),
            Text('Borrador guardado'),
          ],
        ),
        backgroundColor: BianTheme.successGreen,
      ),
    );
  }

  Future<void> _completeEvaluation() async {
    if (!_evaluation.isComplete(widget.species)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos obligatorios'),
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
        title: Text('Finalizar Evaluación'),
        content: Text(
          '¿Estás seguro de finalizar esta evaluación? Se generará un reporte completo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _evaluation = _evaluation.copyWith(
          status: 'completed',
          updatedAt: DateTime.now(),
        );
      });

      // TODO: Guardar evaluación completa y navegar a reporte
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('¡Evaluación completada!'),
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
    final currentCategory = widget.species.categories[_currentCategoryIndex];
    final progress = _evaluation.getProgress(widget.species);

    return WillPopScope(
      onWillPop: () async {
        if (_evaluation.responses.isNotEmpty) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('¿Salir sin guardar?'),
              content: Text('Se perderán los datos no guardados.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: BianTheme.errorRed,
                  ),
                  child: Text('Salir'),
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
                'Evaluación ${widget.species.namePlural}',
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
              tooltip: 'Guardar borrador',
            ),
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: _showWelcomeDialog,
              tooltip: 'Información',
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
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
                    'Categoría ${_currentCategoryIndex + 1} de ${widget.species.categories.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: BianTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),

            // Category Header
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
                          currentCategory.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${currentCategory.fields.length} indicadores',
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

            // Form Fields
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

            // Navigation Buttons
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
                        label: Text('Anterior'),
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
                          setState(() {
                            _currentCategoryIndex++;
                          });
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
                            ? 'Siguiente'
                            : 'Finalizar',
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
                  field.label,
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
                    'Requerido',
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
    switch (field.type) {
      case FieldType.yesNo:
        return Row(
          children: [
            Expanded(
              child: _buildYesNoButton(
                label: 'Sí',
                icon: Icons.check_circle,
                isSelected: value == true,
                color: BianTheme.successGreen,
                onTap: () => _updateResponse(categoryId, field.id, true),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildYesNoButton(
                label: 'No',
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
        return TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: field.type == FieldType.percentage
                ? 'Ej: 2.5'
                : 'Ingresa un valor',
            suffixText: field.unit,
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
            final numValue = double.tryParse(text);
            _updateResponse(categoryId, field.id, numValue);
          },
          controller: TextEditingController(
            text: value?.toString() ?? '',
          )..selection = TextSelection.fromPosition(
              TextPosition(offset: value?.toString().length ?? 0),
            ),
        );

      case FieldType.text:
        return TextField(
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta',
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
            _updateResponse(categoryId, field.id, text);
          },
          controller: TextEditingController(text: value?.toString() ?? ''),
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