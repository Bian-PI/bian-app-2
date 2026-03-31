/// Traducciones para indicadores EVA 4.0 - Cerdos
/// Metodología oficial ICA Colombia
/// 39 indicadores: 18 Recursos, 14 Animal, 7 Gestión

const Map<String, Map<String, String>> evaPigsTranslations = {
  // ═══════════════════════════════════════════════════════════════
  // CATEGORÍAS
  // ═══════════════════════════════════════════════════════════════
  'category_resource_pigs': {
    'es': 'Medidas Basadas en los Recursos',
    'en': 'Resource-Based Measures',
  },
  'category_animal_pigs': {
    'es': 'Medidas Basadas en el Animal',
    'en': 'Animal-Based Measures',
  },
  'category_management_pigs': {
    'es': 'Medidas Basadas en la Gestión',
    'en': 'Management-Based Measures',
  },

  // ═══════════════════════════════════════════════════════════════
  // RECURSOS (R1-R18) - 35%
  // ═══════════════════════════════════════════════════════════════

  // R1: Estado de los comederos
  'eva_r1_label': {
    'es': 'Estado de los comederos',
    'en': 'Feeder condition',
  },
  'eva_r1_description': {
    'es': 'Se evalúa el estado y conservación de los comederos, no supone un riesgo para los animales (lesiones o heridas).',
    'en': 'Evaluates the condition and maintenance of feeders, ensuring they do not pose a risk to animals (injuries or wounds).',
  },
  'eva_r1_question': {
    'es': '¿El estado de los comederos no supone riesgo para los animales?',
    'en': 'Does the feeder condition pose no risk to animals?',
  },

  // R2: Limpieza de comederos
  'eva_r2_label': {
    'es': 'Limpieza de comederos',
    'en': 'Feeder cleanliness',
  },
  'eva_r2_description': {
    'es': 'Se verifica el estado de limpieza de los comederos, considerando que un comedero está limpio cuando no se observa presencia de heces, orina, moho y/o alimento fermentado.',
    'en': 'Verifies the cleanliness of feeders, considering a feeder clean when no feces, urine, mold, or fermented feed is observed.',
  },
  'eva_r2_question': {
    'es': '¿Los comederos se encuentran limpios?',
    'en': 'Are the feeders clean?',
  },

  // R3: Acceso a agua
  'eva_r3_label': {
    'es': 'Acceso a agua',
    'en': 'Water access',
  },
  'eva_r3_description': {
    'es': 'Se verifica que se cumple con los flujos mínimos establecidos. El flujo de los bebederos de chupo se considera correcto cuando cumple con los parámetros mínimos según el peso vivo de los animales.',
    'en': 'Verifies compliance with minimum flow rates. Nipple drinker flow is considered correct when meeting minimum parameters according to animal live weight.',
  },
  'eva_r3_question': {
    'es': '¿Los animales disponen de acceso permanente a suficiente cantidad de agua?',
    'en': 'Do animals have permanent access to sufficient water?',
  },

  // R4: Estado de limpieza de bebederos
  'eva_r4_label': {
    'es': 'Limpieza de bebederos',
    'en': 'Drinker cleanliness',
  },
  'eva_r4_description': {
    'es': 'Se verifica el estado de limpieza de los bebederos, considerando que está "limpio" cuando no se observa presencia de heces, orina, moho o alimento fermentado.',
    'en': 'Verifies drinker cleanliness, considering it clean when no feces, urine, mold, or fermented feed is observed.',
  },
  'eva_r4_question': {
    'es': '¿Los bebederos garantizan el acceso de agua en condiciones higiénicas?',
    'en': 'Do drinkers guarantee water access in hygienic conditions?',
  },

  // R5: Altura de bebederos
  'eva_r5_label': {
    'es': 'Altura de los bebederos',
    'en': 'Drinker height',
  },
  'eva_r5_description': {
    'es': 'Se verifica que todos los animales del corral pueden acceder a los bebederos. Para bebederos de chupo, deben estar a la altura del promedio del lomo de los animales.',
    'en': 'Verifies all animals in the pen can access drinkers. Nipple drinkers should be at average back height of animals.',
  },
  'eva_r5_question': {
    'es': '¿La altura de los bebederos es adecuada a la edad y el tamaño de los animales?',
    'en': 'Is drinker height appropriate for animal age and size?',
  },

  // R6: Disponibilidad de bebederos
  'eva_r6_label': {
    'es': 'Disponibilidad de bebederos',
    'en': 'Drinker availability',
  },
  'eva_r6_description': {
    'es': 'Se verifica que para animales alojados en grupo al menos un (1) bebedero funcional por cada 10 animales o 8 cm de bebedero lineal por animal.',
    'en': 'Verifies at least one (1) functional drinker per 10 animals housed in groups, or 8 cm of linear drinker per animal.',
  },
  'eva_r6_question': {
    'es': '¿Se dispone de mínimo un (1) bebedero funcional por cada 10 animales?',
    'en': 'Is there at least one (1) functional drinker per 10 animals?',
  },

  // R7: Protección ambiental
  'eva_r7_label': {
    'es': 'Protección contra condiciones ambientales',
    'en': 'Environmental protection',
  },
  'eva_r7_description': {
    'es': 'Se verifica que las instalaciones garantizan protección ante inclemencias meteorológicas, predadores y riesgos de enfermedades.',
    'en': 'Verifies facilities provide protection from weather, predators, and disease risks.',
  },
  'eva_r7_question': {
    'es': '¿Las instalaciones ofrecen protección ante condiciones ambientales?',
    'en': 'Do facilities offer environmental protection?',
  },

  // R8: Ventilación
  'eva_r8_label': {
    'es': 'Ventilación',
    'en': 'Ventilation',
  },
  'eva_r8_description': {
    'es': 'Se verifica que las instalaciones cuentan con un ambiente donde haya una adecuada circulación de aire y manejo de gases.',
    'en': 'Verifies facilities have adequate air circulation and gas management.',
  },
  'eva_r8_question': {
    'es': '¿Se cuenta con sistemas de ventilación que garantizan correcta calidad y circulación de aire?',
    'en': 'Are ventilation systems in place to ensure proper air quality and circulation?',
  },

  // R9: Superficie de descanso
  'eva_r9_label': {
    'es': 'Superficie de descanso',
    'en': 'Resting surface',
  },
  'eva_r9_description': {
    'es': 'Se verifica que las superficies de los corrales y jaulas son antideslizantes y están en buen estado para evitar caídas.',
    'en': 'Verifies pen and cage surfaces are non-slip and in good condition to prevent falls.',
  },
  'eva_r9_question': {
    'es': '¿Los animales disponen de una superficie de descanso firme, en buen estado y antideslizante?',
    'en': 'Do animals have a firm, well-maintained, non-slip resting surface?',
  },

  // R10: Instalaciones para lechones
  'eva_r10_label': {
    'es': 'Instalaciones para resguardo de lechones',
    'en': 'Piglet shelter facilities',
  },
  'eva_r10_description': {
    'es': 'Se verifica que las instalaciones donde se alojan los lechones disponen de elementos para impedir el aplastamiento por parte de la cerda.',
    'en': 'Verifies piglet housing has elements to prevent crushing by the sow.',
  },
  'eva_r10_question': {
    'es': '¿Las instalaciones donde se alojan los lechones lactantes son seguras y brindan condiciones adecuadas?',
    'en': 'Are nursing piglet facilities safe and provide adequate conditions?',
  },

  // R11: Espacio cerdas en corral
  'eva_r11_label': {
    'es': 'Espacio para cerdas en corral',
    'en': 'Space for sows in pens',
  },
  'eva_r11_description': {
    'es': 'Se verifica el espacio libre disponible del que disponen las cerdas alojadas en corrales.',
    'en': 'Verifies the free space available for sows housed in pens.',
  },
  'eva_r11_question': {
    'es': '¿Las cerdas alojadas en corral disponen de suficiente espacio?',
    'en': 'Do sows housed in pens have sufficient space?',
  },

  // R12: Espacio cerdas en jaula
  'eva_r12_label': {
    'es': 'Espacio para cerdas en jaula',
    'en': 'Space for sows in cages',
  },
  'eva_r12_description': {
    'es': 'Se verifica el espacio libre disponible del que disponen las cerdas alojadas en jaula.',
    'en': 'Verifies the free space available for sows housed in cages.',
  },
  'eva_r12_question': {
    'es': '¿Las cerdas alojadas en jaula disponen de suficiente espacio?',
    'en': 'Do sows housed in cages have sufficient space?',
  },

  // R13: Jaulas libre acceso
  'eva_r13_label': {
    'es': 'Jaulas de libre acceso',
    'en': 'Free access cages',
  },
  'eva_r13_description': {
    'es': 'Para corrales de más de 40 cerdas alojadas en grupo se verifica que se dispone de jaulas de libre acceso y/o muros de ocultamiento.',
    'en': 'For pens with more than 40 sows housed in groups, verifies availability of free access cages and/or hiding walls.',
  },
  'eva_r13_question': {
    'es': '¿Los corrales con más de 40 cerdas disponen de jaulas de libre acceso y/o muros de ocultamiento?',
    'en': 'Do pens with more than 40 sows have free access cages and/or hiding walls?',
  },

  // R14: Tamaño de jaulas
  'eva_r14_label': {
    'es': 'Jaulas adecuadas al tamaño',
    'en': 'Cages appropriate for size',
  },
  'eva_r14_description': {
    'es': 'Se verifica que el tamaño de las jaulas es adecuado al tamaño de las hembras y permite una postura cómoda de descanso y lactancia.',
    'en': 'Verifies cage size is appropriate for sow size and allows comfortable resting and nursing posture.',
  },
  'eva_r14_question': {
    'es': '¿El diseño y dimensión de las jaulas se ajustan al tamaño de la hembra?',
    'en': 'Do cage design and dimensions fit the sow size?',
  },

  // R15: Espacio machos reproductores
  'eva_r15_label': {
    'es': 'Espacio para machos reproductores',
    'en': 'Space for breeding males',
  },
  'eva_r15_description': {
    'es': 'Se verifica el espacio libre disponible con el que cuentan los verracos y/o machos de reemplazo alojados en corrales y/o jaulas.',
    'en': 'Verifies free space available for boars and/or replacement males housed in pens and/or cages.',
  },
  'eva_r15_question': {
    'es': '¿Los machos reproductores y reemplazos disponen de suficiente espacio?',
    'en': 'Do breeding males and replacements have sufficient space?',
  },

  // R16: Espacio precebo
  'eva_r16_label': {
    'es': 'Espacio para precebo',
    'en': 'Space for nursery',
  },
  'eva_r16_description': {
    'es': 'Se verifica el espacio libre disponible para los cerdos en fase de precebo.',
    'en': 'Verifies free space available for pigs in nursery phase.',
  },
  'eva_r16_question': {
    'es': '¿Los cerdos en las fases de precebo disponen de suficiente espacio?',
    'en': 'Do pigs in nursery phases have sufficient space?',
  },

  // R17: Espacio levante y ceba
  'eva_r17_label': {
    'es': 'Espacio para levante y ceba',
    'en': 'Space for growing and finishing',
  },
  'eva_r17_description': {
    'es': 'Se verifica el espacio libre disponible para los cerdos en fases de levante y ceba.',
    'en': 'Verifies free space available for pigs in growing and finishing phases.',
  },
  'eva_r17_question': {
    'es': '¿Los cerdos en las fases de levante y ceba disponen de suficiente espacio?',
    'en': 'Do pigs in growing and finishing phases have sufficient space?',
  },

  // R18: Instalaciones movilización
  'eva_r18_label': {
    'es': 'Instalaciones para movilización y arreo',
    'en': 'Handling and movement facilities',
  },
  'eva_r18_description': {
    'es': 'Se verifica que los pasillos y elementos de conducción de los animales estén en buen estado y no generen lesiones.',
    'en': 'Verifies corridors and animal handling elements are in good condition and do not cause injuries.',
  },
  'eva_r18_question': {
    'es': '¿Las instalaciones y elementos permiten la adecuada movilización y arreo sin ocasionarles lesión?',
    'en': 'Do facilities and equipment allow proper movement and handling without causing injury?',
  },

  // ═══════════════════════════════════════════════════════════════
  // ANIMAL (A1-A14) - 50%
  // ═══════════════════════════════════════════════════════════════

  // A1: Condición corporal adultos
  'eva_a1_label': {
    'es': 'Condición corporal en hembras y machos',
    'en': 'Body condition in females and males',
  },
  'eva_a1_description': {
    'es': 'Con el animal en pie evalúe cuán visibles y palpables están los huesos de la columna vertebral, la cadera y tuberosidad isquiática.',
    'en': 'With the animal standing, evaluate how visible and palpable are the spine, hip, and ischial tuberosity bones.',
  },
  'eva_a1_question': {
    'es': '¿Cuál es la condición corporal de los animales evaluados?',
    'en': 'What is the body condition of the evaluated animals?',
  },

  // A2: Condición corporal crecimiento
  'eva_a2_label': {
    'es': 'Condición corporal en precebo, levante y ceba',
    'en': 'Body condition in nursery, growing and finishing',
  },
  'eva_a2_description': {
    'es': 'Con el animal en pie evalúe cuán visibles y palpables están los huesos de la columna vertebral, la cadera y tuberosidad isquiática.',
    'en': 'With the animal standing, evaluate how visible and palpable are the spine, hip, and ischial tuberosity bones.',
  },
  'eva_a2_question': {
    'es': '¿Cuál es la condición corporal de los animales evaluados?',
    'en': 'What is the body condition of the evaluated animals?',
  },

  // A3: Cojeras
  'eva_a3_label': {
    'es': 'Cojeras',
    'en': 'Lameness',
  },
  'eva_a3_description': {
    'es': 'Para animales en corral o libres, haga levantar y caminar considerablemente y evaluar cuántos presentan cojeras.',
    'en': 'For animals in pens or free, make them stand and walk considerably and evaluate how many show lameness.',
  },
  'eva_a3_question': {
    'es': '¿Los animales presentan cojeras?',
    'en': 'Do animals show lameness?',
  },

  // A4: Jadeos
  'eva_a4_label': {
    'es': 'Jadeos',
    'en': 'Panting',
  },
  'eva_a4_description': {
    'es': 'Se verifica presencia de respiración rápida con inhalaciones breves a través de la boca. Mayor a 28 RPM para adultos y 55 RPM para lechones indica jadeo.',
    'en': 'Verifies presence of rapid breathing with short inhalations through the mouth. More than 28 RPM for adults and 55 RPM for piglets indicates panting.',
  },
  'eva_a4_question': {
    'es': '¿Los animales presentan jadeos?',
    'en': 'Do animals show panting?',
  },

  // A5: Temblores/amontonamiento
  'eva_a5_label': {
    'es': 'Temblores y/o amontonamiento',
    'en': 'Shivering and/or huddling',
  },
  'eva_a5_description': {
    'es': 'Se evalúa el estrés térmico por frío observando el amontonamiento y la presencia de temblores en animales en reposo.',
    'en': 'Evaluates cold thermal stress by observing huddling and presence of shivering in resting animals.',
  },
  'eva_a5_question': {
    'es': '¿Los animales están amontonados y/o presentan temblores?',
    'en': 'Are animals huddling and/or showing shivering?',
  },

  // A6: Heridas graves
  'eva_a6_label': {
    'es': 'Heridas graves en el cuerpo',
    'en': 'Severe body wounds',
  },
  'eva_a6_description': {
    'es': 'Se considera que un animal presenta heridas graves cuando tiene al menos una herida abierta de más de 5 centímetros.',
    'en': 'An animal is considered to have severe wounds when it has at least one open wound larger than 5 centimeters.',
  },
  'eva_a6_question': {
    'es': '¿Los animales tienen heridas graves en el cuerpo?',
    'en': 'Do animals have severe body wounds?',
  },

  // A7: Enriquecimiento ambiental
  'eva_a7_label': {
    'es': 'Enriquecimiento ambiental e interacción',
    'en': 'Environmental enrichment and interaction',
  },
  'eva_a7_description': {
    'es': 'Se verifica que los animales alojados en grupo dispongan de material de enriquecimiento ambiental, preferiblemente destructible, masticable, inocuo y con valor nutricional.',
    'en': 'Verifies that group-housed animals have environmental enrichment material, preferably destructible, chewable, harmless, and nutritious.',
  },
  'eva_a7_question': {
    'es': '¿Los animales alojados en grupo tienen y usan el material de enriquecimiento?',
    'en': 'Do group-housed animals have and use enrichment material?',
  },

  // A8: Relación humano-animal adultos
  'eva_a8_label': {
    'es': 'Relación humano-animal en hembras y machos',
    'en': 'Human-animal relationship in females and males',
  },
  'eva_a8_description': {
    'es': 'Se verifica la respuesta del animal a la interacción con el humano mediante una prueba de 3 pasos de acercamiento.',
    'en': 'Verifies animal response to human interaction through a 3-step approach test.',
  },
  'eva_a8_question': {
    'es': '¿Cómo es la relación humano-animal en hembras y machos?',
    'en': 'How is the human-animal relationship in females and males?',
  },

  // A9: Relación humano-animal crecimiento
  'eva_a9_label': {
    'es': 'Relación humano-animal en levante y ceba',
    'en': 'Human-animal relationship in growing and finishing',
  },
  'eva_a9_description': {
    'es': 'Se evalúa el porcentaje de animales que muestran respuesta de miedo ante la presencia del evaluador.',
    'en': 'Evaluates the percentage of animals showing fear response to the evaluator\'s presence.',
  },
  'eva_a9_question': {
    'es': '¿Cómo es la relación humano-animal en levante y ceba?',
    'en': 'How is the human-animal relationship in growing and finishing?',
  },

  // A10: Identificación de animales
  'eva_a10_label': {
    'es': 'Identificación de animales',
    'en': 'Animal identification',
  },
  'eva_a10_description': {
    'es': 'Se verifica el método de identificación. Métodos aceptados: chapetas auriculares, tatuajes, marcado en frío o dispositivos de radiofrecuencia.',
    'en': 'Verifies identification method. Accepted methods: ear tags, tattoos, freeze branding, or radio-frequency devices.',
  },
  'eva_a10_question': {
    'es': '¿Cuál es el método de identificación de los animales?',
    'en': 'What is the animal identification method?',
  },

  // A11: Descolmille
  'eva_a11_label': {
    'es': 'Prácticas dolorosas - Descolmille',
    'en': 'Painful practices - Teeth clipping',
  },
  'eva_a11_description': {
    'es': 'Se verifica si los colmillos de los lechones han sido cortados, despuntados o limados, y si cumple con los requisitos de edad, capacitación y recomendación veterinaria.',
    'en': 'Verifies if piglet teeth have been clipped, tipped, or filed, and compliance with age, training, and veterinary requirements.',
  },
  'eva_a11_question': {
    'es': '¿Se realiza descolmille, despunte o limado de colmillos?',
    'en': 'Is teeth clipping, tipping, or filing performed?',
  },

  // A12: Descole
  'eva_a12_label': {
    'es': 'Prácticas dolorosas - Descole',
    'en': 'Painful practices - Tail docking',
  },
  'eva_a12_description': {
    'es': 'Se verifica si los lechones han sido descolados y si cumple con los requisitos de edad, capacitación del personal y recomendación del Médico Veterinario.',
    'en': 'Verifies if piglets have been tail docked and compliance with age, staff training, and veterinary requirements.',
  },
  'eva_a12_question': {
    'es': '¿Se realiza descole?',
    'en': 'Is tail docking performed?',
  },

  // A13: Castración
  'eva_a13_label': {
    'es': 'Castración',
    'en': 'Castration',
  },
  'eva_a13_description': {
    'es': 'Se verifica si se realiza castración (química o quirúrgica) y si cumple con los requisitos según la edad del animal.',
    'en': 'Verifies if castration (chemical or surgical) is performed and compliance with requirements based on animal age.',
  },
  'eva_a13_question': {
    'es': '¿Se realiza castración? Si es afirmativo, ¿química o quirúrgica?',
    'en': 'Is castration performed? If yes, chemical or surgical?',
  },

  // A14: Atención animales enfermos
  'eva_a14_label': {
    'es': 'Atención de animales enfermos',
    'en': 'Sick animal care',
  },
  'eva_a14_description': {
    'es': 'Se verifica si los animales enfermos han sido identificados, aislados (cuando sea necesario), y si están recibiendo tratamiento y atención médico-veterinaria oportuna.',
    'en': 'Verifies if sick animals have been identified, isolated (when necessary), and are receiving timely veterinary treatment and care.',
  },
  'eva_a14_question': {
    'es': '¿Aísla, identifica y atiende oportunamente a los animales enfermos?',
    'en': 'Are sick animals isolated, identified, and cared for promptly?',
  },

  // ═══════════════════════════════════════════════════════════════
  // GESTIÓN (G1-G7) - 15%
  // ═══════════════════════════════════════════════════════════════

  // G1: Plan de contingencia
  'eva_g1_label': {
    'es': 'Plan de contingencia para agua y alimento',
    'en': 'Contingency plan for water and feed',
  },
  'eva_g1_description': {
    'es': 'Se verifica la existencia del plan para la gestión de problemas en el abastecimiento de agua y alimento.',
    'en': 'Verifies existence of a plan for managing water and feed supply problems.',
  },
  'eva_g1_question': {
    'es': '¿Existe plan de contingencia y/o emergencia ante problemas de abastecimiento de agua y alimento?',
    'en': 'Is there a contingency/emergency plan for water and feed supply problems?',
  },

  // G2: Plan sanitario
  'eva_g2_label': {
    'es': 'Plan Sanitario',
    'en': 'Health Plan',
  },
  'eva_g2_description': {
    'es': 'Se verifica que el predio cuente con un plan sanitario documentado firmado por un médico veterinario, que considere enfermedades de control oficial y otras endémicas.',
    'en': 'Verifies the farm has a documented health plan signed by a veterinarian, covering official control diseases and other endemic diseases.',
  },
  'eva_g2_question': {
    'es': '¿Se dispone de plan sanitario que incluye enfermedades de control oficial y las más frecuentes en la zona?',
    'en': 'Is there a health plan covering official control diseases and those most common in the area?',
  },

  // G3: Uso de medicamentos
  'eva_g3_label': {
    'es': 'Uso de medicamentos veterinarios',
    'en': 'Veterinary medicine use',
  },
  'eva_g3_description': {
    'es': 'Se verifica el cumplimiento de las buenas prácticas de uso de medicamentos veterinarios (BPUMV).',
    'en': 'Verifies compliance with good veterinary medicine use practices.',
  },
  'eva_g3_question': {
    'es': '¿Se cumple con las Buenas Prácticas del Uso de Medicamentos Veterinarios?',
    'en': 'Is there compliance with Good Veterinary Medicine Use Practices?',
  },

  // G4: Registro de mortalidad
  'eva_g4_label': {
    'es': 'Registro de mortalidad',
    'en': 'Mortality records',
  },
  'eva_g4_description': {
    'es': 'Se verifica la existencia de registros de mortalidad por cada etapa productiva, con cobertura mínima de tres meses.',
    'en': 'Verifies existence of mortality records for each production stage, covering at least three months.',
  },
  'eva_g4_question': {
    'es': '¿Se cuenta con el registro de mortalidad de todas las etapas productivas?',
    'en': 'Are mortality records available for all production stages?',
  },

  // G5: Intervenciones quirúrgicas
  'eva_g5_label': {
    'es': 'Intervenciones quirúrgicas',
    'en': 'Surgical procedures',
  },
  'eva_g5_description': {
    'es': 'Se verifica que las intervenciones quirúrgicas menores y mayores sean realizadas según los protocolos establecidos con analgesia/anestesia adecuada.',
    'en': 'Verifies minor and major surgical procedures are performed according to established protocols with adequate analgesia/anesthesia.',
  },
  'eva_g5_question': {
    'es': '¿Cómo es el procedimiento de las intervenciones quirúrgicas?',
    'en': 'How are surgical procedures performed?',
  },

  // G6: Sacrificio humanitario
  'eva_g6_label': {
    'es': 'Sacrificio humanitario',
    'en': 'Humane slaughter',
  },
  'eva_g6_description': {
    'es': 'Se verifica que el personal esté capacitado y disponga de un procedimiento escrito acorde al Código Sanitario de la OMSA.',
    'en': 'Verifies staff are trained and have written procedures in accordance with the WOAH Health Code.',
  },
  'eva_g6_question': {
    'es': '¿El método de sacrificio está recomendado por la OMSA y cuenta con elementos adecuados?',
    'en': 'Is the slaughter method WOAH-recommended with adequate equipment?',
  },

  // G7: Capacitación del personal
  'eva_g7_label': {
    'es': 'Capacitación del personal',
    'en': 'Staff training',
  },
  'eva_g7_description': {
    'es': 'Se verifica que todo el personal que maneja los porcinos cuente con certificado de capacitación en bienestar animal según contenido e intensidad horaria establecidos por el ICA.',
    'en': 'Verifies all personnel handling pigs have animal welfare training certificates per ICA content and duration requirements.',
  },
  'eva_g7_question': {
    'es': '¿El personal encargado del manejo cuenta con certificado de capacitación en bienestar animal?',
    'en': 'Does handling staff have animal welfare training certification?',
  },

  // ═══════════════════════════════════════════════════════════════
  // OPCIONES DE RESPUESTA ESCALA EVA
  // ═══════════════════════════════════════════════════════════════
  'scale_eva_100': {
    'es': '100 - Cumple totalmente (100%)',
    'en': '100 - Fully compliant (100%)',
  },
  'scale_eva_80': {
    'es': '80 - Cumple ≥80% y <100%',
    'en': '80 - Compliant ≥80% and <100%',
  },
  'scale_eva_55': {
    'es': '55 - Cumple ≥60% y <80%',
    'en': '55 - Compliant ≥60% and <80%',
  },
  'scale_eva_20': {
    'es': '20 - Cumple ≥50% y <60%',
    'en': '20 - Compliant ≥50% and <60%',
  },
  'scale_eva_0': {
    'es': '0 - Cumple <50%',
    'en': '0 - Compliant <50%',
  },

  // Clasificación de predios
  'classification_excellent': {
    'es': 'PREDIO CON EXCELENTE BIENESTAR',
    'en': 'FARM WITH EXCELLENT WELFARE',
  },
  'classification_high': {
    'es': 'PREDIO CON ALTO BIENESTAR',
    'en': 'FARM WITH HIGH WELFARE',
  },
  'classification_medium': {
    'es': 'PREDIO CON MEDIO BIENESTAR',
    'en': 'FARM WITH MEDIUM WELFARE',
  },
  'classification_low': {
    'es': 'PREDIO CON BAJO BIENESTAR',
    'en': 'FARM WITH LOW WELFARE',
  },
};
