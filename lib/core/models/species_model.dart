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

  /// Cerdos - Metodología EBA 3.0 (Evaluación de Bienestar Animal)
  /// 43 indicadores organizados por grupos: Recurso, Animal, Gestión
  /// Escala de calificación: 0-4
  /// 
  /// Categorías de libertad evaluadas:
  /// - Buena alimentación
  /// - Buena salud
  /// - Comportamiento adecuado
  /// - Confort adecuado
  /// - Ausencia de miedo y estrés
  static Species pigs() {
    return Species(
      id: 'pigs',
      name: 'Cerdo',
      namePlural: 'Cerdos',
      iconPath: 'assets/icons/cerdo.svg',
      gradientColors: ['0xFFE85D75', '0xFFD84A64'],
      categories: [
        // ═══════════════════════════════════════════════════════════════
        // GRUPO 1: RECURSO - Indicadores basados en recursos
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'resource',
          name: 'Indicadores de Recurso',
          nameKey: 'category_resource_pigs',
          icon: 'home_work',
          weight: 0.40, // 40%
          fields: [
            // EBA-A1: Relación animales:bebedero
            EvaluationField(
              id: 'eba_a1_animals_per_drinker',
              label: 'eba_a1_label',
              description: 'eba_a1_description',
              question: 'eba_a1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-A2: Caudal de bebedero
            EvaluationField(
              id: 'eba_a2_drinker_flow',
              label: 'eba_a2_label',
              description: 'eba_a2_description',
              question: 'eba_a2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'L/min',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-A3: Calidad microbiológica del agua
            EvaluationField(
              id: 'eba_a3_water_quality',
              label: 'eba_a3_label',
              description: 'eba_a3_description',
              question: 'eba_a3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-F1: Espacios de comedero suficientes
            EvaluationField(
              id: 'eba_f1_feeder_spaces',
              label: 'eba_f1_label',
              description: 'eba_f1_description',
              question: 'eba_f1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-F2: Condición corporal
            EvaluationField(
              id: 'eba_f2_body_condition',
              label: 'eba_f2_label',
              description: 'eba_f2_description',
              question: 'eba_f2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-F3: Tiempo de acceso tras reparto
            EvaluationField(
              id: 'eba_f3_access_time',
              label: 'eba_f3_label',
              description: 'eba_f3_description',
              question: 'eba_f3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'min',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-E1: Índice THI (Temperatura-Humedad)
            EvaluationField(
              id: 'eba_e1_thi_index',
              label: 'eba_e1_label',
              description: 'eba_e1_description',
              question: 'eba_e1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-E2: Amoníaco (NH3)
            EvaluationField(
              id: 'eba_e2_ammonia',
              label: 'eba_e2_label',
              description: 'eba_e2_description',
              question: 'eba_e2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'ppm',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-E3: CO₂
            EvaluationField(
              id: 'eba_e3_co2',
              label: 'eba_e3_label',
              description: 'eba_e3_description',
              question: 'eba_e3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'ppm',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-E4: Nivel de ruido
            EvaluationField(
              id: 'eba_e4_noise',
              label: 'eba_e4_label',
              description: 'eba_e4_description',
              question: 'eba_e4_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'dB(A)',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-E5: Iluminación mínima
            EvaluationField(
              id: 'eba_e5_lighting',
              label: 'eba_e5_label',
              description: 'eba_e5_description',
              question: 'eba_e5_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'lux',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-I1: Densidad de alojamiento
            EvaluationField(
              id: 'eba_i1_housing_density',
              label: 'eba_i1_label',
              description: 'eba_i1_description',
              question: 'eba_i1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              unit: 'm²/animal',
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-I2: Estado de pisos
            EvaluationField(
              id: 'eba_i2_floor_condition',
              label: 'eba_i2_label',
              description: 'eba_i2_description',
              question: 'eba_i2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-I3: Área de descanso seca
            EvaluationField(
              id: 'eba_i3_dry_resting_area',
              label: 'eba_i3_label',
              description: 'eba_i3_description',
              question: 'eba_i3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-I4: Suciedad corporal
            EvaluationField(
              id: 'eba_i4_body_dirtiness',
              label: 'eba_i4_label',
              description: 'eba_i4_description',
              question: 'eba_i4_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-I5: Material manipulable disponible
            EvaluationField(
              id: 'eba_i5_enrichment_material',
              label: 'eba_i5_label',
              description: 'eba_i5_description',
              question: 'eba_i5_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-R1: GMD (Ganancia Media Diaria)
            EvaluationField(
              id: 'eba_r1_daily_gain',
              label: 'eba_r1_label',
              description: 'eba_r1_description',
              question: 'eba_r1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: false,
              unit: 'g/día',
              applicableTo: ['ceba'],
            ),
            // EBA-L3: Temperatura nido/placa
            EvaluationField(
              id: 'eba_l3_nest_temperature',
              label: 'eba_l3_label',
              description: 'eba_l3_description',
              question: 'eba_l3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              unit: '°C',
              applicableTo: ['lactancia'],
            ),
          ],
        ),
        
        // ═══════════════════════════════════════════════════════════════
        // GRUPO 2: ANIMAL - Indicadores basados en el animal
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'animal',
          name: 'Indicadores del Animal',
          nameKey: 'category_animal_pigs',
          icon: 'pets',
          weight: 0.40, // 40%
          fields: [
            // EBA-H1: Cojeras
            EvaluationField(
              id: 'eba_h1_lameness',
              label: 'eba_h1_label',
              description: 'eba_h1_description',
              question: 'eba_h1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-H2: Lesiones tegumentarias
            EvaluationField(
              id: 'eba_h2_skin_lesions',
              label: 'eba_h2_label',
              description: 'eba_h2_description',
              question: 'eba_h2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-H3: Tos/estornudos
            EvaluationField(
              id: 'eba_h3_respiratory',
              label: 'eba_h3_label',
              description: 'eba_h3_description',
              question: 'eba_h3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-H4: Diarrea
            EvaluationField(
              id: 'eba_h4_diarrhea',
              label: 'eba_h4_label',
              description: 'eba_h4_description',
              question: 'eba_h4_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-H5: Mortalidad del lote
            EvaluationField(
              id: 'eba_h5_mortality',
              label: 'eba_h5_label',
              description: 'eba_h5_description',
              question: 'eba_h5_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-H6: Analgesia/anestesia en procedimientos
            EvaluationField(
              id: 'eba_h6_pain_management',
              label: 'eba_h6_label',
              description: 'eba_h6_description',
              question: 'eba_h6_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-H8: Cicatrices de cola
            EvaluationField(
              id: 'eba_h8_tail_scars',
              label: 'eba_h8_label',
              description: 'eba_h8_description',
              question: 'eba_h8_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-B1: Peleas (>3s)
            EvaluationField(
              id: 'eba_b1_fights',
              label: 'eba_b1_label',
              description: 'eba_b1_description',
              question: 'eba_b1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-B2: Uso de enriquecimiento
            EvaluationField(
              id: 'eba_b2_enrichment_use',
              label: 'eba_b2_label',
              description: 'eba_b2_description',
              question: 'eba_b2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-B3: Huida al acercamiento humano
            EvaluationField(
              id: 'eba_b3_human_approach',
              label: 'eba_b3_label',
              description: 'eba_b3_description',
              question: 'eba_b3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-R2: Colas mordidas activas
            EvaluationField(
              id: 'eba_r2_tail_biting',
              label: 'eba_r2_label',
              description: 'eba_r2_description',
              question: 'eba_r2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['ceba'],
            ),
            // EBA-L1: Mortalidad predestete
            EvaluationField(
              id: 'eba_l1_preweaning_mortality',
              label: 'eba_l1_label',
              description: 'eba_l1_description',
              question: 'eba_l1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: false,
              applicableTo: ['lactancia'],
            ),
            // EBA-L2: Aplastamientos
            EvaluationField(
              id: 'eba_l2_crushing',
              label: 'eba_l2_label',
              description: 'eba_l2_description',
              question: 'eba_l2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: false,
              applicableTo: ['lactancia'],
            ),
            // EBA-G1: Gestantes en grupo
            EvaluationField(
              id: 'eba_g1_group_housing',
              label: 'eba_g1_label',
              description: 'eba_g1_description',
              question: 'eba_g1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['gestantes'],
            ),
          ],
        ),
        
        // ═══════════════════════════════════════════════════════════════
        // GRUPO 3: GESTIÓN - Indicadores de gestión
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'management',
          name: 'Indicadores de Gestión',
          nameKey: 'category_management_pigs',
          icon: 'assignment',
          weight: 0.20, // 20%
          fields: [
            // EBA-P1: Capacitación en bienestar animal
            EvaluationField(
              id: 'eba_p1_staff_training',
              label: 'eba_p1_label',
              description: 'eba_p1_description',
              question: 'eba_p1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-D1: Procedimientos escritos vigentes (SOPs)
            EvaluationField(
              id: 'eba_d1_sops',
              label: 'eba_d1_label',
              description: 'eba_d1_description',
              question: 'eba_d1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
            // EBA-D2: Plan de contingencia
            EvaluationField(
              id: 'eba_d2_contingency_plan',
              label: 'eba_d2_label',
              description: 'eba_d2_description',
              question: 'eba_d2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: true,
              applicableTo: ['lechones', 'ceba', 'gestantes'],
            ),
          ],
        ),
        
        // ═══════════════════════════════════════════════════════════════
        // GRUPO 4: TRANSPORTE (Opcional según aplique)
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'transport',
          name: 'Indicadores de Transporte',
          nameKey: 'category_transport_pigs',
          icon: 'local_shipping',
          weight: 0.0, // No ponderado - evaluación adicional
          fields: [
            // EBA-T1: Animales no ambulatorios
            EvaluationField(
              id: 'eba_t1_non_ambulatory',
              label: 'eba_t1_label',
              description: 'eba_t1_description',
              question: 'eba_t1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['transporte'],
            ),
            // EBA-T2: Muertos a la llegada (DOA)
            EvaluationField(
              id: 'eba_t2_doa',
              label: 'eba_t2_label',
              description: 'eba_t2_description',
              question: 'eba_t2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['transporte'],
            ),
            // EBA-T3: Densidad de carga
            EvaluationField(
              id: 'eba_t3_load_density',
              label: 'eba_t3_label',
              description: 'eba_t3_description',
              question: 'eba_t3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 4,
              required: false,
              unit: 'kg/m²',
              applicableTo: ['transporte'],
            ),
            // EBA-T4: Ayuno pre-transporte y agua en espera
            EvaluationField(
              id: 'eba_t4_pre_transport',
              label: 'eba_t4_label',
              description: 'eba_t4_description',
              question: 'eba_t4_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 4,
              required: false,
              applicableTo: ['transporte'],
            ),
          ],
        ),
        
        // ═══════════════════════════════════════════════════════════════
        // GRUPO 5: SACRIFICIO (Opcional según aplique)
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'slaughter',
          name: 'Indicadores de Sacrificio',
          nameKey: 'category_slaughter_pigs',
          icon: 'gavel',
          weight: 0.0, // No ponderado - evaluación adicional
          fields: [
            // EBA-S1: Resbalones y caídas
            EvaluationField(
              id: 'eba_s1_slips_falls',
              label: 'eba_s1_label',
              description: 'eba_s1_description',
              question: 'eba_s1_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['sacrificio'],
            ),
            // EBA-S2: Aturdimiento al primer intento
            EvaluationField(
              id: 'eba_s2_stunning_efficacy',
              label: 'eba_s2_label',
              description: 'eba_s2_description',
              question: 'eba_s2_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['sacrificio'],
            ),
            // EBA-S3: Parámetros del equipo
            EvaluationField(
              id: 'eba_s3_equipment_params',
              label: 'eba_s3_label',
              description: 'eba_s3_description',
              question: 'eba_s3_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 4,
              required: false,
              applicableTo: ['sacrificio'],
            ),
            // EBA-S4: Vocalizaciones
            EvaluationField(
              id: 'eba_s4_vocalizations',
              label: 'eba_s4_label',
              description: 'eba_s4_description',
              question: 'eba_s4_question',
              type: FieldType.scale0to4,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 4,
              required: false,
              applicableTo: ['sacrificio'],
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
  scale0to2,       // Escala ICA Aves: 0, 1, 2
  scale0to4,       // Escala EBA Porcinos: 0, 1, 2, 3, 4
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
