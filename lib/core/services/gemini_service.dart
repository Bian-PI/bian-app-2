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
}
