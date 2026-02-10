/// Traducciones para la metodología EBA 3.0 - Porcinos
/// Evaluación de Bienestar Animal según estándares internacionales
/// Escala de calificación: 0-4
///
/// Estructura del documento:
/// - 43 indicadores totales
/// - Grupos: Recurso (40%), Animal (40%), Gestión (20%)
/// - Categorías opcionales: Transporte, Sacrificio

class EbaPigsTranslations {
  static Map<String, Map<String, String>> get translations => {
    // ═══════════════════════════════════════════════════════════════════════
    // CATEGORÍAS
    // ═══════════════════════════════════════════════════════════════════════
    'category_resource_pigs': {
      'es': 'Indicadores de Recurso',
      'en': 'Resource Indicators',
    },
    'category_animal_pigs': {
      'es': 'Indicadores del Animal',
      'en': 'Animal Indicators',
    },
    'category_management_pigs': {
      'es': 'Indicadores de Gestión',
      'en': 'Management Indicators',
    },
    'category_transport_pigs': {
      'es': 'Indicadores de Transporte',
      'en': 'Transport Indicators',
    },
    'category_slaughter_pigs': {
      'es': 'Indicadores de Sacrificio',
      'en': 'Slaughter Indicators',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // ESCALA 0-4 DESCRIPCIONES
    // ═══════════════════════════════════════════════════════════════════════
    'scale_0_pigs': {'es': 'No cumple / Crítico', 'en': 'Non-compliant / Critical'},
    'scale_1_pigs': {'es': 'Deficiente', 'en': 'Poor'},
    'scale_2_pigs': {'es': 'Aceptable', 'en': 'Acceptable'},
    'scale_3_pigs': {'es': 'Bueno', 'en': 'Good'},
    'scale_4_pigs': {'es': 'Excelente', 'en': 'Excellent'},

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-A1: Relación animales:bebedero
    // ═══════════════════════════════════════════════════════════════════════
    'eba_a1_label': {
      'es': 'Relación animales por bebedero',
      'en': 'Animals per drinker ratio',
    },
    'eba_a1_description': {
      'es': 'Conteo de bebederos funcionales y número de animales. Rangos: Lechones ≤10 (4pts), Ceba ≤12 (4pts), Gestantes ≤8 (4pts).',
      'en': 'Count of functional drinkers and number of animals. Ranges: Piglets ≤10 (4pts), Finishing ≤12 (4pts), Gestating ≤8 (4pts).',
    },
    'eba_a1_question': {
      'es': '¿Cuántos animales hay por bebedero funcional?',
      'en': 'How many animals per functional drinker?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-A2: Caudal de bebedero
    // ═══════════════════════════════════════════════════════════════════════
    'eba_a2_label': {
      'es': 'Caudal del bebedero',
      'en': 'Drinker flow rate',
    },
    'eba_a2_description': {
      'es': 'Medición del caudal con probeta en 30 segundos. Lechones: 0.6-1.0 L/min (4pts), Ceba/Gestantes: 1.0-1.5 L/min (4pts).',
      'en': 'Flow measurement with graduated cylinder in 30 seconds. Piglets: 0.6-1.0 L/min (4pts), Finishing/Gestating: 1.0-1.5 L/min (4pts).',
    },
    'eba_a2_question': {
      'es': '¿El caudal abastece los requerimientos por categoría?',
      'en': 'Does the flow rate meet requirements by category?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-A3: Calidad microbiológica del agua
    // ═══════════════════════════════════════════════════════════════════════
    'eba_a3_label': {
      'es': 'Calidad microbiológica del agua',
      'en': 'Water microbiological quality',
    },
    'eba_a3_description': {
      'es': 'Análisis de laboratorio para coliformes totales y E. coli según norma. Frecuencia: Semestral.',
      'en': 'Laboratory analysis for total coliforms and E. coli according to standards. Frequency: Semi-annual.',
    },
    'eba_a3_question': {
      'es': '¿Coliformes totales y E. coli cumplen norma?',
      'en': 'Do total coliforms and E. coli meet standards?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-F1: Espacios de comedero
    // ═══════════════════════════════════════════════════════════════════════
    'eba_f1_label': {
      'es': 'Espacios de comedero suficientes',
      'en': 'Sufficient feeder spaces',
    },
    'eba_f1_description': {
      'es': 'Conteo de espacios y observación de competencia. Lechones ≤4 (4pts), Ceba ≤6 (4pts), Gestantes ≤5 (4pts).',
      'en': 'Space count and competition observation. Piglets ≤4 (4pts), Finishing ≤6 (4pts), Gestating ≤5 (4pts).',
    },
    'eba_f1_question': {
      'es': '¿La relación animales:espacios de comedero es adecuada?',
      'en': 'Is the animal-to-feeder space ratio adequate?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-F2: Condición corporal
    // ═══════════════════════════════════════════════════════════════════════
    'eba_f2_label': {
      'es': 'Condición corporal (CC)',
      'en': 'Body condition score (BCS)',
    },
    'eba_f2_description': {
      'es': 'Evaluación visual/táctil de la condición corporal. Escala 1-5, medir % animales con CC <2.5.',
      'en': 'Visual/tactile assessment of body condition. Scale 1-5, measure % animals with BCS <2.5.',
    },
    'eba_f2_question': {
      'es': '¿Qué porcentaje de animales tiene CC <2.5/5?',
      'en': 'What percentage of animals have BCS <2.5/5?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-F3: Tiempo de acceso tras reparto
    // ═══════════════════════════════════════════════════════════════════════
    'eba_f3_label': {
      'es': 'Tiempo de acceso tras reparto',
      'en': 'Access time after feeding',
    },
    'eba_f3_description': {
      'es': 'Cronometría del tiempo hasta que todos acceden sin competencia excesiva.',
      'en': 'Timing until all animals access without excessive competition.',
    },
    'eba_f3_question': {
      'es': '¿Cuánto tardan todos los animales en acceder al alimento?',
      'en': 'How long until all animals access feed?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-E1: Índice THI
    // ═══════════════════════════════════════════════════════════════════════
    'eba_e1_label': {
      'es': 'Índice de temperatura-humedad (THI)',
      'en': 'Temperature-Humidity Index (THI)',
    },
    'eba_e1_description': {
      'es': 'Medir temperatura y humedad relativa, calcular THI. Evaluar en horas críticas.',
      'en': 'Measure temperature and relative humidity, calculate THI. Evaluate during critical hours.',
    },
    'eba_e1_question': {
      'es': '¿Cuál es el índice THI en horas críticas?',
      'en': 'What is the THI during critical hours?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-E2: Amoníaco
    // ═══════════════════════════════════════════════════════════════════════
    'eba_e2_label': {
      'es': 'Nivel de amoníaco (NH₃)',
      'en': 'Ammonia level (NH₃)',
    },
    'eba_e2_description': {
      'es': 'Medición con tubo colorimétrico o sensor digital a nivel del hocico del animal.',
      'en': 'Measurement with colorimetric tube or digital sensor at animal snout level.',
    },
    'eba_e2_question': {
      'es': '¿Cuántas ppm de NH₃ hay a nivel del hocico?',
      'en': 'How many ppm of NH₃ at snout level?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-E3: CO2
    // ═══════════════════════════════════════════════════════════════════════
    'eba_e3_label': {
      'es': 'Nivel de dióxido de carbono (CO₂)',
      'en': 'Carbon dioxide level (CO₂)',
    },
    'eba_e3_description': {
      'es': 'Medición con sensor digital calibrado a nivel del hocico.',
      'en': 'Measurement with calibrated digital sensor at snout level.',
    },
    'eba_e3_question': {
      'es': '¿Cuántas ppm de CO₂ hay a nivel del hocico?',
      'en': 'How many ppm of CO₂ at snout level?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-E4: Ruido
    // ═══════════════════════════════════════════════════════════════════════
    'eba_e4_label': {
      'es': 'Nivel de ruido',
      'en': 'Noise level',
    },
    'eba_e4_description': {
      'es': 'Medición con sonómetro calibrado, promedio de 5 minutos por corral.',
      'en': 'Measurement with calibrated sound meter, 5-minute average per pen.',
    },
    'eba_e4_question': {
      'es': '¿Cuál es el nivel de ruido promedio en dB(A)?',
      'en': 'What is the average noise level in dB(A)?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-E5: Iluminación
    // ═══════════════════════════════════════════════════════════════════════
    'eba_e5_label': {
      'es': 'Iluminación mínima',
      'en': 'Minimum lighting',
    },
    'eba_e5_description': {
      'es': 'Medición con luxómetro en 5 puntos por corral durante el día.',
      'en': 'Measurement with lux meter at 5 points per pen during daytime.',
    },
    'eba_e5_question': {
      'es': '¿Cuál es la iluminación mínima diurna en lux?',
      'en': 'What is the minimum daytime lighting in lux?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-I1: Densidad de alojamiento
    // ═══════════════════════════════════════════════════════════════════════
    'eba_i1_label': {
      'es': 'Densidad de alojamiento',
      'en': 'Housing density',
    },
    'eba_i1_description': {
      'es': 'Medición del área útil y conteo de animales. ≥110kg: ≥0.8 m²/animal; 80-110kg: ≥0.65 m²/animal.',
      'en': 'Useful area measurement and animal count. ≥110kg: ≥0.8 m²/animal; 80-110kg: ≥0.65 m²/animal.',
    },
    'eba_i1_question': {
      'es': '¿Cuántos m² por animal según categoría/peso?',
      'en': 'How many m² per animal by category/weight?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-I2: Estado de pisos
    // ═══════════════════════════════════════════════════════════════════════
    'eba_i2_label': {
      'es': 'Estado de los pisos',
      'en': 'Floor condition',
    },
    'eba_i2_description': {
      'es': 'Inspección por cuadrantes para identificar % de superficie con daños lesivos.',
      'en': 'Quadrant inspection to identify % of surface with injurious damage.',
    },
    'eba_i2_question': {
      'es': '¿Qué porcentaje de la superficie tiene daños lesivos?',
      'en': 'What percentage of surface has injurious damage?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-I3: Área de descanso seca
    // ═══════════════════════════════════════════════════════════════════════
    'eba_i3_label': {
      'es': 'Área de descanso seca',
      'en': 'Dry resting area',
    },
    'eba_i3_description': {
      'es': 'Inspección por cuadrantes del % de superficie seca disponible para descanso.',
      'en': 'Quadrant inspection of % dry surface available for resting.',
    },
    'eba_i3_question': {
      'es': '¿Qué porcentaje de la superficie de descanso está seca?',
      'en': 'What percentage of resting surface is dry?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-I4: Suciedad corporal
    // ═══════════════════════════════════════════════════════════════════════
    'eba_i4_label': {
      'es': 'Suciedad corporal',
      'en': 'Body dirtiness',
    },
    'eba_i4_description': {
      'es': 'Escala visual 0-2 en muestra. Evaluar % animales con ≥20% del cuerpo sucio.',
      'en': 'Visual scale 0-2 on sample. Evaluate % animals with ≥20% of body dirty.',
    },
    'eba_i4_question': {
      'es': '¿Qué porcentaje de animales tiene ≥20% del cuerpo sucio?',
      'en': 'What percentage of animals have ≥20% of body dirty?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-I5: Material manipulable
    // ═══════════════════════════════════════════════════════════════════════
    'eba_i5_label': {
      'es': 'Material manipulable disponible',
      'en': 'Available manipulable material',
    },
    'eba_i5_description': {
      'es': 'Checklist por corral verificando disponibilidad de material manipulable suficiente y limpio.',
      'en': 'Per-pen checklist verifying availability of sufficient and clean manipulable material.',
    },
    'eba_i5_question': {
      'es': '¿Qué porcentaje de corrales tiene material manipulable suficiente?',
      'en': 'What percentage of pens have sufficient manipulable material?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-R1: GMD (Ganancia Media Diaria)
    // ═══════════════════════════════════════════════════════════════════════
    'eba_r1_label': {
      'es': 'Ganancia media diaria (GMD)',
      'en': 'Average daily gain (ADG)',
    },
    'eba_r1_description': {
      'es': 'Cálculo de GMD a partir de pesajes inicial y final del lote.',
      'en': 'ADG calculation from initial and final batch weighings.',
    },
    'eba_r1_question': {
      'es': '¿Cuál es la GMD promedio del lote en g/día?',
      'en': 'What is the average ADG of the batch in g/day?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-L3: Temperatura nido/placa
    // ═══════════════════════════════════════════════════════════════════════
    'eba_l3_label': {
      'es': 'Temperatura del nido/placa',
      'en': 'Nest/heating pad temperature',
    },
    'eba_l3_description': {
      'es': 'Medición con termómetro/termografía de la temperatura del área de lechones neonatos.',
      'en': 'Temperature measurement of the neonatal piglet area.',
    },
    'eba_l3_question': {
      'es': '¿La temperatura del nido/placa está en el rango objetivo para neonatos?',
      'en': 'Is the nest/pad temperature in the target range for neonates?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H1: Cojeras
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h1_label': {
      'es': 'Cojeras',
      'en': 'Lameness',
    },
    'eba_h1_description': {
      'es': 'Observación de marcha en pasillo. Evaluar % animales con locomoción anormal (≥2/5).',
      'en': 'Gait observation in corridor. Evaluate % animals with abnormal locomotion (≥2/5).',
    },
    'eba_h1_question': {
      'es': '¿Qué porcentaje de animales presenta locomoción anormal?',
      'en': 'What percentage of animals show abnormal locomotion?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H2: Lesiones tegumentarias
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h2_label': {
      'es': 'Lesiones tegumentarias',
      'en': 'Skin lesions',
    },
    'eba_h2_description': {
      'es': 'Inspección visual en pie y descanso de heridas/raspones >2 cm.',
      'en': 'Visual inspection for wounds/scrapes >2 cm.',
    },
    'eba_h2_question': {
      'es': '¿Qué porcentaje de animales tiene heridas/raspones >2 cm?',
      'en': 'What percentage of animals have wounds/scrapes >2 cm?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H3: Tos/estornudos
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h3_label': {
      'es': 'Tos y estornudos',
      'en': 'Coughing and sneezing',
    },
    'eba_h3_description': {
      'es': 'Observación focal de 10 minutos. Contar eventos de tos/estornudo por animal por minuto.',
      'en': 'Focal observation for 10 minutes. Count coughing/sneezing events per animal per minute.',
    },
    'eba_h3_question': {
      'es': '¿Cuántos eventos por animal/min se observan en 10 minutos?',
      'en': 'How many events per animal/min observed in 10 minutes?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H4: Diarrea
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h4_label': {
      'es': 'Diarrea',
      'en': 'Diarrhea',
    },
    'eba_h4_description': {
      'es': 'Observación clínica rápida por corral de animales con perineo sucio o heces líquidas.',
      'en': 'Quick clinical observation per pen of animals with dirty perineum or liquid feces.',
    },
    'eba_h4_question': {
      'es': '¿Qué porcentaje de animales presenta perineo sucio/heces líquidas?',
      'en': 'What percentage of animals show dirty perineum/liquid feces?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H5: Mortalidad del lote
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h5_label': {
      'es': 'Mortalidad del lote',
      'en': 'Batch mortality',
    },
    'eba_h5_description': {
      'es': 'Revisión de registros productivos. % de bajas en el ciclo/etapa.',
      'en': 'Review of production records. % of deaths in the cycle/stage.',
    },
    'eba_h5_question': {
      'es': '¿Cuál es el porcentaje de bajas en el ciclo/etapa?',
      'en': 'What is the death percentage in the cycle/stage?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H6: Analgesia/anestesia
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h6_label': {
      'es': 'Analgesia/anestesia en procedimientos',
      'en': 'Analgesia/anesthesia in procedures',
    },
    'eba_h6_description': {
      'es': 'Auditoría documental y observación del uso de analgesia y anestesia en procedimientos dolorosos.',
      'en': 'Documentary audit and observation of analgesia/anesthesia use in painful procedures.',
    },
    'eba_h6_question': {
      'es': '¿Qué porcentaje de procedimientos dolorosos se realizan con analgesia y anestesia?',
      'en': 'What percentage of painful procedures are performed with analgesia/anesthesia?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-H8: Cicatrices de cola
    // ═══════════════════════════════════════════════════════════════════════
    'eba_h8_label': {
      'es': 'Cicatrices de cola',
      'en': 'Tail scars',
    },
    'eba_h8_description': {
      'es': 'Inspección visual sistemática de cicatrices o lesiones crónicas en cola.',
      'en': 'Systematic visual inspection of scars or chronic injuries on tail.',
    },
    'eba_h8_question': {
      'es': '¿Qué porcentaje de animales tiene cicatrices/lesiones crónicas en cola?',
      'en': 'What percentage of animals have scars/chronic injuries on tail?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-B1: Peleas
    // ═══════════════════════════════════════════════════════════════════════
    'eba_b1_label': {
      'es': 'Peleas (>3 segundos)',
      'en': 'Fights (>3 seconds)',
    },
    'eba_b1_description': {
      'es': 'Observación de 10 minutos, 3 repeticiones. Contar peleas mayores a 3 segundos.',
      'en': 'Observation for 10 minutes, 3 repetitions. Count fights longer than 3 seconds.',
    },
    'eba_b1_question': {
      'es': '¿Cuántas peleas de más de 3 segundos se observan en 10 minutos por corral?',
      'en': 'How many fights >3 seconds observed in 10 minutes per pen?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-B2: Uso de enriquecimiento
    // ═══════════════════════════════════════════════════════════════════════
    'eba_b2_label': {
      'es': 'Uso de enriquecimiento',
      'en': 'Enrichment use',
    },
    'eba_b2_description': {
      'es': 'Scan sampling cada 30 segundos durante 5 minutos. Medir % animales interactuando con material.',
      'en': 'Scan sampling every 30 seconds for 5 minutes. Measure % animals interacting with material.',
    },
    'eba_b2_question': {
      'es': '¿Qué porcentaje de animales interactúa con el material de enriquecimiento en 5 minutos?',
      'en': 'What percentage of animals interact with enrichment material in 5 minutes?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-B3: Huida al acercamiento humano
    // ═══════════════════════════════════════════════════════════════════════
    'eba_b3_label': {
      'es': 'Huida al acercamiento humano',
      'en': 'Flight from human approach',
    },
    'eba_b3_description': {
      'es': 'Prueba estandarizada (walk test). Medir % animales que se alejan >1 m ante acercamiento lento.',
      'en': 'Standardized test (walk test). Measure % animals moving away >1 m upon slow approach.',
    },
    'eba_b3_question': {
      'es': '¿Qué porcentaje de animales huye más de 1 m ante el acercamiento humano?',
      'en': 'What percentage of animals flee more than 1 m upon human approach?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-R2: Colas mordidas activas
    // ═══════════════════════════════════════════════════════════════════════
    'eba_r2_label': {
      'es': 'Colas mordidas activas',
      'en': 'Active tail biting',
    },
    'eba_r2_description': {
      'es': 'Inspección visual por corral de lesiones recientes en cola (sangrado, heridas frescas).',
      'en': 'Visual inspection per pen for recent tail injuries (bleeding, fresh wounds).',
    },
    'eba_r2_question': {
      'es': '¿Qué porcentaje de animales tiene lesiones recientes en cola?',
      'en': 'What percentage of animals have recent tail injuries?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-L1: Mortalidad predestete
    // ═══════════════════════════════════════════════════════════════════════
    'eba_l1_label': {
      'es': 'Mortalidad predestete',
      'en': 'Pre-weaning mortality',
    },
    'eba_l1_description': {
      'es': 'Revisión de planillas de paridera. % de lechones muertos del nacimiento al destete.',
      'en': 'Review of farrowing records. % of piglets dead from birth to weaning.',
    },
    'eba_l1_question': {
      'es': '¿Cuál es el porcentaje de lechones muertos del nacimiento al destete?',
      'en': 'What percentage of piglets died from birth to weaning?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-L2: Aplastamientos
    // ═══════════════════════════════════════════════════════════════════════
    'eba_l2_label': {
      'es': 'Aplastamientos',
      'en': 'Crushing deaths',
    },
    'eba_l2_description': {
      'es': 'Clasificación de causa de muerte. % de lechones muertos por aplastamiento.',
      'en': 'Death cause classification. % of piglets dead by crushing.',
    },
    'eba_l2_question': {
      'es': '¿Cuál es el porcentaje de lechones muertos por aplastamiento?',
      'en': 'What percentage of piglets died from crushing?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-G1: Gestantes en grupo
    // ═══════════════════════════════════════════════════════════════════════
    'eba_g1_label': {
      'es': 'Gestantes en grupo',
      'en': 'Group-housed gestating sows',
    },
    'eba_g1_description': {
      'es': 'Censo por nave y revisión de protección de comedero. % de gestantes alojadas en grupo.',
      'en': 'Census per building and feeder protection review. % of gestating sows housed in groups.',
    },
    'eba_g1_question': {
      'es': '¿Qué porcentaje de gestantes está en alojamiento grupal con protección de comedero?',
      'en': 'What percentage of gestating sows are in group housing with feeder protection?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-P1: Capacitación
    // ═══════════════════════════════════════════════════════════════════════
    'eba_p1_label': {
      'es': 'Capacitación en bienestar animal',
      'en': 'Animal welfare training',
    },
    'eba_p1_description': {
      'es': 'Revisión de certificados y listas de asistencia. % del personal con formación anual certificada.',
      'en': 'Review of certificates and attendance lists. % of staff with annual certified training.',
    },
    'eba_p1_question': {
      'es': '¿Qué porcentaje del personal tiene formación anual certificada en bienestar animal?',
      'en': 'What percentage of staff has annual certified animal welfare training?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-D1: SOPs
    // ═══════════════════════════════════════════════════════════════════════
    'eba_d1_label': {
      'es': 'Procedimientos escritos vigentes (SOPs)',
      'en': 'Current written procedures (SOPs)',
    },
    'eba_d1_description': {
      'es': 'Auditoría y verificación en campo de la existencia y aplicación de SOPs críticos.',
      'en': 'Audit and field verification of existence and application of critical SOPs.',
    },
    'eba_d1_question': {
      'es': '¿Los SOPs críticos existen y se aplican correctamente?',
      'en': 'Do critical SOPs exist and are they correctly applied?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-D2: Plan de contingencia
    // ═══════════════════════════════════════════════════════════════════════
    'eba_d2_label': {
      'es': 'Plan de contingencia',
      'en': 'Contingency plan',
    },
    'eba_d2_description': {
      'es': 'Auditoría de plan activo para emergencias (agua, energía, incendio, desastres) con simulacros.',
      'en': 'Audit of active plan for emergencies (water, power, fire, disasters) with drills.',
    },
    'eba_d2_question': {
      'es': '¿Existe un plan de contingencia activo con evidencia de simulacros?',
      'en': 'Is there an active contingency plan with drill evidence?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-T1: Animales no ambulatorios
    // ═══════════════════════════════════════════════════════════════════════
    'eba_t1_label': {
      'es': 'Animales no ambulatorios',
      'en': 'Non-ambulatory animals',
    },
    'eba_t1_description': {
      'es': 'Conteo al desembarque del % de animales que no pueden caminar.',
      'en': 'Count at unloading of % of animals that cannot walk.',
    },
    'eba_t1_question': {
      'es': '¿Qué porcentaje de animales no ambulatorios hay al arribo?',
      'en': 'What percentage of non-ambulatory animals at arrival?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-T2: Muertos a la llegada (DOA)
    // ═══════════════════════════════════════════════════════════════════════
    'eba_t2_label': {
      'es': 'Muertos a la llegada (DOA)',
      'en': 'Dead on arrival (DOA)',
    },
    'eba_t2_description': {
      'es': 'Conteo al desembarque del % de animales muertos.',
      'en': 'Count at unloading of % of dead animals.',
    },
    'eba_t2_question': {
      'es': '¿Cuál es el porcentaje de muertos al arribo?',
      'en': 'What is the percentage of dead on arrival?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-T3: Densidad de carga
    // ═══════════════════════════════════════════════════════════════════════
    'eba_t3_label': {
      'es': 'Densidad de carga (kg/m²)',
      'en': 'Load density (kg/m²)',
    },
    'eba_t3_description': {
      'es': 'Cálculo de área útil vs peso total según tablas por clima y peso.',
      'en': 'Calculation of useful area vs total weight according to tables by climate and weight.',
    },
    'eba_t3_question': {
      'es': '¿La densidad de carga cumple con las tablas según peso/temperatura?',
      'en': 'Does load density comply with tables by weight/temperature?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-T4: Ayuno pre-transporte
    // ═══════════════════════════════════════════════════════════════════════
    'eba_t4_label': {
      'es': 'Ayuno pre-transporte y agua en espera',
      'en': 'Pre-transport fasting and water during waiting',
    },
    'eba_t4_description': {
      'es': 'Revisión de registros y observación del cumplimiento de ayuno y acceso a agua.',
      'en': 'Record review and observation of fasting compliance and water access.',
    },
    'eba_t4_question': {
      'es': '¿Se cumple el ayuno pre-transporte y el acceso a agua durante la espera?',
      'en': 'Is pre-transport fasting and water access during waiting met?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-S1: Resbalones y caídas
    // ═══════════════════════════════════════════════════════════════════════
    'eba_s1_label': {
      'es': 'Resbalones y caídas',
      'en': 'Slips and falls',
    },
    'eba_s1_description': {
      'es': 'Observación en ventanas de 10 min del % de animales que resbalan/caen durante manejo previo.',
      'en': 'Observation in 10 min windows of % of animals that slip/fall during pre-handling.',
    },
    'eba_s1_question': {
      'es': '¿Qué porcentaje de animales resbala/cae durante el manejo previo?',
      'en': 'What percentage of animals slip/fall during pre-handling?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-S2: Aturdimiento al primer intento
    // ═══════════════════════════════════════════════════════════════════════
    'eba_s2_label': {
      'es': 'Aturdimiento al primer intento',
      'en': 'First attempt stunning',
    },
    'eba_s2_description': {
      'es': 'Auditoría de signos post-aturdimiento. % correctamente aturdidos al primer intento.',
      'en': 'Post-stunning signs audit. % correctly stunned on first attempt.',
    },
    'eba_s2_question': {
      'es': '¿Qué porcentaje de animales es aturdido correctamente al primer intento?',
      'en': 'What percentage of animals are correctly stunned on first attempt?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-S3: Parámetros del equipo
    // ═══════════════════════════════════════════════════════════════════════
    'eba_s3_label': {
      'es': 'Parámetros del equipo',
      'en': 'Equipment parameters',
    },
    'eba_s3_description': {
      'es': 'Revisión técnica de voltaje/corriente/posición/calibración según protocolo.',
      'en': 'Technical review of voltage/current/position/calibration according to protocol.',
    },
    'eba_s3_question': {
      'es': '¿Los parámetros del equipo cumplen el protocolo y la calibración está al día?',
      'en': 'Do equipment parameters meet protocol and is calibration current?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // EBA-S4: Vocalizaciones
    // ═══════════════════════════════════════════════════════════════════════
    'eba_s4_label': {
      'es': 'Vocalizaciones',
      'en': 'Vocalizations',
    },
    'eba_s4_description': {
      'es': 'Conteo por lote del % de animales que vocalizan durante manejo pre-faena.',
      'en': 'Count per batch of % of animals vocalizing during pre-slaughter handling.',
    },
    'eba_s4_question': {
      'es': '¿Qué porcentaje de animales vocaliza durante el manejo pre-faena?',
      'en': 'What percentage of animals vocalize during pre-slaughter handling?',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // MÉTODOS DE EVALUACIÓN
    // ═══════════════════════════════════════════════════════════════════════
    'method_visual_sampling_pigs': {
      'es': 'Inspección visual con muestreo',
      'en': 'Visual inspection with sampling',
    },
    'method_document_inspection_pigs': {
      'es': 'Inspección documental',
      'en': 'Documentary inspection',
    },
    'method_visual_documental_pigs': {
      'es': 'Inspección visual y documental',
      'en': 'Visual and documentary inspection',
    },
    'method_measurement_pigs': {
      'es': 'Medición con equipo',
      'en': 'Equipment measurement',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // CLASIFICACIÓN DE BIENESTAR EBA
    // ═══════════════════════════════════════════════════════════════════════
    'welfare_excellent_pigs': {
      'es': 'GRANJA CON EXCELENTE BIENESTAR',
      'en': 'FARM WITH EXCELLENT WELFARE',
    },
    'welfare_good_pigs': {
      'es': 'GRANJA CON BUEN BIENESTAR',
      'en': 'FARM WITH GOOD WELFARE',
    },
    'welfare_acceptable_pigs': {
      'es': 'GRANJA CON BIENESTAR ACEPTABLE',
      'en': 'FARM WITH ACCEPTABLE WELFARE',
    },
    'welfare_deficient_pigs': {
      'es': 'GRANJA CON BIENESTAR DEFICIENTE',
      'en': 'FARM WITH DEFICIENT WELFARE',
    },
    'welfare_critical_pigs': {
      'es': 'GRANJA CON BIENESTAR CRÍTICO',
      'en': 'FARM WITH CRITICAL WELFARE',
    },

    // ═══════════════════════════════════════════════════════════════════════
    // MENSAJES DE LA APP PARA PORCINOS
    // ═══════════════════════════════════════════════════════════════════════
    'welcome_evaluation_pigs': {
      'es': 'Esta evaluación está basada en la metodología EBA 3.0 para bienestar animal en porcinos.',
      'en': 'This evaluation is based on the EBA 3.0 methodology for pig animal welfare.',
    },
    'eba_methodology': {
      'es': 'Metodología EBA 3.0',
      'en': 'EBA 3.0 Methodology',
    },
  };
}
