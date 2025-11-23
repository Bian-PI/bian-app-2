import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_GEMINI_API_KEY_HERE';

  late final GenerativeModel _model;
  bool _isInitialized = false;

  GeminiService() {
    _initializeModel();
  }

  void _initializeModel() {
    try {
      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );
      _isInitialized = true;
    } catch (e) {
      print('❌ Error inicializando Gemini: $e');
      _isInitialized = false;
    }
  }

  bool get isAvailable => _isInitialized;

  Future<String> chatAboutReport({
    required String userQuestion,
    required Map<String, dynamic> formResponses,
    required String farmName,
    required String farmLocation,
    required double overallScore,
    required List<String> criticalPoints,
    required List<String> strongPoints,
    required String language,
  }) async {
    if (!_isInitialized) {
      return language == 'es'
          ? 'El servicio de chat no está disponible en este momento.'
          : 'Chat service is not available at the moment.';
    }

    try {
      final isSpanish = language == 'es';

      final criticalResponsesText = _buildCriticalResponsesSummary(
        formResponses,
        criticalPoints,
        isSpanish,
      );

      final systemPrompt = '''
CONTEXTO COMPLETO DEL REPORTE - ICA (Índice de Calidad Animal):

📍 Granja: $farmName (ubicación: $farmLocation)
📊 ICA General: ${overallScore.toStringAsFixed(1)}%

$criticalResponsesText

⚠️ IMPORTANTE: Todo el análisis y las respuestas se basan completamente en el ICA (Índice de Calidad Animal), que refleja el bienestar de los animales en esta granja.

Puntos Críticos detectados: ${criticalPoints.length}
Puntos Fuertes: ${strongPoints.length}

INSTRUCCIONES:
- Responde en ${isSpanish ? 'español' : 'inglés'}.
- Sé conciso pero informativo.
- Enfoca tus respuestas en el ICA y los indicadores de bienestar animal.
- Si preguntan por recomendaciones, prioriza los puntos críticos.
- Usa un tono profesional pero accesible.
''';

      final userPrompt = '''
PREGUNTA DEL USUARIO:
$userQuestion

CONTEXTO (basado en ICA):
- ICA: ${overallScore.toStringAsFixed(1)}%
- Granja: $farmName
- Ubicación: $farmLocation
- Puntos críticos: ${criticalPoints.length}
- Puntos fuertes: ${strongPoints.length}
''';

      final content = [Content.text('$systemPrompt\n\n$userPrompt')];
      final response = await _model.generateContent(content);

      return response.text ?? (isSpanish
          ? 'No pude generar una respuesta. Por favor, intenta de nuevo.'
          : 'Could not generate a response. Please try again.');

    } catch (e) {
      print('❌ Error en chat Gemini: $e');
      return language == 'es'
          ? 'Error al procesar tu pregunta. Por favor, intenta de nuevo.'
          : 'Error processing your question. Please try again.';
    }
  }

  String _buildCriticalResponsesSummary(
    Map<String, dynamic> formResponses,
    List<String> criticalPoints,
    bool isSpanish,
  ) {
    if (criticalPoints.isEmpty) {
      return isSpanish
          ? '✅ No hay puntos críticos detectados.'
          : '✅ No critical points detected.';
    }

    final buffer = StringBuffer();
    buffer.writeln(isSpanish
        ? '🔍 RESPUESTAS CRÍTICAS DEL FORMULARIO PSI:'
        : '🔍 CRITICAL PSI FORM RESPONSES:');
    buffer.writeln();

    final limitedCriticalPoints = criticalPoints.take(5).toList();

    for (final point in limitedCriticalPoints) {
      final value = formResponses[point];
      if (value != null) {
        final parts = point.split('_');
        final fieldName = parts.length > 1
            ? parts.sublist(1).join(' ').replaceAll('_', ' ')
            : point;

        buffer.writeln('• $fieldName: $value');
      }
    }

    if (criticalPoints.length > 5) {
      buffer.writeln(isSpanish
          ? '\n... y ${criticalPoints.length - 5} puntos críticos más.'
          : '\n... and ${criticalPoints.length - 5} more critical points.');
    }

    return buffer.toString();
  }

  Future<String> analyzeAnimalWelfareReport({
    required String speciesType,
    required double overallScore,
    required Map<String, double> categoryScores,
    required List<String> criticalPoints,
    required List<String> strongPoints,
    required String language,
  }) async {
    if (!_isInitialized) {
      return language == 'es'
          ? 'El servicio de análisis con IA no está disponible en este momento.'
          : 'AI analysis service is not available at the moment.';
    }

    try {
      final isSpanish = language == 'es';

      final speciesName = speciesType == 'birds'
          ? (isSpanish ? 'aves' : 'birds')
          : (isSpanish ? 'cerdos' : 'pigs');

      String complianceLevel;
      if (overallScore >= 90) {
        complianceLevel = isSpanish ? 'Excelente' : 'Excellent';
      } else if (overallScore >= 75) {
        complianceLevel = isSpanish ? 'Bueno' : 'Good';
      } else if (overallScore >= 60) {
        complianceLevel = isSpanish ? 'Aceptable' : 'Acceptable';
      } else if (overallScore >= 40) {
        complianceLevel = isSpanish ? 'Necesita Mejora' : 'Needs Improvement';
      } else {
        complianceLevel = isSpanish ? 'Crítico' : 'Critical';
      }

      final categoryScoresText = categoryScores.entries
          .map((e) => '• ${e.key}: ${e.value.toStringAsFixed(1)}%')
          .join('\n');

      final prompt = '''
Eres un experto en bienestar animal especializado en ${isSpanish ? 'granjas de' : 'farms of'} $speciesName.

${isSpanish ? 'DATOS DEL REPORTE - ICA (Índice de Calidad Animal):' : 'REPORT DATA - ICA (Animal Quality Index):'}

${isSpanish ? '📊 ICA General:' : '📊 Overall ICA:'} ${overallScore.toStringAsFixed(1)}% ($complianceLevel)

${isSpanish ? '📈 Puntuaciones por Categoría:' : '📈 Category Scores:'}
$categoryScoresText

${isSpanish ? '⚠️ Puntos Críticos:' : '⚠️ Critical Points:'} ${criticalPoints.length}
${isSpanish ? '✅ Puntos Fuertes:' : '✅ Strong Points:'} ${strongPoints.length}

${isSpanish ? 'INSTRUCCIONES:' : 'INSTRUCTIONS:'}
1. ${isSpanish ? 'Genera un análisis profesional y conciso del bienestar animal en esta granja.' : 'Generate a professional and concise analysis of animal welfare on this farm.'}
2. ${isSpanish ? 'Enfócate en el ICA y lo que significa para los animales.' : 'Focus on the ICA and what it means for the animals.'}
3. ${isSpanish ? 'Identifica las 2-3 áreas más importantes que requieren atención inmediata basándote en los puntos críticos.' : 'Identify the 2-3 most important areas requiring immediate attention based on critical points.'}
4. ${isSpanish ? 'Menciona los puntos fuertes brevemente.' : 'Mention the strong points briefly.'}
5. ${isSpanish ? 'Proporciona 3-4 recomendaciones específicas y accionables priorizando los puntos críticos.' : 'Provide 3-4 specific and actionable recommendations prioritizing critical points.'}
6. ${isSpanish ? 'Usa un tono profesional pero accesible.' : 'Use a professional but accessible tone.'}
7. ${isSpanish ? 'Mantén el análisis enfocado en el bienestar animal y el ICA.' : 'Keep the analysis focused on animal welfare and the ICA.'}
8. ${isSpanish ? 'NO uses markdown, emojis decorativos, ni formato especial. Solo texto plano estructurado.' : 'DO NOT use markdown, decorative emojis, or special formatting. Only structured plain text.'}

${isSpanish ? 'Genera el análisis ahora:' : 'Generate the analysis now:'}
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? (isSpanish
          ? 'No se pudo generar el análisis. Por favor, intenta de nuevo.'
          : 'Could not generate analysis. Please try again.');

    } catch (e) {
      print('❌ Error generando análisis con IA: $e');
      return language == 'es'
          ? 'Error al generar el análisis con IA. Verifica tu conexión y la configuración de la API key.'
          : 'Error generating AI analysis. Check your connection and API key configuration.';
    }
  }
}
