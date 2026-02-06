/// Traducciones de indicadores ICA para Aves de Corral
/// Este archivo contiene las traducciones de los indicadores según la metodología ICA
/// Agregarlo a app_localizations.dart

const Map<String, Map<String, String>> icaBirdsTranslations = {
  'es': {
    // ═══════════════════════════════════════════════════════════════
    // CATEGORÍAS
    // ═══════════════════════════════════════════════════════════════
    'category_resources': 'Medidas Basadas en los Recursos',
    'category_animal': 'Medidas Basadas en el Animal',
    'category_management': 'Medidas Basadas en la Gestión',

    // ═══════════════════════════════════════════════════════════════
    // MEDIDAS BASADAS EN LOS RECURSOS (35%)
    // ═══════════════════════════════════════════════════════════════

    // 7.2. Medición de partículas suspendidas en el aire
    'air_particles_label': 'Partículas suspendidas en el aire',
    'air_particles_question': '¿Cuál es el nivel de saturación de partículas en el aire?',
    'air_particles_description': 'Al interior del galpón, se fijan hojas centinelas de color oscuro a una altura entre 1m y 1.50m del suelo. Se evalúa el nivel de polvo según los rastros en el dedo.',
    'air_particles_0': 'Alto nivel de partículas (dedo muy sucio)',
    'air_particles_1': 'Nivel moderado de partículas',
    'air_particles_2': 'Bajo nivel de partículas (dedo limpio o casi limpio)',

    // 7.3. Calidad de la cama
    'bedding_quality_label': 'Calidad de la cama',
    'bedding_quality_question': '¿La calidad de la cama es adecuada?',
    'bedding_quality_description': 'Se toma un puñado de cama, se comprime con fuerza y se observa la respuesta de compactación.',
    'bedding_quality_0': 'Cama muy húmeda o compactada, mal estado',
    'bedding_quality_1': 'Cama en condiciones moderadas',
    'bedding_quality_2': 'Cama seca, suelta y en buen estado',

    // 7.5. Calidad de los bebederos
    'drinker_quality_label': 'Calidad de los bebederos',
    'drinker_quality_question': '¿Las aves tienen acceso suficiente al agua?',
    'drinker_quality_description': 'Se verifica la presión y flujo del agua para que llegue rápido y en volumen necesario.',
    'drinker_quality_0': 'Bebederos en mal estado o sin agua',
    'drinker_quality_1': 'Bebederos funcionales con flujo irregular',
    'drinker_quality_2': 'Bebederos en buen estado con flujo adecuado',

    // 7.6. Suministro de agua en los bebederos
    'water_supply_label': 'Suministro de agua',
    'water_supply_question': '¿El suministro de agua en los bebederos es adecuado?',
    'water_supply_description': 'Se verifica que el agua llegue rápido y en el volumen necesario para que el animal pueda beber cómodamente.',
    'water_supply_0': 'Suministro deficiente o nulo',
    'water_supply_1': 'Suministro parcial o irregular',
    'water_supply_2': 'Suministro constante y adecuado',

    // 7.7. Animales por bebedero
    'animals_per_drinker_label': 'Animales por bebedero',
    'animals_per_drinker_question': '¿La relación animales/bebedero es adecuada?',
    'animals_per_drinker_description': 'Se verifica si existe un protocolo implementado para el tratamiento del agua y la relación de animales por bebedero.',
    'animals_per_drinker_0': 'Muy pocos bebederos para la cantidad de animales',
    'animals_per_drinker_1': 'Relación moderada pero mejorable',
    'animals_per_drinker_2': 'Relación óptima de animales por bebedero',

    // 7.8. Tratamiento del agua
    'water_treatment_label': 'Tratamiento del agua',
    'water_treatment_question': '¿Existe protocolo de tratamiento de agua y está implementado?',
    'water_treatment_description': 'Se verifica existencia de protocolo, infraestructura operativa y recursos materiales para el tratamiento del agua.',
    'water_treatment_0': 'No existe protocolo ni tratamiento',
    'water_treatment_1': 'Existe protocolo pero implementación parcial',
    'water_treatment_2': 'Protocolo implementado y funcional',

    // 7.9. Calidad de los comederos
    'feeder_quality_label': 'Calidad de los comederos',
    'feeder_quality_question': '¿El estado de mantenimiento y altura de los comederos es adecuado?',
    'feeder_quality_description': 'Se verifica el estado de mantenimiento y altura del comedero con respecto a la altura del ave.',
    'feeder_quality_0': 'Comederos en mal estado o altura inadecuada',
    'feeder_quality_1': 'Comederos funcionales con algunas deficiencias',
    'feeder_quality_2': 'Comederos en buen estado y altura adecuada',

    // 7.10. Animales por comedero
    'animals_per_feeder_label': 'Animales por comedero',
    'animals_per_feeder_question': '¿Los comederos garantizan el acceso a todos los animales existentes?',
    'animals_per_feeder_description': 'Se verifica la relación entre el número de animales alojados y el número de comederos disponibles.',
    'animals_per_feeder_0': 'Insuficientes comederos, alta competencia',
    'animals_per_feeder_1': 'Relación moderada pero mejorable',
    'animals_per_feeder_2': 'Suficientes comederos para todos los animales',

    // 7.11. Medios para contribuir al confort térmico
    'thermal_comfort_label': 'Confort térmico',
    'thermal_comfort_question': '¿Existen medios para contribuir al confort térmico de los animales?',
    'thermal_comfort_description': 'Se verifica si existen medios funcionales para mantener el confort térmico (ventiladores, cortinas, nebulizadores, etc.).',
    'thermal_comfort_0': 'No existen medios para confort térmico',
    'thermal_comfort_1': 'Existen medios pero con funcionamiento parcial',
    'thermal_comfort_2': 'Medios funcionales y adecuados',

    // 7.12. Calidad, integridad y funcionalidad del nidal
    'nest_quality_label': 'Calidad del nidal',
    'nest_quality_question': '¿Los nidales se encuentran íntegros y funcionales para estimular la ovoposición?',
    'nest_quality_description': 'Se verifica integridad, deterioro del material, presencia de perchas y cama en los nidales.',
    'nest_quality_0': 'Nidales en mal estado o inexistentes',
    'nest_quality_1': 'Nidales funcionales con algunas deficiencias',
    'nest_quality_2': 'Nidales íntegros y completamente funcionales',

    // 7.14. Espacio disponible
    'available_space_label': 'Espacio disponible',
    'available_space_question': '¿Cuál es el espacio disponible para las aves?',
    'available_space_description': 'Se cuantifica el espacio disponible medido como el número de animales por m².',
    'available_space_0': 'Espacio muy reducido, alta densidad',
    'available_space_1': 'Espacio moderado pero mejorable',
    'available_space_2': 'Espacio adecuado según normativa',

    // ═══════════════════════════════════════════════════════════════
    // MEDIDAS BASADAS EN EL ANIMAL (35%)
    // ═══════════════════════════════════════════════════════════════

    // 8.1. Jadeo
    'panting_label': 'Jadeo',
    'panting_question': '¿Las aves presentan jadeo?',
    'panting_description': 'El jadeo es un mecanismo de disipación de calor. Su presencia a largo plazo indica estrés térmico crónico.',
    'panting_0': 'Alto porcentaje de aves con jadeo',
    'panting_1': 'Porcentaje moderado de aves con jadeo',
    'panting_2': 'Ninguna o muy pocas aves con jadeo',

    // 8.2. Acurrucarse en grupos (amontonamiento)
    'huddling_label': 'Amontonamiento',
    'huddling_question': '¿Las aves presentan amontonamiento?',
    'huddling_description': 'Se evalúa si hay amontonamiento en grupos, lo cual indica problemas de temperatura o espacio.',
    'huddling_0': 'Amontonamiento severo',
    'huddling_1': 'Amontonamiento moderado',
    'huddling_2': 'Sin amontonamiento, distribución normal',

    // 8.3. Integridad del hueso de la quilla
    'keel_bone_integrity_label': 'Integridad del hueso de la quilla',
    'keel_bone_integrity_question': '¿Cuál es el nivel de daño en aves con evidencia de deformidades o desviación en el hueso de la quilla?',
    'keel_bone_integrity_description': 'Se toma la gallina y se expone la región ventral para verificar deformidades en el hueso de la quilla.',
    'keel_bone_integrity_0': 'Alto porcentaje con deformidades severas',
    'keel_bone_integrity_1': 'Porcentaje moderado con deformidades',
    'keel_bone_integrity_2': 'Ninguna o mínima presencia de deformidades',

    // 8.4. Pododermatitis
    'pododermatitis_label': 'Pododermatitis',
    'pododermatitis_question': '¿Las aves presentan pododermatitis y qué nivel de afectación tienen?',
    'pododermatitis_description': 'Se examinan las almohadillas plantares de ambas patas para detectar lesiones o abscesos.',
    'pododermatitis_0': 'Alto porcentaje con lesiones severas',
    'pododermatitis_1': 'Porcentaje moderado con lesiones leves',
    'pododermatitis_2': 'Ninguna o mínima presencia de pododermatitis',

    // 8.5. Daño en los dedos
    'toe_damage_label': 'Daño en los dedos',
    'toe_damage_question': '¿Qué nivel de daño hay en los dedos de los animales?',
    'toe_damage_description': 'Se examinan ambas patas para detectar daños en los dedos, indicador de calidad de cama o jaula.',
    'toe_damage_0': 'Alto porcentaje con daños severos',
    'toe_damage_1': 'Porcentaje moderado con daños leves',
    'toe_damage_2': 'Ningún o mínimo daño en dedos',

    // 8.7. Lesiones en piel y/o otros tegumentos
    'skin_lesions_label': 'Lesiones en piel',
    'skin_lesions_question': '¿Se observan lesiones en piel y/u otros tegumentos?',
    'skin_lesions_description': 'Se verifica el nivel de daño por lesiones en la piel incluida la cresta, barbilla y posible prolapso de cloaca.',
    'skin_lesions_0': 'Alto porcentaje con lesiones severas',
    'skin_lesions_1': 'Porcentaje moderado con lesiones leves',
    'skin_lesions_2': 'Ninguna o mínimas lesiones',

    // 8.8. Suciedad y apariencia del plumaje
    'plumage_condition_label': 'Condición del plumaje',
    'plumage_condition_question': '¿Cuál es la apariencia y el estado de suciedad del plumaje de las aves?',
    'plumage_condition_description': 'Se examina visualmente las regiones dorsal y ventral del plumaje.',
    'plumage_condition_0': 'Plumaje muy sucio o dañado',
    'plumage_condition_1': 'Plumaje con suciedad o daño moderado',
    'plumage_condition_2': 'Plumaje limpio y en buen estado',

    // 8.9. Integridad óculo-nasal
    'ocular_nasal_integrity_label': 'Integridad óculo-nasal',
    'ocular_nasal_integrity_question': '¿Cuántos animales se observan con descarga nasal y/u ocular, o con lesiones agudas o crónicas en estas áreas anatómicas?',
    'ocular_nasal_integrity_description': 'Se verifican animales con descarga nasal y/o ocular, o con lesiones en estas áreas.',
    'ocular_nasal_integrity_0': 'Alto porcentaje con problemas óculo-nasales',
    'ocular_nasal_integrity_1': 'Porcentaje moderado con problemas',
    'ocular_nasal_integrity_2': 'Ninguno o mínimos problemas óculo-nasales',

    // 8.10. Condición del pico
    'beak_condition_label': 'Condición del pico',
    'beak_condition_question': '¿Se realiza corrección de pico? ¿Cuál es el nivel de daño asociado a la condición del pico?',
    'beak_condition_description': 'Se verifica si se realiza corrección del pico y el estado general de este.',
    'beak_condition_0': 'Corrección agresiva o daños severos',
    'beak_condition_1': 'Corrección moderada o daños leves',
    'beak_condition_2': 'Sin corrección o corrección mínima adecuada',

    // 8.11. Mortalidad
    'mortality_label': 'Mortalidad',
    'mortality_question': '¿Cuál es la tasa de mortalidad acumulada?',
    'mortality_description': 'Se verifica el registro de mortalidad acumulada de los últimos 5 ciclos de la granja.',
    'mortality_0': 'Tasa de mortalidad alta (superior al estándar)',
    'mortality_1': 'Tasa de mortalidad moderada',
    'mortality_2': 'Tasa de mortalidad baja (dentro del estándar)',

    // ═══════════════════════════════════════════════════════════════
    // MEDIDAS BASADAS EN LA GESTIÓN (30%)
    // ═══════════════════════════════════════════════════════════════

    // 9.1. Calidad del agua
    'water_quality_label': 'Calidad del agua',
    'water_quality_question': '¿Las aves cuentan con agua de calidad para su consumo?',
    'water_quality_description': 'Se verifica existencia y periodicidad de análisis de laboratorio (fisicoquímico, microbiológico) del agua de bebida.',
    'water_quality_0': 'No hay análisis de calidad de agua',
    'water_quality_1': 'Análisis esporádicos o incompletos',
    'water_quality_2': 'Análisis periódicos y completos documentados',

    // 9.2. Alimentación equilibrada
    'balanced_feeding_label': 'Alimentación equilibrada',
    'balanced_feeding_question': '¿Las aves cuentan con alimentación equilibrada?',
    'balanced_feeding_description': 'Se verifica que la alimentación sea adecuada en formulación, ingredientes y presentación según necesidades fisiológicas.',
    'balanced_feeding_0': 'No hay documentación de formulación',
    'balanced_feeding_1': 'Documentación parcial o desactualizada',
    'balanced_feeding_2': 'Formulación documentada y adecuada',

    // 9.3. Programas de vigilancia y gestión sanitaria
    'health_surveillance_label': 'Vigilancia sanitaria',
    'health_surveillance_question': '¿Existe participación en el cumplimiento de las medidas de bioseguridad y en la prevención, control y erradicación de enfermedades establecidos por el ICA?',
    'health_surveillance_description': 'Se verifica evidencia de participación en programas de vigilancia y gestión sanitaria del ICA.',
    'health_surveillance_0': 'No hay participación en programas ICA',
    'health_surveillance_1': 'Participación parcial en programas',
    'health_surveillance_2': 'Participación completa y documentada',

    // 9.4. Procedimiento Operativo Estandarizado (POE-Bienestar animal)
    'poe_animal_welfare_label': 'POE de Bienestar Animal',
    'poe_animal_welfare_question': '¿La granja cuenta con el POE de bienestar animal o la inclusión de un capítulo de bienestar animal dentro de un POE ya existente?',
    'poe_animal_welfare_description': 'Se verifica el POE que incluye plan de vacunación, densidades, manejo y gestión de las aves.',
    'poe_animal_welfare_0': 'No existe POE de bienestar animal',
    'poe_animal_welfare_1': 'POE incompleto o desactualizado',
    'poe_animal_welfare_2': 'POE completo e implementado',

    // 9.5. Condiciones térmicas diarias y manejo de emergencias
    'thermal_emergency_label': 'Manejo de emergencias térmicas',
    'thermal_emergency_question': '¿Se realiza un monitoreo diario y existe un protocolo de procedimientos de emergencia?',
    'thermal_emergency_description': 'Se verifica existencia de protocolo para cambios abruptos de temperatura y emergencias térmicas.',
    'thermal_emergency_0': 'No existe protocolo de emergencias',
    'thermal_emergency_1': 'Protocolo existe pero incompleto',
    'thermal_emergency_2': 'Protocolo completo e implementado',

    // 9.6. Programa de iluminación
    'lighting_program_label': 'Programa de iluminación',
    'lighting_program_question': '¿Existe un programa de manejo del régimen de luz/oscuridad?',
    'lighting_program_description': 'Se verifica existencia de programa de manejo del régimen de luz/oscuridad a lo largo del ciclo productivo.',
    'lighting_program_0': 'No existe programa de iluminación',
    'lighting_program_1': 'Programa existe pero incompleto',
    'lighting_program_2': 'Programa completo e implementado',

    // 9.7. Capacitación básica en bienestar animal
    'welfare_training_label': 'Capacitación en bienestar animal',
    'welfare_training_question': '¿El personal que maneja las aves cuenta con constancia de aprobación del curso en bienestar animal?',
    'welfare_training_description': 'Se verifica la constancia del curso en bienestar animal del personal que maneja las aves.',
    'welfare_training_0': 'Personal sin capacitación',
    'welfare_training_1': 'Capacitación parcial del personal',
    'welfare_training_2': 'Todo el personal capacitado y certificado',

    // 9.8. Protocolo de sacrificio humanitario o eutanasia
    'euthanasia_protocol_label': 'Protocolo de eutanasia',
    'euthanasia_protocol_question': '¿Existe protocolo de sacrificio humanitario o eutanasia?',
    'euthanasia_protocol_description': 'Se verifica existencia de protocolo documentado para sacrificio humanitario o eutanasia.',
    'euthanasia_protocol_0': 'No existe protocolo de eutanasia',
    'euthanasia_protocol_1': 'Protocolo existe pero incompleto',
    'euthanasia_protocol_2': 'Protocolo completo e implementado',

    // 9.9. Capacitación en técnicas de sacrificio humanitario
    'euthanasia_training_label': 'Capacitación en eutanasia',
    'euthanasia_training_question': '¿El personal cuenta con capacitación en técnicas de sacrificio humanitario o eutanasia?',
    'euthanasia_training_description': 'Se verifica que el personal esté capacitado en técnicas de sacrificio humanitario.',
    'euthanasia_training_0': 'Personal sin capacitación en eutanasia',
    'euthanasia_training_1': 'Capacitación parcial',
    'euthanasia_training_2': 'Personal completamente capacitado',

    // 9.10. Uso responsable de medicamentos e insumos veterinarios
    'responsible_medication_label': 'Uso responsable de medicamentos',
    'responsible_medication_question': '¿Se realiza uso responsable de medicamentos e insumos veterinarios?',
    'responsible_medication_description': 'Se verifica el uso adecuado y documentado de medicamentos e insumos veterinarios.',
    'responsible_medication_0': 'No hay control de medicamentos',
    'responsible_medication_1': 'Control parcial documentado',
    'responsible_medication_2': 'Control completo y uso responsable documentado',

    // ═══════════════════════════════════════════════════════════════
    // ESCALA GENERAL
    // ═══════════════════════════════════════════════════════════════
    'scale_0': 'No cumple (0)',
    'scale_1': 'Cumple parcialmente (1)',
    'scale_2': 'Cumple totalmente (2)',

    // Clasificaciones de bienestar
    'welfare_excellent': 'GRANJA CON EXCELENTE BIENESTAR',
    'welfare_excellent_desc': 'Puntaje obtenido superior al 90%',
    'welfare_high': 'GRANJA CON ALTO BIENESTAR',
    'welfare_high_desc': 'Puntaje obtenido entre 76% y 90%',
    'welfare_medium': 'GRANJA CON MEDIO BIENESTAR',
    'welfare_medium_desc': 'Puntaje obtenido entre 50% y 75%',
    'welfare_low': 'GRANJA CON BAJO BIENESTAR',
    'welfare_low_desc': 'Puntaje obtenido inferior al 50%',

    // Métodos de evaluación
    'method_visual_sampling': 'Inspección visual con muestreo',
    'method_visual_no_sampling': 'Inspección visual sin muestreo',
    'method_document': 'Inspección documental',
    'method_visual_document': 'Inspección visual y documental',

    // Tipos de granja
    'farm_type_pollo_engorde': 'Pollo de engorde',
    'farm_type_ponedoras_piso': 'Ponedoras en piso',
    'farm_type_ponedoras_jaula': 'Ponedoras en jaula',
    'farm_type_pastoreo': 'Pastoreo',
  },

  'en': {
    // ═══════════════════════════════════════════════════════════════
    // CATEGORIES
    // ═══════════════════════════════════════════════════════════════
    'category_resources': 'Resource-Based Measures',
    'category_animal': 'Animal-Based Measures',
    'category_management': 'Management-Based Measures',

    // ═══════════════════════════════════════════════════════════════
    // RESOURCE-BASED MEASURES (35%)
    // ═══════════════════════════════════════════════════════════════

    // 7.2. Air particle measurement
    'air_particles_label': 'Suspended air particles',
    'air_particles_question': 'What is the level of particle saturation in the air?',
    'air_particles_description': 'Inside the barn, dark sentinel sheets are placed at a height between 1m and 1.50m. Dust level is evaluated according to finger traces.',
    'air_particles_0': 'High particle level (very dirty finger)',
    'air_particles_1': 'Moderate particle level',
    'air_particles_2': 'Low particle level (clean or almost clean finger)',

    // 7.3. Bedding quality
    'bedding_quality_label': 'Bedding quality',
    'bedding_quality_question': 'Is the bedding quality adequate?',
    'bedding_quality_description': 'A handful of bedding is taken, compressed firmly, and compaction response is observed.',
    'bedding_quality_0': 'Very wet or compacted bedding, poor condition',
    'bedding_quality_1': 'Bedding in moderate conditions',
    'bedding_quality_2': 'Dry, loose bedding in good condition',

    // 7.5. Drinker quality
    'drinker_quality_label': 'Drinker quality',
    'drinker_quality_question': 'Do birds have sufficient access to water?',
    'drinker_quality_description': 'Water pressure and flow are verified to ensure it arrives quickly and in necessary volume.',
    'drinker_quality_0': 'Drinkers in poor condition or without water',
    'drinker_quality_1': 'Functional drinkers with irregular flow',
    'drinker_quality_2': 'Drinkers in good condition with adequate flow',

    // 7.6. Water supply
    'water_supply_label': 'Water supply',
    'water_supply_question': 'Is the water supply in drinkers adequate?',
    'water_supply_description': 'Verify that water arrives quickly and in the necessary volume for comfortable drinking.',
    'water_supply_0': 'Deficient or no supply',
    'water_supply_1': 'Partial or irregular supply',
    'water_supply_2': 'Constant and adequate supply',

    // 7.7. Animals per drinker
    'animals_per_drinker_label': 'Animals per drinker',
    'animals_per_drinker_question': 'Is the animals/drinker ratio adequate?',
    'animals_per_drinker_description': 'Verify if there is an implemented protocol for water treatment and the ratio of animals per drinker.',
    'animals_per_drinker_0': 'Too few drinkers for the number of animals',
    'animals_per_drinker_1': 'Moderate but improvable ratio',
    'animals_per_drinker_2': 'Optimal ratio of animals per drinker',

    // 7.8. Water treatment
    'water_treatment_label': 'Water treatment',
    'water_treatment_question': 'Is there a water treatment protocol and is it implemented?',
    'water_treatment_description': 'Verify existence of protocol, operative infrastructure and material resources for water treatment.',
    'water_treatment_0': 'No protocol or treatment exists',
    'water_treatment_1': 'Protocol exists but partial implementation',
    'water_treatment_2': 'Protocol implemented and functional',

    // 7.9. Feeder quality
    'feeder_quality_label': 'Feeder quality',
    'feeder_quality_question': 'Is the maintenance condition and height of feeders adequate?',
    'feeder_quality_description': 'Verify maintenance condition and feeder height relative to bird height.',
    'feeder_quality_0': 'Feeders in poor condition or inadequate height',
    'feeder_quality_1': 'Functional feeders with some deficiencies',
    'feeder_quality_2': 'Feeders in good condition and adequate height',

    // 7.10. Animals per feeder
    'animals_per_feeder_label': 'Animals per feeder',
    'animals_per_feeder_question': 'Do feeders guarantee access to all existing animals?',
    'animals_per_feeder_description': 'Verify the ratio between housed animals and available feeders.',
    'animals_per_feeder_0': 'Insufficient feeders, high competition',
    'animals_per_feeder_1': 'Moderate but improvable ratio',
    'animals_per_feeder_2': 'Sufficient feeders for all animals',

    // 7.11. Thermal comfort means
    'thermal_comfort_label': 'Thermal comfort',
    'thermal_comfort_question': 'Are there means to contribute to animal thermal comfort?',
    'thermal_comfort_description': 'Verify if functional means exist to maintain thermal comfort (fans, curtains, foggers, etc.).',
    'thermal_comfort_0': 'No thermal comfort means exist',
    'thermal_comfort_1': 'Means exist but partial functionality',
    'thermal_comfort_2': 'Functional and adequate means',

    // 7.12. Nest quality
    'nest_quality_label': 'Nest quality',
    'nest_quality_question': 'Are nests intact and functional to stimulate oviposition?',
    'nest_quality_description': 'Verify integrity, material deterioration, presence of perches and bedding in nests.',
    'nest_quality_0': 'Nests in poor condition or non-existent',
    'nest_quality_1': 'Functional nests with some deficiencies',
    'nest_quality_2': 'Intact and fully functional nests',

    // 7.14. Available space
    'available_space_label': 'Available space',
    'available_space_question': 'What is the available space for birds?',
    'available_space_description': 'Space is quantified as the number of animals per m².',
    'available_space_0': 'Very reduced space, high density',
    'available_space_1': 'Moderate but improvable space',
    'available_space_2': 'Adequate space according to regulations',

    // ═══════════════════════════════════════════════════════════════
    // ANIMAL-BASED MEASURES (35%)
    // ═══════════════════════════════════════════════════════════════

    // 8.1. Panting
    'panting_label': 'Panting',
    'panting_question': 'Do birds show panting?',
    'panting_description': 'Panting is a heat dissipation mechanism. Long-term presence indicates chronic thermal stress.',
    'panting_0': 'High percentage of birds panting',
    'panting_1': 'Moderate percentage of birds panting',
    'panting_2': 'No or very few birds panting',

    // 8.2. Huddling
    'huddling_label': 'Huddling',
    'huddling_question': 'Do birds show huddling?',
    'huddling_description': 'Evaluate if there is group huddling, which indicates temperature or space problems.',
    'huddling_0': 'Severe huddling',
    'huddling_1': 'Moderate huddling',
    'huddling_2': 'No huddling, normal distribution',

    // 8.3. Keel bone integrity
    'keel_bone_integrity_label': 'Keel bone integrity',
    'keel_bone_integrity_question': 'What is the damage level in birds with evidence of keel bone deformities or deviation?',
    'keel_bone_integrity_description': 'The hen is held and the ventral region is exposed to verify keel bone deformities.',
    'keel_bone_integrity_0': 'High percentage with severe deformities',
    'keel_bone_integrity_1': 'Moderate percentage with deformities',
    'keel_bone_integrity_2': 'No or minimal deformities present',

    // 8.4. Pododermatitis
    'pododermatitis_label': 'Pododermatitis',
    'pododermatitis_question': 'Do birds present pododermatitis and what is the level of affectation?',
    'pododermatitis_description': 'Both foot pads are examined for lesions or abscesses.',
    'pododermatitis_0': 'High percentage with severe lesions',
    'pododermatitis_1': 'Moderate percentage with mild lesions',
    'pododermatitis_2': 'No or minimal pododermatitis present',

    // 8.5. Toe damage
    'toe_damage_label': 'Toe damage',
    'toe_damage_question': 'What level of damage is there in animal toes?',
    'toe_damage_description': 'Both feet are examined for toe damage, indicator of bedding or cage quality.',
    'toe_damage_0': 'High percentage with severe damage',
    'toe_damage_1': 'Moderate percentage with mild damage',
    'toe_damage_2': 'No or minimal toe damage',

    // 8.7. Skin lesions
    'skin_lesions_label': 'Skin lesions',
    'skin_lesions_question': 'Are skin lesions and/or other integument lesions observed?',
    'skin_lesions_description': 'Verify damage level from skin lesions including comb, wattle and possible cloacal prolapse.',
    'skin_lesions_0': 'High percentage with severe lesions',
    'skin_lesions_1': 'Moderate percentage with mild lesions',
    'skin_lesions_2': 'No or minimal lesions',

    // 8.8. Plumage condition
    'plumage_condition_label': 'Plumage condition',
    'plumage_condition_question': 'What is the appearance and dirtiness state of bird plumage?',
    'plumage_condition_description': 'Visually examine dorsal and ventral plumage regions.',
    'plumage_condition_0': 'Very dirty or damaged plumage',
    'plumage_condition_1': 'Plumage with moderate dirt or damage',
    'plumage_condition_2': 'Clean plumage in good condition',

    // 8.9. Ocular-nasal integrity
    'ocular_nasal_integrity_label': 'Ocular-nasal integrity',
    'ocular_nasal_integrity_question': 'How many animals are observed with nasal and/or ocular discharge, or with acute or chronic lesions in these anatomical areas?',
    'ocular_nasal_integrity_description': 'Verify animals with nasal and/or ocular discharge, or with lesions in these areas.',
    'ocular_nasal_integrity_0': 'High percentage with ocular-nasal problems',
    'ocular_nasal_integrity_1': 'Moderate percentage with problems',
    'ocular_nasal_integrity_2': 'No or minimal ocular-nasal problems',

    // 8.10. Beak condition
    'beak_condition_label': 'Beak condition',
    'beak_condition_question': 'Is beak trimming performed? What is the damage level associated with beak condition?',
    'beak_condition_description': 'Verify if beak trimming is performed and the general beak condition.',
    'beak_condition_0': 'Aggressive trimming or severe damage',
    'beak_condition_1': 'Moderate trimming or mild damage',
    'beak_condition_2': 'No trimming or minimal adequate trimming',

    // 8.11. Mortality
    'mortality_label': 'Mortality',
    'mortality_question': 'What is the accumulated mortality rate?',
    'mortality_description': 'Verify accumulated mortality records from the last 5 farm cycles.',
    'mortality_0': 'High mortality rate (above standard)',
    'mortality_1': 'Moderate mortality rate',
    'mortality_2': 'Low mortality rate (within standard)',

    // ═══════════════════════════════════════════════════════════════
    // MANAGEMENT-BASED MEASURES (30%)
    // ═══════════════════════════════════════════════════════════════

    // 9.1. Water quality
    'water_quality_label': 'Water quality',
    'water_quality_question': 'Do birds have quality water for consumption?',
    'water_quality_description': 'Verify existence and frequency of laboratory analysis (physicochemical, microbiological) of drinking water.',
    'water_quality_0': 'No water quality analysis',
    'water_quality_1': 'Sporadic or incomplete analysis',
    'water_quality_2': 'Periodic and complete documented analysis',

    // 9.2. Balanced feeding
    'balanced_feeding_label': 'Balanced feeding',
    'balanced_feeding_question': 'Do birds have balanced feeding?',
    'balanced_feeding_description': 'Verify that feeding is adequate in formulation, ingredients and presentation according to physiological needs.',
    'balanced_feeding_0': 'No formulation documentation',
    'balanced_feeding_1': 'Partial or outdated documentation',
    'balanced_feeding_2': 'Documented and adequate formulation',

    // 9.3. Health surveillance programs
    'health_surveillance_label': 'Health surveillance',
    'health_surveillance_question': 'Is there participation in compliance with biosecurity measures and prevention, control and eradication of diseases established by ICA?',
    'health_surveillance_description': 'Verify evidence of participation in ICA surveillance and health management programs.',
    'health_surveillance_0': 'No participation in ICA programs',
    'health_surveillance_1': 'Partial participation in programs',
    'health_surveillance_2': 'Complete and documented participation',

    // 9.4. Standard Operating Procedure (SOP-Animal Welfare)
    'poe_animal_welfare_label': 'Animal Welfare SOP',
    'poe_animal_welfare_question': 'Does the farm have an animal welfare SOP or inclusion of an animal welfare chapter within an existing SOP?',
    'poe_animal_welfare_description': 'Verify SOP that includes vaccination plan, densities, bird handling and management.',
    'poe_animal_welfare_0': 'No animal welfare SOP exists',
    'poe_animal_welfare_1': 'Incomplete or outdated SOP',
    'poe_animal_welfare_2': 'Complete and implemented SOP',

    // 9.5. Daily thermal conditions and emergency management
    'thermal_emergency_label': 'Thermal emergency management',
    'thermal_emergency_question': 'Is daily monitoring performed and is there an emergency procedures protocol?',
    'thermal_emergency_description': 'Verify existence of protocol for abrupt temperature changes and thermal emergencies.',
    'thermal_emergency_0': 'No emergency protocol exists',
    'thermal_emergency_1': 'Protocol exists but incomplete',
    'thermal_emergency_2': 'Complete and implemented protocol',

    // 9.6. Lighting program
    'lighting_program_label': 'Lighting program',
    'lighting_program_question': 'Is there a light/darkness regime management program?',
    'lighting_program_description': 'Verify existence of light/darkness regime management program throughout the productive cycle.',
    'lighting_program_0': 'No lighting program exists',
    'lighting_program_1': 'Program exists but incomplete',
    'lighting_program_2': 'Complete and implemented program',

    // 9.7. Basic animal welfare training
    'welfare_training_label': 'Animal welfare training',
    'welfare_training_question': 'Does personnel handling birds have proof of approval of the animal welfare course?',
    'welfare_training_description': 'Verify animal welfare course certificate for personnel handling birds.',
    'welfare_training_0': 'Untrained personnel',
    'welfare_training_1': 'Partial personnel training',
    'welfare_training_2': 'All personnel trained and certified',

    // 9.8. Humane slaughter or euthanasia protocol
    'euthanasia_protocol_label': 'Euthanasia protocol',
    'euthanasia_protocol_question': 'Is there a humane slaughter or euthanasia protocol?',
    'euthanasia_protocol_description': 'Verify existence of documented protocol for humane slaughter or euthanasia.',
    'euthanasia_protocol_0': 'No euthanasia protocol exists',
    'euthanasia_protocol_1': 'Protocol exists but incomplete',
    'euthanasia_protocol_2': 'Complete and implemented protocol',

    // 9.9. Humane slaughter training
    'euthanasia_training_label': 'Euthanasia training',
    'euthanasia_training_question': 'Does personnel have training in humane slaughter or euthanasia techniques?',
    'euthanasia_training_description': 'Verify that personnel is trained in humane slaughter techniques.',
    'euthanasia_training_0': 'Personnel without euthanasia training',
    'euthanasia_training_1': 'Partial training',
    'euthanasia_training_2': 'Fully trained personnel',

    // 9.10. Responsible use of medications and veterinary supplies
    'responsible_medication_label': 'Responsible medication use',
    'responsible_medication_question': 'Is there responsible use of medications and veterinary supplies?',
    'responsible_medication_description': 'Verify adequate and documented use of medications and veterinary supplies.',
    'responsible_medication_0': 'No medication control',
    'responsible_medication_1': 'Partial documented control',
    'responsible_medication_2': 'Complete control and documented responsible use',

    // ═══════════════════════════════════════════════════════════════
    // GENERAL SCALE
    // ═══════════════════════════════════════════════════════════════
    'scale_0': 'Does not comply (0)',
    'scale_1': 'Partially complies (1)',
    'scale_2': 'Fully complies (2)',

    // Welfare classifications
    'welfare_excellent': 'FARM WITH EXCELLENT WELFARE',
    'welfare_excellent_desc': 'Score obtained above 90%',
    'welfare_high': 'FARM WITH HIGH WELFARE',
    'welfare_high_desc': 'Score obtained between 76% and 90%',
    'welfare_medium': 'FARM WITH MEDIUM WELFARE',
    'welfare_medium_desc': 'Score obtained between 50% and 75%',
    'welfare_low': 'FARM WITH LOW WELFARE',
    'welfare_low_desc': 'Score obtained below 50%',

    // Evaluation methods
    'method_visual_sampling': 'Visual inspection with sampling',
    'method_visual_no_sampling': 'Visual inspection without sampling',
    'method_document': 'Document inspection',
    'method_visual_document': 'Visual and document inspection',

    // Farm types
    'farm_type_pollo_engorde': 'Broiler chicken',
    'farm_type_ponedoras_piso': 'Floor layers',
    'farm_type_ponedoras_jaula': 'Cage layers',
    'farm_type_pastoreo': 'Free range',
  },
};
