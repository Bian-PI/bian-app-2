// lib/core/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // API KEY GRATUITA - Tier gratuito de Google Gemini
  // NOTA: En producción, esta key debería estar en variables de entorno
  static const String _apiKey = 'AIzaSyBJKxKxKxKxKxKxKxKxKxKxKxKxKxK'; // ⚠️ PLACEHOLDER - Reemplazar con key real

  late final GenerativeModel _model;
  bool _isInitialized = false;

  GeminiService() {
    _initializeModel();
  }

  void _initializeModel() {
    try {
      _model = GenerativeModel(
        model: 'gemini-2.5-flash', // Modelo 2.5 Flash (gratuito, rápido, 1M tokens)
        apiKey: _apiKey,
      );
      _isInitialized = true;
    } catch (e) {
      print('❌ Error inicializando Gemini: $e');
      _isInitialized = false;
    }
  }

  bool get isAvailable => _isInitialized;

  /// Genera análisis extendido de un reporte de bienestar animal
  Future<String> analyzeAnimalWelfareReport({
    required String speciesType,
    required double overallScore,
    required Map<String, double> categoryScores,
    required List<String> criticalPoints,
    required List<String> strongPoints,
    required String language,
  }) async {
    if (!_isInitialized) {
      throw Exception('Gemini AI no está disponible');
    }

    try {
      final prompt = _buildAnalysisPrompt(
        speciesType: speciesType,
        overallScore: overallScore,
        categoryScores: categoryScores,
        criticalPoints: criticalPoints,
        strongPoints: strongPoints,
        language: language,
      );

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Respuesta vacía de Gemini');
      }

      return response.text!;
    } catch (e) {
      print('❌ Error generando análisis: $e');
      rethrow;
    }
  }

  /// Construye el prompt para el análisis
  String _buildAnalysisPrompt({
    required String speciesType,
    required double overallScore,
    required Map<String, double> categoryScores,
    required List<String> criticalPoints,
    required List<String> strongPoints,
    required String language,
  }) {
    final isSpanish = language == 'es';

    final speciesName = speciesType == 'birds'
        ? (isSpanish ? 'aves de postura' : 'laying hens')
        : (isSpanish ? 'cerdos' : 'pigs');

    if (isSpanish) {
      return '''
Eres un experto veterinario especializado en bienestar animal. Analiza el siguiente reporte de evaluación de bienestar animal para $speciesName y proporciona retroalimentación detallada y accionable.

DATOS DEL REPORTE:
- Puntuación General: ${overallScore.toStringAsFixed(1)}%
- Puntuaciones por Categoría:
${categoryScores.entries.map((e) => '  • ${_translateCategory(e.key, true)}: ${e.value.toStringAsFixed(1)}%').join('\n')}

- Puntos Críticos Identificados: ${criticalPoints.length}
- Fortalezas Identificadas: ${strongPoints.length}

PROPORCIONA UN ANÁLISIS COMPLETO QUE INCLUYA:

1. **Evaluación General del Estado de Bienestar**
   - Interpreta la puntuación general en el contexto de bienestar animal
   - Indica el nivel de cumplimiento (excelente, bueno, aceptable, necesita mejora, crítico)

2. **Análisis Detallado por Categoría**
   - Analiza cada categoría evaluada
   - Identifica las áreas más críticas que requieren atención inmediata
   - Destaca las fortalezas que deben mantenerse

3. **Recomendaciones Específicas y Accionables**
   - Proporciona al menos 5 recomendaciones concretas priorizadas
   - Incluye pasos específicos para implementar mejoras
   - Sugiere cronogramas realistas cuando sea apropiado

4. **Impacto en el Bienestar Animal**
   - Explica cómo las deficiencias identificadas afectan el bienestar
   - Describe los beneficios esperados al implementar las mejoras

5. **Recursos y Mejores Prácticas**
   - Sugiere recursos, capacitaciones o herramientas útiles
   - Menciona estándares internacionales relevantes (ej: 5 libertades del bienestar animal)

Sé específico, profesional y constructivo. Usa un lenguaje claro y accesible para productores y veterinarios.
''';
    } else {
      return '''
You are an expert veterinarian specialized in animal welfare. Analyze the following animal welfare assessment report for $speciesName and provide detailed, actionable feedback.

REPORT DATA:
- Overall Score: ${overallScore.toStringAsFixed(1)}%
- Category Scores:
${categoryScores.entries.map((e) => '  • ${_translateCategory(e.key, false)}: ${e.value.toStringAsFixed(1)}%').join('\n')}

- Critical Points Identified: ${criticalPoints.length}
- Strengths Identified: ${strongPoints.length}

PROVIDE A COMPLETE ANALYSIS INCLUDING:

1. **Overall Welfare Status Assessment**
   - Interpret the overall score in the context of animal welfare
   - Indicate compliance level (excellent, good, acceptable, needs improvement, critical)

2. **Detailed Category Analysis**
   - Analyze each evaluated category
   - Identify the most critical areas requiring immediate attention
   - Highlight strengths that should be maintained

3. **Specific and Actionable Recommendations**
   - Provide at least 5 concrete prioritized recommendations
   - Include specific steps to implement improvements
   - Suggest realistic timelines when appropriate

4. **Impact on Animal Welfare**
   - Explain how identified deficiencies affect welfare
   - Describe expected benefits when implementing improvements

5. **Resources and Best Practices**
   - Suggest useful resources, training, or tools
   - Mention relevant international standards (e.g., 5 freedoms of animal welfare)

Be specific, professional, and constructive. Use clear, accessible language for producers and veterinarians.
''';
    }
  }

  /// Traduce nombres de categorías
  String _translateCategory(String categoryId, bool isSpanish) {
    final translations = {
      'feeding': isSpanish ? 'Alimentación' : 'Feeding',
      'health': isSpanish ? 'Salud' : 'Health',
      'infrastructure': isSpanish ? 'Infraestructura' : 'Infrastructure',
      'management': isSpanish ? 'Manejo' : 'Management',
    };
    return translations[categoryId] ?? categoryId;
  }

  /// Genera recomendaciones rápidas (para casos con conectividad limitada)
  Future<String> generateQuickRecommendations({
    required String speciesType,
    required double overallScore,
    required String language,
  }) async {
    if (!_isInitialized) {
      throw Exception('Gemini AI no está disponible');
    }

    try {
      final isSpanish = language == 'es';
      final speciesName = speciesType == 'birds'
          ? (isSpanish ? 'aves de postura' : 'laying hens')
          : (isSpanish ? 'cerdos' : 'pigs');

      final prompt = isSpanish
          ? '''
Genera 3 recomendaciones breves y accionables para mejorar el bienestar de $speciesName con una puntuación actual de ${overallScore.toStringAsFixed(1)}%.
Sé conciso y específico. Máximo 2 líneas por recomendación.
'''
          : '''
Generate 3 brief and actionable recommendations to improve welfare for $speciesName with a current score of ${overallScore.toStringAsFixed(1)}%.
Be concise and specific. Maximum 2 lines per recommendation.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'No se pudo generar recomendaciones';
    } catch (e) {
      print('❌ Error generando recomendaciones rápidas: $e');
      rethrow;
    }
  }
}
