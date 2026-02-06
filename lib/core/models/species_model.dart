/// Modelo de especies y evaluación según metodología ICA (2024)
/// Resolución 253 de 2020 - Bienestar Animal en Aves de Corral
///
/// Sistema de calificación:
/// - Escala por indicador: 0, 1, 2
/// - Clasificación final:
///   * ≥90%: GRANJA CON EXCELENTE BIENESTAR
///   * 76%-90%: GRANJA CON ALTO BIENESTAR
///   * 50%-75%: GRANJA CON MEDIO BIENESTAR
///   * <50%: GRANJA CON BAJO BIENESTAR

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

  /// Aves de Corral - Metodología ICA
  /// Aplica para: Pollo de engorde, Ponedoras en piso, Ponedoras en jaula, Pastoreo
  static Species birds() {
    return Species(
      id: 'birds',
      name: 'Ave',
      namePlural: 'Aves',
      iconPath: 'assets/icons/ave.svg',
      gradientColors: ['0xFF4A90E2', '0xFF357ABD'],
      categories: [
        // ═══════════════════════════════════════════════════════════════
        // CATEGORÍA 1: MEDIDAS BASADAS EN LOS RECURSOS (MBR) - 35%
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'resources',
          name: 'Medidas Basadas en los Recursos',
          nameKey: 'category_resources',
          icon: 'home_work',
          weight: 0.35, // 35%
          fields: [
            // 7.2. Medición de partículas suspendidas en el aire
            EvaluationField(
              id: 'air_particles',
              label: 'air_particles_label',
              description: 'air_particles_description',
              question: 'air_particles_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.3. Calidad de la cama
            EvaluationField(
              id: 'bedding_quality',
              label: 'bedding_quality_label',
              description: 'bedding_quality_description',
              question: 'bedding_quality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'pastoreo'],
            ),
            // 7.5. Calidad de los bebederos
            EvaluationField(
              id: 'drinker_quality',
              label: 'drinker_quality_label',
              description: 'drinker_quality_description',
              question: 'drinker_quality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.6. Suministro de agua en los bebederos
            EvaluationField(
              id: 'water_supply',
              label: 'water_supply_label',
              description: 'water_supply_description',
              question: 'water_supply_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.7. Animales por bebedero
            EvaluationField(
              id: 'animals_per_drinker',
              label: 'animals_per_drinker_label',
              description: 'animals_per_drinker_description',
              question: 'animals_per_drinker_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.8. Tratamiento del agua
            EvaluationField(
              id: 'water_treatment',
              label: 'water_treatment_label',
              description: 'water_treatment_description',
              question: 'water_treatment_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.9. Calidad de los comederos
            EvaluationField(
              id: 'feeder_quality',
              label: 'feeder_quality_label',
              description: 'feeder_quality_description',
              question: 'feeder_quality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.10. Animales por comedero
            EvaluationField(
              id: 'animals_per_feeder',
              label: 'animals_per_feeder_label',
              description: 'animals_per_feeder_description',
              question: 'animals_per_feeder_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.11. Medios para contribuir al confort térmico
            EvaluationField(
              id: 'thermal_comfort',
              label: 'thermal_comfort_label',
              description: 'thermal_comfort_description',
              question: 'thermal_comfort_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 7.12. Calidad, integridad y funcionalidad del nidal
            EvaluationField(
              id: 'nest_quality',
              label: 'nest_quality_label',
              description: 'nest_quality_description',
              question: 'nest_quality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['ponedoras_piso', 'pastoreo'],
            ),
            // 7.14. Espacio disponible en ponedoras en piso y pastoreo
            EvaluationField(
              id: 'available_space',
              label: 'available_space_label',
              description: 'available_space_description',
              question: 'available_space_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
          ],
        ),

        // ═══════════════════════════════════════════════════════════════
        // CATEGORÍA 2: MEDIDAS BASADAS EN EL ANIMAL (MBA) - 35%
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'animal',
          name: 'Medidas Basadas en el Animal',
          nameKey: 'category_animal',
          icon: 'pets',
          weight: 0.35, // 35%
          fields: [
            // 8.1. Jadeo
            EvaluationField(
              id: 'panting',
              label: 'panting_label',
              description: 'panting_description',
              question: 'panting_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionNoSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.2. Acurrucarse en grupos (amontonamiento)
            EvaluationField(
              id: 'huddling',
              label: 'huddling_label',
              description: 'huddling_description',
              question: 'huddling_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionNoSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.3. Integridad del hueso de la quilla
            EvaluationField(
              id: 'keel_bone_integrity',
              label: 'keel_bone_integrity_label',
              description: 'keel_bone_integrity_description',
              question: 'keel_bone_integrity_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.4. Pododermatitis
            EvaluationField(
              id: 'pododermatitis',
              label: 'pododermatitis_label',
              description: 'pododermatitis_description',
              question: 'pododermatitis_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.5. Daño en los dedos
            EvaluationField(
              id: 'toe_damage',
              label: 'toe_damage_label',
              description: 'toe_damage_description',
              question: 'toe_damage_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.7. Lesiones en piel y/o otros tegumentos
            EvaluationField(
              id: 'skin_lesions',
              label: 'skin_lesions_label',
              description: 'skin_lesions_description',
              question: 'skin_lesions_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.8. Suciedad y apariencia del plumaje
            EvaluationField(
              id: 'plumage_condition',
              label: 'plumage_condition_label',
              description: 'plumage_condition_description',
              question: 'plumage_condition_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.9. Integridad óculo-nasal
            EvaluationField(
              id: 'ocular_nasal_integrity',
              label: 'ocular_nasal_integrity_label',
              description: 'ocular_nasal_integrity_description',
              question: 'ocular_nasal_integrity_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.10. Condición del pico
            EvaluationField(
              id: 'beak_condition',
              label: 'beak_condition_label',
              description: 'beak_condition_description',
              question: 'beak_condition_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 2,
              required: true,
              applicableTo: ['ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 8.11. Mortalidad
            EvaluationField(
              id: 'mortality',
              label: 'mortality_label',
              description: 'mortality_description',
              question: 'mortality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
          ],
        ),

        // ═══════════════════════════════════════════════════════════════
        // CATEGORÍA 3: MEDIDAS BASADAS EN LA GESTIÓN (MBG) - 30%
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'management',
          name: 'Medidas Basadas en la Gestión',
          nameKey: 'category_management',
          icon: 'assignment',
          weight: 0.30, // 30%
          fields: [
            // 9.1. Calidad del agua
            EvaluationField(
              id: 'water_quality',
              label: 'water_quality_label',
              description: 'water_quality_description',
              question: 'water_quality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.2. Alimentación equilibrada
            EvaluationField(
              id: 'balanced_feeding',
              label: 'balanced_feeding_label',
              description: 'balanced_feeding_description',
              question: 'balanced_feeding_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.3. Programas de vigilancia y gestión sanitaria
            EvaluationField(
              id: 'health_surveillance',
              label: 'health_surveillance_label',
              description: 'health_surveillance_description',
              question: 'health_surveillance_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.4. Procedimiento Operativo Estandarizado (POE-Bienestar animal)
            EvaluationField(
              id: 'poe_animal_welfare',
              label: 'poe_animal_welfare_label',
              description: 'poe_animal_welfare_description',
              question: 'poe_animal_welfare_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.5. Condiciones térmicas diarias y manejo de emergencias
            EvaluationField(
              id: 'thermal_emergency',
              label: 'thermal_emergency_label',
              description: 'thermal_emergency_description',
              question: 'thermal_emergency_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.6. Programa de iluminación
            EvaluationField(
              id: 'lighting_program',
              label: 'lighting_program_label',
              description: 'lighting_program_description',
              question: 'lighting_program_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.7. Capacitación básica en bienestar animal
            EvaluationField(
              id: 'welfare_training',
              label: 'welfare_training_label',
              description: 'welfare_training_description',
              question: 'welfare_training_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.8. Protocolo de sacrificio humanitario o eutanasia
            EvaluationField(
              id: 'euthanasia_protocol',
              label: 'euthanasia_protocol_label',
              description: 'euthanasia_protocol_description',
              question: 'euthanasia_protocol_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.9. Capacitación en técnicas de sacrificio humanitario o eutanasia
            EvaluationField(
              id: 'euthanasia_training',
              label: 'euthanasia_training_label',
              description: 'euthanasia_training_description',
              question: 'euthanasia_training_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
            // 9.10. Uso responsable de medicamentos e insumos veterinarios
            EvaluationField(
              id: 'responsible_medication',
              label: 'responsible_medication_label',
              description: 'responsible_medication_description',
              question: 'responsible_medication_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
              applicableTo: ['pollo_engorde', 'ponedoras_piso', 'ponedoras_jaula', 'pastoreo'],
            ),
          ],
        ),
      ],
    );
  }

  /// Cerdos - Mantener estructura anterior por ahora
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
          nameKey: 'category_feeding',
          icon: 'restaurant',
          weight: 0.20,
          fields: [
            EvaluationField(
              id: 'water_access_pigs',
              label: 'water_access_pigs',
              question: 'water_access_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_quality_pigs',
              label: 'feed_quality_pigs',
              question: 'feed_quality_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feeders_sufficient_pigs',
              label: 'feeders_sufficient_pigs',
              question: 'feeders_sufficient_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'feed_frequency',
              label: 'feed_frequency',
              question: 'feed_frequency',
              type: FieldType.number,
              unit: 'times_per_day',
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'health',
          name: 'Sanidad',
          nameKey: 'category_health',
          icon: 'medical_services',
          weight: 0.20,
          fields: [
            EvaluationField(
              id: 'general_health_pigs',
              label: 'general_health_pigs',
              question: 'general_health_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'mortality_rate',
              label: 'mortality_rate',
              question: 'mortality_rate',
              type: FieldType.percentage,
              required: true,
            ),
            EvaluationField(
              id: 'injuries_pigs',
              label: 'injuries_pigs',
              question: 'injuries_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'vaccination',
              label: 'vaccination',
              question: 'vaccination',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'diseases',
              label: 'diseases',
              question: 'diseases',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'tail_biting',
              label: 'tail_biting',
              question: 'tail_biting',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'behavior',
          name: 'Comportamiento',
          nameKey: 'category_behavior',
          icon: 'psychology',
          weight: 0.20,
          fields: [
            EvaluationField(
              id: 'natural_behavior_pigs',
              label: 'natural_behavior_pigs',
              question: 'natural_behavior_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'aggression_pigs',
              label: 'aggression_pigs',
              question: 'aggression_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'stress_signs_pigs',
              label: 'stress_signs_pigs',
              question: 'stress_signs_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'movement_pigs',
              label: 'movement_pigs',
              question: 'movement_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'enrichment',
              label: 'enrichment',
              question: 'enrichment',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'infrastructure',
          name: 'Infraestructura',
          nameKey: 'category_infrastructure',
          icon: 'home_work',
          weight: 0.20,
          fields: [
            EvaluationField(
              id: 'space_per_pig',
              label: 'space_per_pig',
              question: 'space_per_pig',
              type: FieldType.number,
              unit: 'm2_per_pig',
              required: true,
            ),
            EvaluationField(
              id: 'ventilation',
              label: 'ventilation',
              question: 'ventilation',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'temperature_facility',
              label: 'temperature_facility',
              question: 'temperature_facility',
              type: FieldType.number,
              unit: 'celsius',
              required: true,
            ),
            EvaluationField(
              id: 'floor_quality',
              label: 'floor_quality',
              question: 'floor_quality',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'lighting',
              label: 'lighting',
              question: 'lighting',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'resting_area',
              label: 'resting_area',
              question: 'resting_area',
              type: FieldType.yesNo,
              required: true,
            ),
          ],
        ),
        EvaluationCategory(
          id: 'management',
          name: 'Manejo',
          nameKey: 'category_management_pigs',
          icon: 'agriculture',
          weight: 0.20,
          fields: [
            EvaluationField(
              id: 'staff_training',
              label: 'staff_training',
              question: 'staff_training',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'records',
              label: 'records',
              question: 'records',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'biosecurity',
              label: 'biosecurity',
              question: 'biosecurity',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'handling_pigs',
              label: 'handling_pigs',
              question: 'handling_pigs',
              type: FieldType.yesNo,
              required: true,
            ),
            EvaluationField(
              id: 'castration',
              label: 'castration',
              question: 'castration',
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
  final String? nameKey; // Clave para traducción
  final String icon;
  final double weight; // Peso de la categoría (ej: 0.35 = 35%)
  final List<EvaluationField> fields;

  EvaluationCategory({
    required this.id,
    required this.name,
    this.nameKey,
    required this.icon,
    this.weight = 1.0,
    required this.fields,
  });

  /// Calcula el puntaje máximo posible de esta categoría
  int get maxPossibleScore {
    return fields.fold(0, (sum, field) => sum + field.maxScore);
  }
}

class EvaluationField {
  final String id;
  final String label;
  final String? description; // Descripción del indicador
  final String? question; // Pregunta específica para evaluar
  final FieldType type;
  final String? unit;
  final bool required;
  final List<String>? options;
  final int maxScore; // Puntaje máximo (generalmente 2 para ICA)
  final EvaluationMethod? evaluationMethod;
  final List<String>? applicableTo; // Tipos de granja donde aplica

  EvaluationField({
    required this.id,
    required this.label,
    this.description,
    this.question,
    required this.type,
    this.unit,
    this.required = false,
    this.options,
    this.maxScore = 2,
    this.evaluationMethod,
    this.applicableTo,
  });
}

/// Tipos de campo para la evaluación
enum FieldType {
  yesNo,           // Sí/No (legacy)
  number,          // Valor numérico
  percentage,      // Porcentaje
  text,            // Texto libre
  select,          // Selección de opciones
  scale0to2,       // Escala ICA: 0, 1, 2
}

/// Métodos de evaluación según ICA
enum EvaluationMethod {
  visualInspectionWithSampling,  // Inspección visual con muestreo
  visualInspectionNoSampling,    // Inspección visual sin muestreo
  documentInspection,            // Inspección documental
  visualAndDocumental,           // Inspección visual sin muestreo y documental
}

/// Clasificación de bienestar según ICA
enum WelfareClassification {
  excellent,  // ≥90% - Excelente bienestar
  high,       // 76%-90% - Alto bienestar
  medium,     // 50%-75% - Medio bienestar
  low,        // <50% - Bajo bienestar
}

/// Helper para obtener la clasificación basada en el porcentaje
WelfareClassification getWelfareClassification(double percentage) {
  if (percentage >= 90) return WelfareClassification.excellent;
  if (percentage >= 76) return WelfareClassification.high;
  if (percentage >= 50) return WelfareClassification.medium;
  return WelfareClassification.low;
}

/// Helper para obtener el nombre de la clasificación
String getWelfareClassificationName(WelfareClassification classification, String language) {
  final names = {
    WelfareClassification.excellent: {
      'es': 'GRANJA CON EXCELENTE BIENESTAR',
      'en': 'FARM WITH EXCELLENT WELFARE',
    },
    WelfareClassification.high: {
      'es': 'GRANJA CON ALTO BIENESTAR',
      'en': 'FARM WITH HIGH WELFARE',
    },
    WelfareClassification.medium: {
      'es': 'GRANJA CON MEDIO BIENESTAR',
      'en': 'FARM WITH MEDIUM WELFARE',
    },
    WelfareClassification.low: {
      'es': 'GRANJA CON BAJO BIENESTAR',
      'en': 'FARM WITH LOW WELFARE',
    },
  };
  return names[classification]?[language] ?? names[classification]?['es'] ?? '';
}
