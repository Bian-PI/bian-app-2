import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

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
    required String speciesType,
    required double overallScore,
    required Map<String, double> categoryScores,
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

      final speciesName = speciesType == 'birds'
          ? (isSpanish ? 'aves' : 'birds')
          : (isSpanish ? 'cerdos' : 'pigs');

      final criticalResponsesText = _buildCriticalResponsesSummary(
        formResponses,
        criticalPoints,
        isSpanish,
      );

      final categoryScoresText = categoryScores.entries
          .map((e) => '  • ${e.key}: ${e.value.toStringAsFixed(1)}%')
          .join('\n');

      final systemPrompt = '''
CONTEXTO COMPLETO DEL REPORTE - ICA (Índice de Calidad Animal):

📍 Granja: $farmName (ubicación: $farmLocation)
🐾 Especie: $speciesName
📊 ICA General: ${overallScore.toStringAsFixed(1)}%

📈 Puntuaciones por Categoría:
$categoryScoresText

$criticalResponsesText

⚠️ IMPORTANTE: Todo el análisis y las respuestas se basan en el ICA (Índice de Calidad Animal), que mide el bienestar de los animales en esta granja.

Puntos Críticos detectados: ${criticalPoints.length}
Puntos Fuertes: ${strongPoints.length}

INSTRUCCIONES CRÍTICAS:
- Responde en ${isSpanish ? 'español' : 'inglés'} de forma CLARA y SIMPLE.
- NUNCA uses términos técnicos del formulario (como "lighting_false", "water_access", etc).
- SIEMPRE habla en lenguaje natural que cualquier persona pueda entender.
- En lugar de decir "lighting_false indica que...", di "La iluminación es inadecuada..."
- En lugar de mencionar nombres de campos técnicos, describe el problema directamente.
- Sé conciso pero informativo (máximo 3-4 párrafos).
- Enfoca tus respuestas en QUÉ está mal y CÓMO afecta a los animales.
- Si preguntan por recomendaciones, da acciones específicas y prácticas.
- Usa un tono profesional pero conversacional, como si hablaras con el dueño de la granja.
- Evita jerga técnica y términos científicos innecesarios.
''';

      final userPrompt = '''
PREGUNTA DEL USUARIO:
$userQuestion

CONTEXTO (basado en ICA):
- Especie: $speciesName
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
      // Relanzar excepción para que el llamador pueda manejarla (ej: no descontar intento)
      rethrow;
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
        ? '🔍 ASPECTOS CRÍTICOS DETECTADOS EN LA GRANJA:'
        : '🔍 CRITICAL ASPECTS DETECTED ON THE FARM:');
    buffer.writeln();

    final limitedCriticalPoints = criticalPoints.take(5).toList();

    for (final point in limitedCriticalPoints) {
      final value = formResponses[point];
      if (value != null) {
        final humanReadableName = _convertFieldToHumanReadable(point, isSpanish);
        final humanReadableValue = _convertValueToHumanReadable(value, isSpanish);

        buffer.writeln('• $humanReadableName: $humanReadableValue');
      }
    }

    if (criticalPoints.length > 5) {
      buffer.writeln(isSpanish
          ? '\n... y ${criticalPoints.length - 5} aspectos críticos más detectados.'
          : '\n... and ${criticalPoints.length - 5} more critical aspects detected.');
    }

    return buffer.toString();
  }

  String _convertFieldToHumanReadable(String fieldName, bool isSpanish) {
    // Remover prefijos comunes de categorías (pigs_, birds_, etc)
    String cleanName = fieldName;
    if (cleanName.contains('_')) {
      final parts = cleanName.split('_');
      if (parts.length > 1) {
        // Si empieza con pigs, birds, etc, removerlo
        if (['pigs', 'birds', 'cattle', 'sheep'].contains(parts[0])) {
          cleanName = parts.sublist(1).join('_');
        }
      }
    }

    // Mapa de traducciones de campos técnicos a lenguaje humano
    final translations = {
      // Iluminación
      'lighting': isSpanish ? 'Iluminación' : 'Lighting',
      'natural_light': isSpanish ? 'Luz natural' : 'Natural light',
      'artificial_light': isSpanish ? 'Luz artificial' : 'Artificial light',

      // Ventilación
      'ventilation': isSpanish ? 'Ventilación' : 'Ventilation',
      'air_quality': isSpanish ? 'Calidad del aire' : 'Air quality',
      'temperature': isSpanish ? 'Temperatura' : 'Temperature',

      // Espacio
      'space': isSpanish ? 'Espacio disponible' : 'Available space',
      'overcrowding': isSpanish ? 'Hacinamiento' : 'Overcrowding',
      'pen_size': isSpanish ? 'Tamaño de corrales' : 'Pen size',

      // Agua
      'water': isSpanish ? 'Agua' : 'Water',
      'water_access': isSpanish ? 'Acceso al agua' : 'Water access',
      'water_quality': isSpanish ? 'Calidad del agua' : 'Water quality',
      'water_availability': isSpanish ? 'Disponibilidad de agua' : 'Water availability',

      // Alimentación
      'feeding': isSpanish ? 'Alimentación' : 'Feeding',
      'feed_quality': isSpanish ? 'Calidad del alimento' : 'Feed quality',
      'feed_access': isSpanish ? 'Acceso al alimento' : 'Feed access',

      // Salud
      'health': isSpanish ? 'Salud' : 'Health',
      'injuries': isSpanish ? 'Lesiones' : 'Injuries',
      'diseases': isSpanish ? 'Enfermedades' : 'Diseases',
      'veterinary_care': isSpanish ? 'Atención veterinaria' : 'Veterinary care',

      // Comportamiento
      'behavior': isSpanish ? 'Comportamiento' : 'Behavior',
      'aggression': isSpanish ? 'Agresividad' : 'Aggression',
      'stress': isSpanish ? 'Estrés' : 'Stress',

      // Instalaciones
      'facilities': isSpanish ? 'Instalaciones' : 'Facilities',
      'floor_condition': isSpanish ? 'Condición del piso' : 'Floor condition',
      'cleanliness': isSpanish ? 'Limpieza' : 'Cleanliness',
      'maintenance': isSpanish ? 'Mantenimiento' : 'Maintenance',
    };

    // Buscar traducción exacta
    if (translations.containsKey(cleanName)) {
      return translations[cleanName]!;
    }

    // Si no hay traducción, hacer el campo más legible
    return cleanName
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _convertValueToHumanReadable(dynamic value, bool isSpanish) {
    if (value == null) {
      return isSpanish ? 'No registrado' : 'Not recorded';
    }

    // Convertir valores booleanos y comunes
    final valueStr = value.toString().toLowerCase();

    final translations = {
      'true': isSpanish ? 'Sí' : 'Yes',
      'false': isSpanish ? 'No' : 'No',
      'yes': isSpanish ? 'Sí' : 'Yes',
      'no': isSpanish ? 'No' : 'No',
      'good': isSpanish ? 'Bueno' : 'Good',
      'bad': isSpanish ? 'Malo' : 'Bad',
      'poor': isSpanish ? 'Pobre' : 'Poor',
      'excellent': isSpanish ? 'Excelente' : 'Excellent',
      'adequate': isSpanish ? 'Adecuado' : 'Adequate',
      'inadequate': isSpanish ? 'Inadecuado' : 'Inadequate',
      'sufficient': isSpanish ? 'Suficiente' : 'Sufficient',
      'insufficient': isSpanish ? 'Insuficiente' : 'Insufficient',
      'present': isSpanish ? 'Presente' : 'Present',
      'absent': isSpanish ? 'Ausente' : 'Absent',
    };

    if (translations.containsKey(valueStr)) {
      return translations[valueStr]!;
    }

    return value.toString();
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
