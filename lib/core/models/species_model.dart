class Species {
  final String id;
  final String name;
  final String namePlural;
  final String iconPath;
  final List<String> gradientColors;
  final List<EvaluationCategory> categories;

  Species({
    required this.id,
    required this.name,
    required this.namePlural,
    required this.iconPath,
    required this.gradientColors,
    required this.categories,
  });

  static Species birds() {
    return Species(
      id: 'birds',
      name: 'Ave',
      namePlural: 'Aves',
      iconPath: 'assets/icons/ave.svg',
      gradientColors: ['0xFF4A90E2', '0xFF357ABD'],
      categories: [
        EvaluationCategory(
          id: 'feeding',
          name: 'Alimentación',
          icon: 'restaurant',
          fields: [
            EvaluationField(
              id: 'water_access',
              label: '¿Las aves tienen acceso permanente a agua limpia?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_quality',
              label: '¿El alimento es de buena calidad y apropiado?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feeders_sufficient',
              label: '¿Los comederos son suficientes para todas las aves?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_frequency',
              label: 'Frecuencia de alimentación diaria',
              type: FieldType.number,
              unit: 'veces/día',
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'health',
          name: 'Sanidad',
          icon: 'medical_services',
          fields: [
            EvaluationField(
              id: 'general_health',
              label: '¿El lote presenta buen estado de salud general?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'mortality_rate',
              label: 'Tasa de mortalidad semanal',
              type: FieldType.percentage,
              required: true,
            ),
            EvaluationField(
              id: 'injuries',
              label: '¿Se observan lesiones o heridas en las aves?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'vaccination',
              label: '¿El programa de vacunación está al día?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'diseases',
              label: '¿Hay presencia de enfermedades diagnosticadas?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'behavior',
          name: 'Comportamiento',
          icon: 'psychology',
          fields: [
            EvaluationField(
              id: 'natural_behavior',
              label: '¿Las aves pueden expresar comportamientos naturales?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'aggression',
              label: '¿Se observa agresividad o canibalismo?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'stress_signs',
              label: '¿Hay signos de estrés en el lote?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'movement',
              label: '¿Las aves se mueven con normalidad?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'infrastructure',
          name: 'Infraestructura',
          icon: 'home_work',
          fields: [
            EvaluationField(
              id: 'space_per_bird',
              label: 'Espacio disponible por ave',
              type: FieldType.number,
              unit: 'cm²/ave',
              required: true,
            ),
            EvaluationField(
              id: 'ventilation',
              label: '¿La ventilación es adecuada?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'temperature',
              label: 'Temperatura promedio del galpón',
              type: FieldType.number,
              unit: '°C',
              required: true,
            ),
            EvaluationField(
              id: 'litter_quality',
              label: '¿La cama/piso está en buen estado?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'lighting',
              label: '¿La iluminación es apropiada?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'management',
          name: 'Manejo',
          icon: 'agriculture',
          fields: [
            EvaluationField(
              id: 'staff_training',
              label: '¿El personal está capacitado en bienestar animal?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'records',
              label: '¿Se llevan registros actualizados?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'biosecurity',
              label: '¿Se aplican medidas de bioseguridad?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'handling',
              label: '¿El manejo de las aves es gentil y apropiado?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
      ],
    );
  }

  static Species pigs() {
    return Species(
      id: 'pigs',
      name: 'Cerdo',
      namePlural: 'Cerdos',
      iconPath: 'assets/icons/cerdo.svg',
      gradientColors: ['0xFFE85D75', '0xFFD84A64'],
      categories: [
        EvaluationCategory(
          id: 'feeding',
          name: 'Alimentación',
          icon: 'restaurant',
          fields: [
            EvaluationField(
              id: 'water_access',
              label: '¿Los cerdos tienen acceso permanente a agua limpia?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_quality',
              label: '¿El alimento es de buena calidad y balanceado?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feeders_sufficient',
              label: '¿Los comederos son suficientes para todos los animales?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_frequency',
              label: 'Frecuencia de alimentación diaria',
              type: FieldType.number,
              unit: 'veces/día',
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'health',
          name: 'Sanidad',
          icon: 'medical_services',
          fields: [
            EvaluationField(
              id: 'general_health',
              label: '¿Los cerdos presentan buen estado de salud general?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'mortality_rate',
              label: 'Tasa de mortalidad semanal',
              type: FieldType.percentage,
              required: true,
            ),
            EvaluationField(
              id: 'injuries',
              label: '¿Se observan lesiones, cojeras o heridas?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'vaccination',
              label: '¿El programa de vacunación está al día?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'diseases',
              label: '¿Hay presencia de enfermedades diagnosticadas?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'tail_biting',
              label: '¿Se observa mordedura de colas?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'behavior',
          name: 'Comportamiento',
          icon: 'psychology',
          fields: [
            EvaluationField(
              id: 'natural_behavior',
              label: '¿Los cerdos pueden expresar comportamientos naturales?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'aggression',
              label: '¿Se observa agresividad excesiva?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'stress_signs',
              label: '¿Hay signos de estrés en los animales?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'movement',
              label: '¿Los cerdos se mueven con normalidad?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'enrichment',
              label: '¿Se proporciona enriquecimiento ambiental?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'infrastructure',
          name: 'Infraestructura',
          icon: 'home_work',
          fields: [
            EvaluationField(
              id: 'space_per_pig',
              label: 'Espacio disponible por cerdo',
              type: FieldType.number,
              unit: 'm²/cerdo',
              required: true,
            ),
            EvaluationField(
              id: 'ventilation',
              label: '¿La ventilación es adecuada?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'temperature',
              label: 'Temperatura promedio de la instalación',
              type: FieldType.number,
              unit: '°C',
              required: true,
            ),
            EvaluationField(
              id: 'floor_quality',
              label: '¿El piso está en buen estado y es adecuado?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'lighting',
              label: '¿La iluminación es apropiada?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'resting_area',
              label: '¿Hay área de descanso limpia y seca?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'management',
          name: 'Manejo',
          icon: 'agriculture',
          fields: [
            EvaluationField(
              id: 'staff_training',
              label: '¿El personal está capacitado en bienestar animal?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'records',
              label: '¿Se llevan registros actualizados?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'biosecurity',
              label: '¿Se aplican medidas de bioseguridad?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'handling',
              label: '¿El manejo de los cerdos es gentil y apropiado?',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'castration',
              label: '¿La castración se realiza con anestesia/analgesia?',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
      ],
    );
  }
}

class EvaluationCategory {
  final String id;
  final String name;
  final String icon;
  final List<EvaluationField> fields;

  EvaluationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.fields,
  });
}

class EvaluationField {
  final String id;
  final String label;
  final FieldType type;
  final String? unit;
  final bool required;
  final List<String>? options;

  EvaluationField({
    required this.id,
    required this.label,
    required this.type,
    this.unit,
    this.required = false,
    this.options,
  });
}

enum FieldType {
  yesNo,
  number,
  percentage,
  text,
  select,
}