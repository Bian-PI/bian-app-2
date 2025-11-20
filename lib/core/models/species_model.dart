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
              label: 'water_access',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_quality',
              label: 'feed_quality',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feeders_sufficient',
              label: 'feeders_sufficient',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_frequency',
              label: 'feed_frequency',
              type: FieldType.number,
              unit: 'times_per_day',
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
              label: 'general_health',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'mortality_rate',
              label: 'mortality_rate',
              type: FieldType.percentage,
              required: true,
            ),
            EvaluationField(
              id: 'injuries',
              label: 'injuries',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'vaccination',
              label: 'vaccination',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'diseases',
              label: 'diseases',
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
              label: 'natural_behavior',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'aggression',
              label: 'aggression',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'stress_signs',
              label: 'stress_signs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'movement',
              label: 'movement',
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
              label: 'space_per_bird',
              type: FieldType.number,
              unit: 'cm2_per_bird',
              required: true,
            ),
            EvaluationField(
              id: 'ventilation',
              label: 'ventilation',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'temperature',
              label: 'temperature',
              type: FieldType.number,
              unit: 'celsius',
              required: true,
            ),
            EvaluationField(
              id: 'litter_quality',
              label: 'litter_quality',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'lighting',
              label: 'lighting',
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
              label: 'staff_training',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'records',
              label: 'records',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'biosecurity',
              label: 'biosecurity',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'handling',
              label: 'handling',
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
              id: 'water_access_pigs',
              label: 'water_access_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_quality_pigs',
              label: 'feed_quality_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feeders_sufficient_pigs',
              label: 'feeders_sufficient_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_frequency',
              label: 'feed_frequency',
              type: FieldType.number,
              unit: 'times_per_day',
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
              id: 'general_health_pigs',
              label: 'general_health_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'mortality_rate',
              label: 'mortality_rate',
              type: FieldType.percentage,
              required: true,
            ),
            EvaluationField(
              id: 'injuries_pigs',
              label: 'injuries_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'vaccination',
              label: 'vaccination',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'diseases',
              label: 'diseases',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'tail_biting',
              label: 'tail_biting',
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
              id: 'natural_behavior_pigs',
              label: 'natural_behavior_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'aggression_pigs',
              label: 'aggression_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'stress_signs_pigs',
              label: 'stress_signs_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'movement_pigs',
              label: 'movement_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'enrichment',
              label: 'enrichment',
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
              label: 'space_per_pig',
              type: FieldType.number,
              unit: 'm2_per_pig',
              required: true,
            ),
            EvaluationField(
              id: 'ventilation',
              label: 'ventilation',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'temperature_facility',
              label: 'temperature_facility',
              type: FieldType.number,
              unit: 'celsius',
              required: true,
            ),
            EvaluationField(
              id: 'floor_quality',
              label: 'floor_quality',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'lighting',
              label: 'lighting',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'resting_area',
              label: 'resting_area',
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
              label: 'staff_training',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'records',
              label: 'records',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'biosecurity',
              label: 'biosecurity',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'handling_pigs',
              label: 'handling_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'castration',
              label: 'castration',
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