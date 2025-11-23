// lib/features/evaluation/ai_analysis_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/gemini_service.dart';
import '../../core/utils/connectivity_service.dart';

class AIAnalysisScreen extends StatefulWidget {
  final String speciesType;
  final double overallScore;
  final Map<String, double> categoryScores;
  final List criticalPoints;
  final List strongPoints;
  final String language;

  const AIAnalysisScreen({
    super.key,
    required this.speciesType,
    required this.overallScore,
    required this.categoryScores,
    required this.criticalPoints,
    required this.strongPoints,
    required this.language,
  });

  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = false;
  String? _analysis;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateAnalysis();
  }

  Future<void> _generateAnalysis() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verificar conexión
      final connectivityService =
          Provider.of<ConnectivityService>(context, listen: false);
      final hasConnection = await connectivityService.checkConnection();

      if (!hasConnection) {
        throw Exception('No hay conexión a internet');
      }

      // Verificar disponibilidad de Gemini
      if (!_geminiService.isAvailable) {
        throw Exception('El servicio de IA no está disponible');
      }

      // Generar análisis
      final analysis = await _geminiService.analyzeAnimalWelfareReport(
        speciesType: widget.speciesType,
        overallScore: widget.overallScore,
        categoryScores: widget.categoryScores,
        criticalPoints: widget.criticalPoints.map((e) => e.toString()).toList(),
        strongPoints: widget.strongPoints.map((e) => e.toString()).toList(),
        language: widget.language,
      );

      if (mounted) {
        setState(() {
          _analysis = analysis;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error generando análisis con IA: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.psychology, color: Colors.white),
            const SizedBox(width: 8),
            Text(widget.language == 'es'
                ? 'Análisis Extendido con IA'
                : 'AI Extended Analysis'),
          ],
        ),
        backgroundColor: BianTheme.primaryRed,
        elevation: 0,
      ),
      body: _buildBody(loc),
    );
  }

  Widget _buildBody(AppLocalizations loc) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(BianTheme.primaryRed),
            ),
            const SizedBox(height: 24),
            Text(
              widget.language == 'es'
                  ? 'Generando análisis inteligente...'
                  : 'Generating intelligent analysis...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BianTheme.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.language == 'es'
                  ? 'Esto puede tomar unos segundos'
                  : 'This may take a few seconds',
              style: TextStyle(
                fontSize: 14,
                color: BianTheme.mediumGray,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_analysis != null) {
      return _buildAnalysisView();
    }

    return Center(child: Text('Sin datos'));
  }

  Widget _buildErrorView() {
    // Detectar tipo de error
    final isApiKeyError = _errorMessage!.contains('API key') ||
                          _errorMessage!.contains('not valid');
    final isConnectionError = _errorMessage!.contains('conexión') ||
                              _errorMessage!.contains('connection');

    String title;
    String message;
    IconData icon;
    Color iconColor;

    if (isApiKeyError) {
      icon = Icons.vpn_key_off;
      iconColor = BianTheme.warningYellow;
      title = widget.language == 'es'
          ? 'API Key no configurada'
          : 'API Key not configured';
      message = widget.language == 'es'
          ? 'Necesitas configurar tu API key GRATUITA de Google Gemini.\n\nVe a GEMINI_SETUP.md en el proyecto para obtener tu key gratis (2 minutos).'
          : 'You need to configure your FREE Google Gemini API key.\n\nCheck GEMINI_SETUP.md in the project to get your free key (2 minutes).';
    } else if (isConnectionError) {
      icon = Icons.wifi_off;
      iconColor = BianTheme.errorRed;
      title = widget.language == 'es'
          ? 'Sin conexión a internet'
          : 'No internet connection';
      message = widget.language == 'es'
          ? 'Necesitas conexión a internet para usar el análisis con IA'
          : 'You need internet connection to use AI analysis';
    } else {
      icon = Icons.error_outline;
      iconColor = BianTheme.errorRed;
      title = widget.language == 'es'
          ? 'Error al generar análisis'
          : 'Error generating analysis';
      message = widget.language == 'es'
          ? 'El servicio de IA no está disponible en este momento'
          : 'The AI service is not available at this time';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: BianTheme.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: BianTheme.mediumGray,
                height: 1.5,
              ),
            ),
            if (isApiKeyError) ...[
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BianTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: BianTheme.infoBlue.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                             color: BianTheme.infoBlue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          widget.language == 'es' ? 'Pasos:' : 'Steps:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: BianTheme.infoBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.language == 'es'
                          ? '1. Ve a makersuite.google.com\n2. Crea tu API key gratis\n3. Configúrala en gemini_service.dart'
                          : '1. Go to makersuite.google.com\n2. Create your free API key\n3. Configure it in gemini_service.dart',
                      style: TextStyle(
                        fontSize: 12,
                        color: BianTheme.darkGray,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            if (!isApiKeyError)
              ElevatedButton.icon(
                onPressed: () => _generateAnalysis(),
                icon: Icon(Icons.refresh),
                label: Text(widget.language == 'es' ? 'Reintentar' : 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BianTheme.primaryRed,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.language == 'es' ? 'Volver' : 'Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header informativo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  BianTheme.infoBlue,
                  BianTheme.infoBlue.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
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
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.language == 'es'
                            ? 'Análisis Generado con IA'
                            : 'AI-Generated Analysis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.language == 'es'
                            ? 'Recomendaciones personalizadas para tu granja'
                            : 'Personalized recommendations for your farm',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Contenido del análisis
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: BianTheme.lightGray.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _analysis!,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: BianTheme.darkGray,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BianTheme.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: BianTheme.successGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: BianTheme.successGreen, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.language == 'es'
                        ? 'Este análisis es una guía. Consulta con un veterinario para decisiones importantes.'
                        : 'This analysis is a guide. Consult with a veterinarian for important decisions.',
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
    );
  }
}
