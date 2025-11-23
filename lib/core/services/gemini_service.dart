import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
  );

  late final GenerativeModel _model;
  bool _isInitialized = false;

  GeminiService() {
    _initializeModel();
  }

  void _initializeModel() {
    try {
      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );
      _isInitialized = true;
    } catch (e) {
      print('❌ Error inicializando Gemini: $e');
      _isInitialized = false;
    }
  }

  bool get isAvailable => _isInitialized;

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

  String _translateCategory(String categoryId, bool isSpanish) {
    final translations = {
      'feeding': isSpanish ? 'Alimentación' : 'Feeding',
      'health': isSpanish ? 'Salud' : 'Health',
      'infrastructure': isSpanish ? 'Infraestructura' : 'Infrastructure',
      'management': isSpanish ? 'Manejo' : 'Management',
    };
    return translations[categoryId] ?? categoryId;
  }

  String _buildCriticalResponsesSummary(
    Map<String, dynamic> formResponses,
    List<String> criticalPoints,
    bool isSpanish,
  ) {
    if (criticalPoints.isEmpty || formResponses.isEmpty) return '';

    final buffer = StringBuffer();
    buffer.writeln(isSpanish
        ? '\nRESPUESTAS DEL FORMULARIO (Puntos Críticos):'
        : '\nFORM RESPONSES (Critical Points):');

    final limitedCriticalPoints = criticalPoints.take(5).toList();

    for (final point in limitedCriticalPoints) {
      final value = formResponses[point];
      if (value != null) {
        final fieldName = point.split('_').skip(1).join(' ').replaceAll('_', ' ');
        buffer.writeln('• $fieldName: $value');
      }
    }

    return buffer.toString();
  }

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

  Future<String> chatAboutReport({
    required String userQuestion,
    required String speciesType,
    required double overallScore,
    required Map<String, double> categoryScores,
    required List<String> criticalPoints,
    required List<String> strongPoints,
    required String language,
    required Map<String, dynamic> formResponses,
    required String farmName,
    required String farmLocation,
  }) async {
    if (!_isInitialized) {
      throw Exception('Gemini AI no está disponible');
    }

    try {
      final isSpanish = language == 'es';
      final speciesName = speciesType == 'birds'
          ? (isSpanish ? 'aves de postura' : 'laying hens')
          : (isSpanish ? 'cerdos' : 'pigs');

      final criticalResponsesText = _buildCriticalResponsesSummary(
        formResponses,
        criticalPoints,
        isSpanish,
      );

      final systemPrompt = isSpanish
          ? '''Eres un experto veterinario especializado en bienestar animal de $speciesName.

CONTEXTO COMPLETO DEL REPORTE - ICA (Índice de Calidad Animal):
📍 Granja: $farmName (ubicación: $farmLocation)
📊 ICA General: ${overallScore.toStringAsFixed(1)}% (este es el Índice de Calidad Animal basado en la evaluación completa)

PUNTUACIONES POR CATEGORÍA:
${categoryScores.entries.map((e) => '• ${_translateCategory(e.key, true)}: ${e.value.toStringAsFixed(0)}%').join('\n')}

DATOS DE LA EVALUACIÓN:
• Puntos críticos identificados: ${criticalPoints.length}
• Fortalezas identificadas: ${strongPoints.length}
$criticalResponsesText

⚠️ IMPORTANTE - El análisis se basa completamente en el ICA (Índice de Calidad Animal) obtenido de la evaluación de campo. Todas las recomendaciones deben estar alineadas con mejorar este índice.

REGLAS ESTRICTAS DE RESPUESTA:
1. Responde BREVE y DIRECTO (máximo 100 palabras)
2. Responde SOLO lo que preguntan
3. Usa BULLET POINTS cuando sea posible
4. Sé ESPECÍFICO y PRÁCTICO
5. Usa markdown simple (**, -, ###)
6. Contextualiza tus respuestas con el ICA y los datos del formulario

Pregunta del usuario: $userQuestion'''
          : '''You are an expert veterinarian specialized in $speciesName welfare.

FULL REPORT CONTEXT - AQI (Animal Quality Index):
📍 Farm: $farmName (location: $farmLocation)
📊 Overall AQI: ${overallScore.toStringAsFixed(1)}% (this is the Animal Quality Index based on the complete evaluation)

CATEGORY SCORES:
${categoryScores.entries.map((e) => '• ${_translateCategory(e.key, false)}: ${e.value.toStringAsFixed(0)}%').join('\n')}

EVALUATION DATA:
• Critical points identified: ${criticalPoints.length}
• Strengths identified: ${strongPoints.length}
$criticalResponsesText

⚠️ IMPORTANT - The analysis is completely based on the AQI (Animal Quality Index) obtained from the field evaluation. All recommendations should be aligned with improving this index.

STRICT RESPONSE RULES:
1. Answer BRIEF and DIRECT (max 100 words)
2. Answer ONLY what is asked
3. Use BULLET POINTS when possible
4. Be SPECIFIC and PRACTICAL
5. Use simple markdown (**, -, ###)
6. Contextualize your answers with the AQI and form data

User question: $userQuestion''';

      final content = [Content.text(systemPrompt)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Respuesta vacía de Gemini');
      }

      return response.text!;
    } catch (e) {
      print('❌ Error en chat: $e');
      rethrow;
    }
  }
}
