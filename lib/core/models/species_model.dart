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
  /// Sistema de producción: Ponedoras en piso
  /// 30 indicadores según Resolución 253 de 2020
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
            // 9.1. Mortalidad
            EvaluationField(
              id: 'mortality',
              label: 'mortality_label',
              description: 'mortality_description',
              question: 'mortality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.2. Calidad del agua
            EvaluationField(
              id: 'water_quality',
              label: 'water_quality_label',
              description: 'water_quality_description',
              question: 'water_quality_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.3. Alimentación equilibrada
            EvaluationField(
              id: 'balanced_feeding',
              label: 'balanced_feeding_label',
              description: 'balanced_feeding_description',
              question: 'balanced_feeding_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.4. Programas de vigilancia y gestión sanitaria
            EvaluationField(
              id: 'health_surveillance',
              label: 'health_surveillance_label',
              description: 'health_surveillance_description',
              question: 'health_surveillance_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.5. Procedimiento Operativo Estandarizado (POE-Bienestar animal)
            EvaluationField(
              id: 'poe_animal_welfare',
              label: 'poe_animal_welfare_label',
              description: 'poe_animal_welfare_description',
              question: 'poe_animal_welfare_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.6. Condiciones térmicas diarias y manejo de emergencias
            EvaluationField(
              id: 'thermal_emergency',
              label: 'thermal_emergency_label',
              description: 'thermal_emergency_description',
              question: 'thermal_emergency_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.7. Programa de iluminación
            EvaluationField(
              id: 'lighting_program',
              label: 'lighting_program_label',
              description: 'lighting_program_description',
              question: 'lighting_program_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.8. Capacitación básica en bienestar animal
            EvaluationField(
              id: 'welfare_training',
              label: 'welfare_training_label',
              description: 'welfare_training_description',
              question: 'welfare_training_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
            // 9.9. Uso responsable de medicamentos e insumos veterinarios
            EvaluationField(
              id: 'responsible_medication',
              label: 'responsible_medication_label',
              description: 'responsible_medication_description',
              question: 'responsible_medication_question',
              type: FieldType.scale0to2,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 2,
              required: true,
            ),
          ],
        ),
      ],
    );
  }


  /// Cerdos - Metodología EVA 4.0 (Evaluación de Bienestar Animal - ICA Colombia)
  /// 39 indicadores organizados en 3 categorías:
  /// - Medidas Basadas en los Recursos: 35% (18 indicadores)
  /// - Medidas Basadas en el Animal: 50% (14 indicadores)
  /// - Medidas Basadas en la Gestión: 15% (7 indicadores)
  /// 
  /// Escalas de calificación:
  /// - scaleEVA: 0, 20, 55, 80, 100 (según rangos porcentuales)
  /// - yesNo100: Sí=100, No=0
  /// 
  /// Clasificación del predio:
  /// - Excelente: ≥90%
  /// - Alto: 76%-89%
  /// - Medio: 50%-75%
  /// - Bajo: <50%
  static Species pigs() {
    return Species(
      id: 'pigs',
      name: 'Cerdo',
      namePlural: 'Cerdos',
      iconPath: 'assets/icons/cerdo.svg',
      gradientColors: ['0xFFE85D75', '0xFFD84A64'],
      categories: [
        // ═══════════════════════════════════════════════════════════════
        // MEDIDAS BASADAS EN LOS RECURSOS - 35% (18 indicadores)
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'resource',
          name: 'Medidas Basadas en los Recursos',
          nameKey: 'category_resource_pigs',
          icon: 'home_work',
          weight: 0.35,
          fields: [
            // R1: Estado de los comederos
            EvaluationField(
              id: 'eva_r1_feeder_condition',
              label: 'eva_r1_label',
              description: 'eva_r1_description',
              question: 'eva_r1_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R2: Limpieza de comederos
            EvaluationField(
              id: 'eva_r2_feeder_cleanliness',
              label: 'eva_r2_label',
              description: 'eva_r2_description',
              question: 'eva_r2_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R3: Acceso a agua
            EvaluationField(
              id: 'eva_r3_water_access',
              label: 'eva_r3_label',
              description: 'eva_r3_description',
              question: 'eva_r3_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R4: Estado de limpieza de bebederos
            EvaluationField(
              id: 'eva_r4_drinker_cleanliness',
              label: 'eva_r4_label',
              description: 'eva_r4_description',
              question: 'eva_r4_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R5: Altura de los bebederos
            EvaluationField(
              id: 'eva_r5_drinker_height',
              label: 'eva_r5_label',
              description: 'eva_r5_description',
              question: 'eva_r5_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R6: Disponibilidad de bebederos
            EvaluationField(
              id: 'eva_r6_drinker_availability',
              label: 'eva_r6_label',
              description: 'eva_r6_description',
              question: 'eva_r6_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R7: Protección contra condiciones ambientales
            EvaluationField(
              id: 'eva_r7_environmental_protection',
              label: 'eva_r7_label',
              description: 'eva_r7_description',
              question: 'eva_r7_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionNoSampling,
              maxScore: 100,
              required: true,
            ),
            // R8: Ventilación
            EvaluationField(
              id: 'eva_r8_ventilation',
              label: 'eva_r8_label',
              description: 'eva_r8_description',
              question: 'eva_r8_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R9: Superficie de descanso
            EvaluationField(
              id: 'eva_r9_resting_surface',
              label: 'eva_r9_label',
              description: 'eva_r9_description',
              question: 'eva_r9_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R10: Instalaciones para resguardo de lechones
            EvaluationField(
              id: 'eva_r10_piglet_shelter',
              label: 'eva_r10_label',
              description: 'eva_r10_description',
              question: 'eva_r10_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R11: Espacio disponible para cerdas en corral
            EvaluationField(
              id: 'eva_r11_sow_pen_space',
              label: 'eva_r11_label',
              description: 'eva_r11_description',
              question: 'eva_r11_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R12: Espacio disponible para cerdas en jaula
            EvaluationField(
              id: 'eva_r12_sow_cage_space',
              label: 'eva_r12_label',
              description: 'eva_r12_description',
              question: 'eva_r12_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R13: Jaulas de libre acceso para cerdas en grupos >40
            EvaluationField(
              id: 'eva_r13_free_access_cages',
              label: 'eva_r13_label',
              description: 'eva_r13_description',
              question: 'eva_r13_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R14: Jaulas adecuadas al tamaño de la cerda
            EvaluationField(
              id: 'eva_r14_cage_size',
              label: 'eva_r14_label',
              description: 'eva_r14_description',
              question: 'eva_r14_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R15: Espacio para machos reproductores
            EvaluationField(
              id: 'eva_r15_boar_space',
              label: 'eva_r15_label',
              description: 'eva_r15_description',
              question: 'eva_r15_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R16: Espacio disponible para precebo
            EvaluationField(
              id: 'eva_r16_nursery_space',
              label: 'eva_r16_label',
              description: 'eva_r16_description',
              question: 'eva_r16_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R17: Espacio disponible para levante y ceba
            EvaluationField(
              id: 'eva_r17_finishing_space',
              label: 'eva_r17_label',
              description: 'eva_r17_description',
              question: 'eva_r17_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // R18: Instalaciones para movilización y arreo
            EvaluationField(
              id: 'eva_r18_handling_facilities',
              label: 'eva_r18_label',
              description: 'eva_r18_description',
              question: 'eva_r18_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
          ],
        ),

        // ═══════════════════════════════════════════════════════════════
        // MEDIDAS BASADAS EN EL ANIMAL - 50% (14 indicadores)
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'animal',
          name: 'Medidas Basadas en el Animal',
          nameKey: 'category_animal_pigs',
          icon: 'pets',
          weight: 0.50,
          fields: [
            // A1: Condición corporal en hembras y machos
            EvaluationField(
              id: 'eva_a1_body_condition_adults',
              label: 'eva_a1_label',
              description: 'eva_a1_description',
              question: 'eva_a1_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A2: Condición corporal en precebo, levante y ceba
            EvaluationField(
              id: 'eva_a2_body_condition_growing',
              label: 'eva_a2_label',
              description: 'eva_a2_description',
              question: 'eva_a2_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A3: Cojeras
            EvaluationField(
              id: 'eva_a3_lameness',
              label: 'eva_a3_label',
              description: 'eva_a3_description',
              question: 'eva_a3_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A4: Jadeos
            EvaluationField(
              id: 'eva_a4_panting',
              label: 'eva_a4_label',
              description: 'eva_a4_description',
              question: 'eva_a4_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A5: Temblores y/o amontonamiento
            EvaluationField(
              id: 'eva_a5_shivering_huddling',
              label: 'eva_a5_label',
              description: 'eva_a5_description',
              question: 'eva_a5_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A6: Heridas graves en el cuerpo
            EvaluationField(
              id: 'eva_a6_severe_wounds',
              label: 'eva_a6_label',
              description: 'eva_a6_description',
              question: 'eva_a6_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A7: Enriquecimiento ambiental e interacción
            EvaluationField(
              id: 'eva_a7_enrichment',
              label: 'eva_a7_label',
              description: 'eva_a7_description',
              question: 'eva_a7_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A8: Relación humano-animal en hembras y machos
            EvaluationField(
              id: 'eva_a8_human_animal_adults',
              label: 'eva_a8_label',
              description: 'eva_a8_description',
              question: 'eva_a8_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A9: Relación humano-animal en levante y ceba
            EvaluationField(
              id: 'eva_a9_human_animal_growing',
              label: 'eva_a9_label',
              description: 'eva_a9_description',
              question: 'eva_a9_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A10: Identificación de animales
            EvaluationField(
              id: 'eva_a10_identification',
              label: 'eva_a10_label',
              description: 'eva_a10_description',
              question: 'eva_a10_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualInspectionWithSampling,
              maxScore: 100,
              required: true,
            ),
            // A11: Prácticas dolorosas - Descolmille
            EvaluationField(
              id: 'eva_a11_teeth_clipping',
              label: 'eva_a11_label',
              description: 'eva_a11_description',
              question: 'eva_a11_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
            // A12: Prácticas dolorosas - Descole
            EvaluationField(
              id: 'eva_a12_tail_docking',
              label: 'eva_a12_label',
              description: 'eva_a12_description',
              question: 'eva_a12_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
            // A13: Castración
            EvaluationField(
              id: 'eva_a13_castration',
              label: 'eva_a13_label',
              description: 'eva_a13_description',
              question: 'eva_a13_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
            // A14: Atención de animales enfermos
            EvaluationField(
              id: 'eva_a14_sick_animal_care',
              label: 'eva_a14_label',
              description: 'eva_a14_description',
              question: 'eva_a14_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
          ],
        ),

        // ═══════════════════════════════════════════════════════════════
        // MEDIDAS BASADAS EN LA GESTIÓN - 15% (7 indicadores)
        // ═══════════════════════════════════════════════════════════════
        EvaluationCategory(
          id: 'management',
          name: 'Medidas Basadas en la Gestión',
          nameKey: 'category_management_pigs',
          icon: 'assignment',
          weight: 0.15,
          fields: [
            // G1: Plan de contingencia para falta de agua y alimento
            EvaluationField(
              id: 'eva_g1_contingency_plan',
              label: 'eva_g1_label',
              description: 'eva_g1_description',
              question: 'eva_g1_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 100,
              required: true,
            ),
            // G2: Plan Sanitario
            EvaluationField(
              id: 'eva_g2_health_plan',
              label: 'eva_g2_label',
              description: 'eva_g2_description',
              question: 'eva_g2_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 100,
              required: true,
            ),
            // G3: Uso de medicamentos veterinarios
            EvaluationField(
              id: 'eva_g3_veterinary_medicines',
              label: 'eva_g3_label',
              description: 'eva_g3_description',
              question: 'eva_g3_question',
              type: FieldType.scaleEVA,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
            // G4: Registro de mortalidad
            EvaluationField(
              id: 'eva_g4_mortality_records',
              label: 'eva_g4_label',
              description: 'eva_g4_description',
              question: 'eva_g4_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 100,
              required: true,
            ),
            // G5: Intervenciones quirúrgicas
            EvaluationField(
              id: 'eva_g5_surgical_procedures',
              label: 'eva_g5_label',
              description: 'eva_g5_description',
              question: 'eva_g5_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
            // G6: Sacrificio humanitario
            EvaluationField(
              id: 'eva_g6_humane_slaughter',
              label: 'eva_g6_label',
              description: 'eva_g6_description',
              question: 'eva_g6_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.visualAndDocumental,
              maxScore: 100,
              required: true,
            ),
            // G7: Capacitación del personal
            EvaluationField(
              id: 'eva_g7_staff_training',
              label: 'eva_g7_label',
              description: 'eva_g7_description',
              question: 'eva_g7_question',
              type: FieldType.yesNo100,
              evaluationMethod: EvaluationMethod.documentInspection,
              maxScore: 100,
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
  scale0to2,       // Escala ICA Aves: 0, 1, 2
  scale0to4,       // Escala EBA antigua: 0, 1, 2, 3, 4
  scaleEVA,        // Escala EVA 4.0: 0, 20, 55, 80, 100
  yesNo100,        // Sí=100, No=0 (EVA 4.0)
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
