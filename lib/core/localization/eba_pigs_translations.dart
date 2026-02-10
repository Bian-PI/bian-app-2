/// Traducciones para la metodología EBA 3.0 - Porcinos
/// Escala de calificación: 0-4

class EbaPigsTranslations {
  static Map<String, Map<String, String>> get translations => {
    // CATEGORÍAS
    'category_resource_pigs': {'es': 'Indicadores de Recurso', 'en': 'Resource Indicators'},
    'category_animal_pigs': {'es': 'Indicadores del Animal', 'en': 'Animal Indicators'},
    'category_management_pigs': {'es': 'Indicadores de Gestión', 'en': 'Management Indicators'},
    'category_transport_pigs': {'es': 'Indicadores de Transporte', 'en': 'Transport Indicators'},
    'category_slaughter_pigs': {'es': 'Indicadores de Sacrificio', 'en': 'Slaughter Indicators'},

    // ESCALA 0-4 
    'scale_0_pigs': {'es': 'No cumple (0)', 'en': 'Non-compliant (0)'},
    'scale_1_pigs': {'es': 'Deficiente (1)', 'en': 'Poor (1)'},
    'scale_2_pigs': {'es': 'Aceptable (2)', 'en': 'Acceptable (2)'},
    'scale_3_pigs': {'es': 'Bueno (3)', 'en': 'Good (3)'},
    'scale_4_pigs': {'es': 'Excelente (4)', 'en': 'Excellent (4)'},

    // ══════════════════════════════════════════════════════════════════
    // EBA-A1: Relación animales por bebedero
    // ══════════════════════════════════════════════════════════════════
    'eba_a1_label': {'es': 'Relación animales por bebedero', 'en': 'Animals per drinker ratio'},
    'eba_a1_description': {'es': 'Conteo de bebederos funcionales y número de animales por categoría.', 'en': 'Count of functional drinkers and number of animals by category.'},
    'eba_a1_question': {'es': '¿Cuántos animales hay por bebedero funcional?', 'en': 'How many animals per functional drinker?'},
    'eba_a1_ranges': {
      'es': '4 pts: Lechones ≤10 | Ceba ≤12 | Gestantes ≤8\n3 pts: Lechones 11-14 | Ceba 13-16 | Gestantes 9-10\n2 pts: Lechones 15-18 | Ceba 17-20 | Gestantes 11-13\n1 pt: Lechones 19-22 | Ceba 21-22 | Gestantes 14-15\n0 pts: Lechones >22 | Ceba >22 | Gestantes >15',
      'en': '4 pts: Piglets ≤10 | Finishing ≤12 | Gestating ≤8\n3 pts: Piglets 11-14 | Finishing 13-16 | Gestating 9-10\n2 pts: Piglets 15-18 | Finishing 17-20 | Gestating 11-13\n1 pt: Piglets 19-22 | Finishing 21-22 | Gestating 14-15\n0 pts: Piglets >22 | Finishing >22 | Gestating >15'
    },

    // EBA-A2: Caudal de bebedero
    'eba_a2_label': {'es': 'Caudal del bebedero', 'en': 'Drinker flow rate'},
    'eba_a2_description': {'es': 'Medición del caudal con probeta en 30 segundos.', 'en': 'Flow measurement with graduated cylinder in 30 seconds.'},
    'eba_a2_question': {'es': '¿El caudal abastece los requerimientos?', 'en': 'Does the flow rate meet requirements?'},
    'eba_a2_ranges': {
      'es': '4 pts: Lechones 0.6-1.0 L/min | Ceba/Gestantes 1.0-1.5 L/min\n3 pts: Lechones 0.4-0.6 | Ceba/Gestantes 0.8-1.0\n2 pts: Lechones 0.3-0.4 | Ceba/Gestantes 0.6-0.8\n1 pt: Lechones 0.2-0.3 | Ceba/Gestantes 0.4-0.6\n0 pts: <0.2 L/min',
      'en': '4 pts: Piglets 0.6-1.0 L/min | Finishing/Gestating 1.0-1.5 L/min\n3 pts: Piglets 0.4-0.6 | Finishing/Gestating 0.8-1.0\n2 pts: Piglets 0.3-0.4 | Finishing/Gestating 0.6-0.8\n1 pt: Piglets 0.2-0.3 | Finishing/Gestating 0.4-0.6\n0 pts: <0.2 L/min'
    },

    // EBA-A3: Calidad microbiológica del agua
    'eba_a3_label': {'es': 'Calidad microbiológica del agua', 'en': 'Water microbiological quality'},
    'eba_a3_description': {'es': 'Análisis de laboratorio para coliformes totales y E. coli.', 'en': 'Laboratory analysis for total coliforms and E. coli.'},
    'eba_a3_question': {'es': '¿Coliformes y E. coli cumplen norma?', 'en': 'Do coliforms and E. coli meet standards?'},
    'eba_a3_ranges': {
      'es': '4 pts: Sin coliformes ni E. coli detectados\n3 pts: Coliformes <10 UFC/100ml, sin E. coli\n2 pts: Coliformes 10-50 UFC/100ml, sin E. coli\n1 pt: Coliformes 50-100 UFC/100ml o E. coli presente bajo\n0 pts: Coliformes >100 UFC/100ml o E. coli alto',
      'en': '4 pts: No coliforms or E. coli detected\n3 pts: Coliforms <10 CFU/100ml, no E. coli\n2 pts: Coliforms 10-50 CFU/100ml, no E. coli\n1 pt: Coliforms 50-100 CFU/100ml or low E. coli\n0 pts: Coliforms >100 CFU/100ml or high E. coli'
    },

    // EBA-F1: Espacios de comedero
    'eba_f1_label': {'es': 'Espacios de comedero suficientes', 'en': 'Sufficient feeder spaces'},
    'eba_f1_description': {'es': 'Conteo de espacios de comedero y observación de competencia.', 'en': 'Feeder space count and competition observation.'},
    'eba_f1_question': {'es': '¿Relación animales:comedero adecuada?', 'en': 'Is animal-to-feeder ratio adequate?'},
    'eba_f1_ranges': {
      'es': '4 pts: Lechones ≤4 | Ceba ≤6 | Gestantes ≤5 anim/espacio\n3 pts: Lechones 5-6 | Ceba 7-8 | Gestantes 6-7\n2 pts: Lechones 7-8 | Ceba 9-10 | Gestantes 8-9\n1 pt: Lechones 9-10 | Ceba 11-12 | Gestantes 10-11\n0 pts: Lechones >10 | Ceba >12 | Gestantes >11',
      'en': '4 pts: Piglets ≤4 | Finishing ≤6 | Gestating ≤5 anim/space\n3 pts: Piglets 5-6 | Finishing 7-8 | Gestating 6-7\n2 pts: Piglets 7-8 | Finishing 9-10 | Gestating 8-9\n1 pt: Piglets 9-10 | Finishing 11-12 | Gestating 10-11\n0 pts: Piglets >10 | Finishing >12 | Gestating >11'
    },

    // EBA-F2: Condición corporal
    'eba_f2_label': {'es': 'Condición corporal (CC)', 'en': 'Body condition score (BCS)'},
    'eba_f2_description': {'es': 'Evaluación visual y táctil de condición corporal.', 'en': 'Visual and tactile body condition assessment.'},
    'eba_f2_question': {'es': '¿% animales con CC <2.5/5?', 'en': '% animals with BCS <2.5/5?'},
    'eba_f2_ranges': {
      'es': '4 pts: 0-2% animales con CC <2.5\n3 pts: 3-5% animales con CC <2.5\n2 pts: 6-10% animales con CC <2.5\n1 pt: 11-15% animales con CC <2.5\n0 pts: >15% animales con CC <2.5',
      'en': '4 pts: 0-2% animals with BCS <2.5\n3 pts: 3-5% animals with BCS <2.5\n2 pts: 6-10% animals with BCS <2.5\n1 pt: 11-15% animals with BCS <2.5\n0 pts: >15% animals with BCS <2.5'
    },

    // EBA-F3: Tiempo de acceso
    'eba_f3_label': {'es': 'Tiempo de acceso tras reparto', 'en': 'Access time after feeding'},
    'eba_f3_description': {'es': 'Cronometría hasta que todos acceden sin competencia.', 'en': 'Timing until all access without competition.'},
    'eba_f3_question': {'es': '¿Tiempo hasta que todos acceden?', 'en': 'Time until all access?'},
    'eba_f3_ranges': {
      'es': '4 pts: ≤2 minutos\n3 pts: 2-4 minutos\n2 pts: 4-6 minutos\n1 pt: 6-10 minutos\n0 pts: >10 minutos o competencia severa',
      'en': '4 pts: ≤2 minutes\n3 pts: 2-4 minutes\n2 pts: 4-6 minutes\n1 pt: 6-10 minutes\n0 pts: >10 minutes or severe competition'
    },

    // EBA-E1: THI
    'eba_e1_label': {'es': 'Índice temperatura-humedad (THI)', 'en': 'Temperature-Humidity Index (THI)'},
    'eba_e1_description': {'es': 'Medir temperatura y humedad relativa en horas críticas.', 'en': 'Measure temperature and relative humidity during critical hours.'},
    'eba_e1_question': {'es': '¿Índice THI en horas críticas?', 'en': 'THI during critical hours?'},
    'eba_e1_ranges': {
      'es': '4 pts: THI ≤70\n3 pts: THI 71-74\n2 pts: THI 75-78\n1 pt: THI 79-82\n0 pts: THI >82',
      'en': '4 pts: THI ≤70\n3 pts: THI 71-74\n2 pts: THI 75-78\n1 pt: THI 79-82\n0 pts: THI >82'
    },

    // EBA-E2: Amoníaco
    'eba_e2_label': {'es': 'Nivel de amoníaco (NH₃)', 'en': 'Ammonia level (NH₃)'},
    'eba_e2_description': {'es': 'Medición a nivel del hocico con sensor calibrado.', 'en': 'Measurement at snout level with calibrated sensor.'},
    'eba_e2_question': {'es': '¿ppm de NH₃ a nivel del hocico?', 'en': 'ppm of NH₃ at snout level?'},
    'eba_e2_ranges': {
      'es': '4 pts: ≤10 ppm\n3 pts: 11-15 ppm\n2 pts: 16-20 ppm\n1 pt: 21-25 ppm\n0 pts: >25 ppm',
      'en': '4 pts: ≤10 ppm\n3 pts: 11-15 ppm\n2 pts: 16-20 ppm\n1 pt: 21-25 ppm\n0 pts: >25 ppm'
    },

    // EBA-E3: CO2
    'eba_e3_label': {'es': 'Nivel de CO₂', 'en': 'CO₂ level'},
    'eba_e3_description': {'es': 'Medición con sensor calibrado a nivel del hocico.', 'en': 'Measurement with calibrated sensor at snout level.'},
    'eba_e3_question': {'es': '¿ppm de CO₂ a nivel del hocico?', 'en': 'ppm of CO₂ at snout level?'},
    'eba_e3_ranges': {
      'es': '4 pts: ≤2000 ppm\n3 pts: 2001-2500 ppm\n2 pts: 2501-3000 ppm\n1 pt: 3001-4000 ppm\n0 pts: >4000 ppm',
      'en': '4 pts: ≤2000 ppm\n3 pts: 2001-2500 ppm\n2 pts: 2501-3000 ppm\n1 pt: 3001-4000 ppm\n0 pts: >4000 ppm'
    },

    // EBA-E4: Ruido
    'eba_e4_label': {'es': 'Nivel de ruido', 'en': 'Noise level'},
    'eba_e4_description': {'es': 'Medición con sonómetro, promedio de 5 minutos.', 'en': 'Measurement with sound meter, 5-minute average.'},
    'eba_e4_question': {'es': '¿Nivel de ruido promedio?', 'en': 'Average noise level?'},
    'eba_e4_ranges': {
      'es': '4 pts: ≤65 dB(A)\n3 pts: 66-75 dB(A)\n2 pts: 76-85 dB(A)\n1 pt: 86-95 dB(A)\n0 pts: >95 dB(A)',
      'en': '4 pts: ≤65 dB(A)\n3 pts: 66-75 dB(A)\n2 pts: 76-85 dB(A)\n1 pt: 86-95 dB(A)\n0 pts: >95 dB(A)'
    },

    // EBA-E5: Iluminación
    'eba_e5_label': {'es': 'Iluminación mínima', 'en': 'Minimum lighting'},
    'eba_e5_description': {'es': 'Medición con luxómetro en 5 puntos representativos.', 'en': 'Measurement with lux meter at 5 representative points.'},
    'eba_e5_question': {'es': '¿Iluminación mínima diurna?', 'en': 'Minimum daytime lighting?'},
    'eba_e5_ranges': {
      'es': '4 pts: ≥80 lux\n3 pts: 60-79 lux\n2 pts: 40-59 lux\n1 pt: 20-39 lux\n0 pts: <20 lux',
      'en': '4 pts: ≥80 lux\n3 pts: 60-79 lux\n2 pts: 40-59 lux\n1 pt: 20-39 lux\n0 pts: <20 lux'
    },

    // EBA-I1: Densidad
    'eba_i1_label': {'es': 'Densidad de alojamiento', 'en': 'Housing density'},
    'eba_i1_description': {'es': 'Medición de área y conteo de animales.', 'en': 'Area measurement and animal count.'},
    'eba_i1_question': {'es': '¿m² por animal según peso?', 'en': 'm² per animal by weight?'},
    'eba_i1_ranges': {
      'es': '4 pts: ≥0.8 m²/animal (≥110kg)\n3 pts: 0.65-0.79 m²/animal\n2 pts: 0.5-0.64 m²/animal\n1 pt: 0.4-0.49 m²/animal\n0 pts: <0.4 m²/animal',
      'en': '4 pts: ≥0.8 m²/animal (≥110kg)\n3 pts: 0.65-0.79 m²/animal\n2 pts: 0.5-0.64 m²/animal\n1 pt: 0.4-0.49 m²/animal\n0 pts: <0.4 m²/animal'
    },

    // EBA-I2: Pisos
    'eba_i2_label': {'es': 'Estado de los pisos', 'en': 'Floor condition'},
    'eba_i2_description': {'es': 'Inspección de superficie en busca de daños lesivos.', 'en': 'Surface inspection for injurious damage.'},
    'eba_i2_question': {'es': '¿% superficie con daños lesivos?', 'en': '% surface with injurious damage?'},
    'eba_i2_ranges': {
      'es': '4 pts: 0-2% superficie dañada\n3 pts: 3-5% superficie dañada\n2 pts: 6-10% superficie dañada\n1 pt: 11-20% superficie dañada\n0 pts: >20% superficie dañada',
      'en': '4 pts: 0-2% damaged surface\n3 pts: 3-5% damaged surface\n2 pts: 6-10% damaged surface\n1 pt: 11-20% damaged surface\n0 pts: >20% damaged surface'
    },

    // EBA-I3: Área seca
    'eba_i3_label': {'es': 'Área de descanso seca', 'en': 'Dry resting area'},
    'eba_i3_description': {'es': 'Inspección visual de superficie seca para descanso.', 'en': 'Visual inspection of dry surface for resting.'},
    'eba_i3_question': {'es': '¿% área de descanso seca?', 'en': '% dry resting area?'},
    'eba_i3_ranges': {
      'es': '4 pts: ≥95% seca\n3 pts: 85-94% seca\n2 pts: 70-84% seca\n1 pt: 50-69% seca\n0 pts: <50% seca',
      'en': '4 pts: ≥95% dry\n3 pts: 85-94% dry\n2 pts: 70-84% dry\n1 pt: 50-69% dry\n0 pts: <50% dry'
    },

    // EBA-I4: Suciedad
    'eba_i4_label': {'es': 'Suciedad corporal', 'en': 'Body dirtiness'},
    'eba_i4_description': {'es': 'Evaluar porcentaje de animales con cuerpo sucio.', 'en': 'Evaluate percentage of animals with dirty body.'},
    'eba_i4_question': {'es': '¿% con ≥20% cuerpo sucio?', 'en': '% with ≥20% body dirty?'},
    'eba_i4_ranges': {
      'es': '4 pts: 0-3% animales sucios\n3 pts: 4-10% animales sucios\n2 pts: 11-20% animales sucios\n1 pt: 21-35% animales sucios\n0 pts: >35% animales sucios',
      'en': '4 pts: 0-3% dirty animals\n3 pts: 4-10% dirty animals\n2 pts: 11-20% dirty animals\n1 pt: 21-35% dirty animals\n0 pts: >35% dirty animals'
    },

    // EBA-I5: Material manipulable
    'eba_i5_label': {'es': 'Material manipulable disponible', 'en': 'Available manipulable material'},
    'eba_i5_description': {'es': 'Checklist de materiales de enriquecimiento por corral.', 'en': 'Enrichment materials checklist per pen.'},
    'eba_i5_question': {'es': '¿% corrales con material manipulable?', 'en': '% pens with manipulable material?'},
    'eba_i5_ranges': {
      'es': '4 pts: ≥95% corrales con material\n3 pts: 80-94% corrales con material\n2 pts: 60-79% corrales con material\n1 pt: 40-59% corrales con material\n0 pts: <40% corrales con material',
      'en': '4 pts: ≥95% pens with material\n3 pts: 80-94% pens with material\n2 pts: 60-79% pens with material\n1 pt: 40-59% pens with material\n0 pts: <40% pens with material'
    },

    // EBA-R1: GMD
    'eba_r1_label': {'es': 'Ganancia media diaria (GMD)', 'en': 'Average daily gain (ADG)'},
    'eba_r1_description': {'es': 'Cálculo a partir de pesajes del lote.', 'en': 'Calculation from batch weighings.'},
    'eba_r1_question': {'es': '¿GMD promedio del lote?', 'en': 'Average ADG of batch?'},
    'eba_r1_ranges': {
      'es': '4 pts: ≥850 g/día\n3 pts: 750-849 g/día\n2 pts: 650-749 g/día\n1 pt: 550-649 g/día\n0 pts: <550 g/día',
      'en': '4 pts: ≥850 g/day\n3 pts: 750-849 g/day\n2 pts: 650-749 g/day\n1 pt: 550-649 g/day\n0 pts: <550 g/day'
    },

    // EBA-L3: Temperatura nido
    'eba_l3_label': {'es': 'Temperatura del nido/placa', 'en': 'Nest/heating pad temperature'},
    'eba_l3_description': {'es': 'Medición de temperatura para neonatos en área de calor.', 'en': 'Temperature measurement for neonates in heating area.'},
    'eba_l3_question': {'es': '¿Temperatura en rango para neonatos?', 'en': 'Temperature in range for neonates?'},
    'eba_l3_ranges': {
      'es': '4 pts: 100% del tiempo en rango (32-35°C)\n3 pts: 90-99% en rango\n2 pts: 75-89% en rango\n1 pt: 50-74% en rango\n0 pts: <50% en rango',
      'en': '4 pts: 100% of time in range (32-35°C)\n3 pts: 90-99% in range\n2 pts: 75-89% in range\n1 pt: 50-74% in range\n0 pts: <50% in range'
    },

    // EBA-H1: Cojeras
    'eba_h1_label': {'es': 'Cojeras', 'en': 'Lameness'},
    'eba_h1_description': {'es': 'Observación de marcha en muestra representativa.', 'en': 'Gait observation in representative sample.'},
    'eba_h1_question': {'es': '¿% con locomoción anormal?', 'en': '% with abnormal locomotion?'},
    'eba_h1_ranges': {
      'es': '4 pts: 0-1% con cojera\n3 pts: 2-3% con cojera\n2 pts: 4-6% con cojera\n1 pt: 7-10% con cojera\n0 pts: >10% con cojera',
      'en': '4 pts: 0-1% with lameness\n3 pts: 2-3% with lameness\n2 pts: 4-6% with lameness\n1 pt: 7-10% with lameness\n0 pts: >10% with lameness'
    },

    // EBA-H2: Lesiones tegumentarias
    'eba_h2_label': {'es': 'Lesiones tegumentarias', 'en': 'Skin lesions'},
    'eba_h2_description': {'es': 'Inspección de heridas y raspones mayores a 2cm.', 'en': 'Inspection of wounds and scrapes larger than 2cm.'},
    'eba_h2_question': {'es': '¿% con heridas >2cm?', 'en': '% with wounds >2cm?'},
    'eba_h2_ranges': {
      'es': '4 pts: 0-2% con lesiones\n3 pts: 3-5% con lesiones\n2 pts: 6-10% con lesiones\n1 pt: 11-20% con lesiones\n0 pts: >20% con lesiones',
      'en': '4 pts: 0-2% with lesions\n3 pts: 3-5% with lesions\n2 pts: 6-10% with lesions\n1 pt: 11-20% with lesions\n0 pts: >20% with lesions'
    },

    // EBA-H3: Tos y estornudos
    'eba_h3_label': {'es': 'Tos y estornudos', 'en': 'Coughing and sneezing'},
    'eba_h3_description': {'es': 'Observación durante 10 minutos por corral.', 'en': '10-minute observation per pen.'},
    'eba_h3_question': {'es': '¿Eventos tos/estornudo por animal/min?', 'en': 'Cough/sneeze events per animal/min?'},
    'eba_h3_ranges': {
      'es': '4 pts: ≤0.05 eventos/animal/min\n3 pts: 0.06-0.10 eventos/animal/min\n2 pts: 0.11-0.20 eventos/animal/min\n1 pt: 0.21-0.40 eventos/animal/min\n0 pts: >0.40 eventos/animal/min',
      'en': '4 pts: ≤0.05 events/animal/min\n3 pts: 0.06-0.10 events/animal/min\n2 pts: 0.11-0.20 events/animal/min\n1 pt: 0.21-0.40 events/animal/min\n0 pts: >0.40 events/animal/min'
    },

    // EBA-H4: Diarrea
    'eba_h4_label': {'es': 'Diarrea', 'en': 'Diarrhea'},
    'eba_h4_description': {'es': 'Observación de perineo sucio como indicador.', 'en': 'Observation of dirty perineum as indicator.'},
    'eba_h4_question': {'es': '¿% con diarrea/perineo sucio?', 'en': '% with diarrhea/dirty perineum?'},
    'eba_h4_ranges': {
      'es': '4 pts: 0-2% con diarrea\n3 pts: 3-5% con diarrea\n2 pts: 6-10% con diarrea\n1 pt: 11-20% con diarrea\n0 pts: >20% con diarrea',
      'en': '4 pts: 0-2% with diarrhea\n3 pts: 3-5% with diarrhea\n2 pts: 6-10% with diarrhea\n1 pt: 11-20% with diarrhea\n0 pts: >20% with diarrhea'
    },

    // EBA-H5: Mortalidad
    'eba_h5_label': {'es': 'Mortalidad del lote', 'en': 'Batch mortality'},
    'eba_h5_description': {'es': 'Revisión de registros de mortalidad del ciclo.', 'en': 'Review of cycle mortality records.'},
    'eba_h5_question': {'es': '¿% mortalidad del ciclo?', 'en': 'Cycle mortality %?'},
    'eba_h5_ranges': {
      'es': '4 pts: ≤1% engorde | ≤0.5% reproductoras\n3 pts: 1.1-2% engorde | 0.6-1% reprod.\n2 pts: 2.1-3% engorde | 1.1-1.5% reprod.\n1 pt: 3.1-4% engorde | 1.6-2% reprod.\n0 pts: >4% engorde | >2% reproductoras',
      'en': '4 pts: ≤1% finishing | ≤0.5% breeding\n3 pts: 1.1-2% finishing | 0.6-1% breeding\n2 pts: 2.1-3% finishing | 1.1-1.5% breeding\n1 pt: 3.1-4% finishing | 1.6-2% breeding\n0 pts: >4% finishing | >2% breeding'
    },

    // EBA-H6: Analgesia
    'eba_h6_label': {'es': 'Analgesia/anestesia en procedimientos', 'en': 'Analgesia/anesthesia in procedures'},
    'eba_h6_description': {'es': 'Auditoría de uso de analgesia en procedimientos dolorosos.', 'en': 'Audit of analgesia use in painful procedures.'},
    'eba_h6_question': {'es': '¿% procedimientos con analgesia?', 'en': '% procedures with analgesia?'},
    'eba_h6_ranges': {
      'es': '4 pts: 100% con protocolo de analgesia\n3 pts: 90-99% con analgesia\n2 pts: 75-89% con analgesia\n1 pt: 50-74% con analgesia\n0 pts: <50% con analgesia',
      'en': '4 pts: 100% with analgesia protocol\n3 pts: 90-99% with analgesia\n2 pts: 75-89% with analgesia\n1 pt: 50-74% with analgesia\n0 pts: <50% with analgesia'
    },

    // EBA-H8: Cicatrices cola
    'eba_h8_label': {'es': 'Cicatrices de cola', 'en': 'Tail scars'},
    'eba_h8_description': {'es': 'Inspección de lesiones crónicas en cola.', 'en': 'Inspection of chronic tail injuries.'},
    'eba_h8_question': {'es': '¿% con cicatrices en cola?', 'en': '% with tail scars?'},
    'eba_h8_ranges': {
      'es': '4 pts: 0-2% con cicatrices\n3 pts: 3-5% con cicatrices\n2 pts: 6-10% con cicatrices\n1 pt: 11-20% con cicatrices\n0 pts: >20% con cicatrices',
      'en': '4 pts: 0-2% with scars\n3 pts: 3-5% with scars\n2 pts: 6-10% with scars\n1 pt: 11-20% with scars\n0 pts: >20% with scars'
    },

    // EBA-B1: Peleas
    'eba_b1_label': {'es': 'Peleas (>3 segundos)', 'en': 'Fights (>3 seconds)'},
    'eba_b1_description': {'es': 'Observación de 10 min, 3 repeticiones por corral.', 'en': '10-min observation, 3 repetitions per pen.'},
    'eba_b1_question': {'es': '¿Peleas >3s en 10 min/corral?', 'en': 'Fights >3s in 10 min/pen?'},
    'eba_b1_ranges': {
      'es': '4 pts: 0-1 peleas en 10 min\n3 pts: 2-3 peleas en 10 min\n2 pts: 4-6 peleas en 10 min\n1 pt: 7-10 peleas en 10 min\n0 pts: >10 peleas en 10 min',
      'en': '4 pts: 0-1 fights in 10 min\n3 pts: 2-3 fights in 10 min\n2 pts: 4-6 fights in 10 min\n1 pt: 7-10 fights in 10 min\n0 pts: >10 fights in 10 min'
    },

    // EBA-B2: Uso enriquecimiento
    'eba_b2_label': {'es': 'Uso de enriquecimiento', 'en': 'Enrichment use'},
    'eba_b2_description': {'es': 'Scan sampling durante 5 minutos de observación.', 'en': 'Scan sampling during 5 minutes of observation.'},
    'eba_b2_question': {'es': '¿% interactúa con enriquecimiento?', 'en': '% interact with enrichment?'},
    'eba_b2_ranges': {
      'es': '4 pts: ≥60% interactuando\n3 pts: 45-59% interactuando\n2 pts: 30-44% interactuando\n1 pt: 15-29% interactuando\n0 pts: <15% interactuando',
      'en': '4 pts: ≥60% interacting\n3 pts: 45-59% interacting\n2 pts: 30-44% interacting\n1 pt: 15-29% interacting\n0 pts: <15% interacting'
    },

    // EBA-B3: Huida
    'eba_b3_label': {'es': 'Huida al acercamiento humano', 'en': 'Flight from human approach'},
    'eba_b3_description': {'es': 'Walk test: caminar lento entre animales.', 'en': 'Walk test: slow walking among animals.'},
    'eba_b3_question': {'es': '¿% huye >1m ante acercamiento?', 'en': '% flee >1m upon approach?'},
    'eba_b3_ranges': {
      'es': '4 pts: 0-10% huyen >1m\n3 pts: 11-25% huyen >1m\n2 pts: 26-40% huyen >1m\n1 pt: 41-60% huyen >1m\n0 pts: >60% huyen >1m',
      'en': '4 pts: 0-10% flee >1m\n3 pts: 11-25% flee >1m\n2 pts: 26-40% flee >1m\n1 pt: 41-60% flee >1m\n0 pts: >60% flee >1m'
    },

    // EBA-R2: Colas mordidas
    'eba_r2_label': {'es': 'Colas mordidas activas', 'en': 'Active tail biting'},
    'eba_r2_description': {'es': 'Inspección de lesiones recientes en cola.', 'en': 'Inspection of recent tail injuries.'},
    'eba_r2_question': {'es': '¿% con lesiones recientes en cola?', 'en': '% with recent tail injuries?'},
    'eba_r2_ranges': {
      'es': '4 pts: 0-1% con mordeduras activas\n3 pts: 2-3% con mordeduras activas\n2 pts: 4-6% con mordeduras activas\n1 pt: 7-10% con mordeduras activas\n0 pts: >10% con mordeduras activas',
      'en': '4 pts: 0-1% with active biting\n3 pts: 2-3% with active biting\n2 pts: 4-6% with active biting\n1 pt: 7-10% with active biting\n0 pts: >10% with active biting'
    },

    // EBA-L1: Mortalidad predestete
    'eba_l1_label': {'es': 'Mortalidad predestete', 'en': 'Pre-weaning mortality'},
    'eba_l1_description': {'es': 'Revisión de planillas de nacimiento a destete.', 'en': 'Review of birth to weaning records.'},
    'eba_l1_question': {'es': '¿% mortalidad nacimiento-destete?', 'en': '% mortality birth-weaning?'},
    'eba_l1_ranges': {
      'es': '4 pts: ≤8% mortalidad\n3 pts: 9-12% mortalidad\n2 pts: 13-16% mortalidad\n1 pt: 17-22% mortalidad\n0 pts: >22% mortalidad',
      'en': '4 pts: ≤8% mortality\n3 pts: 9-12% mortality\n2 pts: 13-16% mortality\n1 pt: 17-22% mortality\n0 pts: >22% mortality'
    },

    // EBA-L2: Aplastamientos
    'eba_l2_label': {'es': 'Aplastamientos', 'en': 'Crushing deaths'},
    'eba_l2_description': {'es': 'Clasificación de causa de muerte de lechones.', 'en': 'Classification of piglet death cause.'},
    'eba_l2_question': {'es': '¿% muertos por aplastamiento?', 'en': '% dead by crushing?'},
    'eba_l2_ranges': {
      'es': '4 pts: ≤3% por aplastamiento\n3 pts: 4-6% por aplastamiento\n2 pts: 7-10% por aplastamiento\n1 pt: 11-15% por aplastamiento\n0 pts: >15% por aplastamiento',
      'en': '4 pts: ≤3% by crushing\n3 pts: 4-6% by crushing\n2 pts: 7-10% by crushing\n1 pt: 11-15% by crushing\n0 pts: >15% by crushing'
    },

    // EBA-G1: Gestantes en grupo
    'eba_g1_label': {'es': 'Gestantes en grupo', 'en': 'Group-housed gestating sows'},
    'eba_g1_description': {'es': 'Censo de alojamiento grupal vs individual.', 'en': 'Census of group vs individual housing.'},
    'eba_g1_question': {'es': '¿% gestantes en alojamiento grupal?', 'en': '% gestating sows in group housing?'},
    'eba_g1_ranges': {
      'es': '4 pts: ≥90% en grupo\n3 pts: 75-89% en grupo\n2 pts: 50-74% en grupo\n1 pt: 25-49% en grupo\n0 pts: <25% en grupo',
      'en': '4 pts: ≥90% in group\n3 pts: 75-89% in group\n2 pts: 50-74% in group\n1 pt: 25-49% in group\n0 pts: <25% in group'
    },

    // EBA-P1: Capacitación
    'eba_p1_label': {'es': 'Capacitación en bienestar animal', 'en': 'Animal welfare training'},
    'eba_p1_description': {'es': 'Revisión de certificados de capacitación anual.', 'en': 'Review of annual training certificates.'},
    'eba_p1_question': {'es': '¿% personal con capacitación anual?', 'en': '% staff with annual training?'},
    'eba_p1_ranges': {
      'es': '4 pts: ≥90% personal capacitado\n3 pts: 75-89% capacitado\n2 pts: 50-74% capacitado\n1 pt: 25-49% capacitado\n0 pts: <25% capacitado',
      'en': '4 pts: ≥90% staff trained\n3 pts: 75-89% trained\n2 pts: 50-74% trained\n1 pt: 25-49% trained\n0 pts: <25% trained'
    },

    // EBA-D1: SOPs
    'eba_d1_label': {'es': 'Procedimientos escritos (SOPs)', 'en': 'Written procedures (SOPs)'},
    'eba_d1_description': {'es': 'Auditoría de SOPs críticos y evidencia de aplicación.', 'en': 'Critical SOPs audit and application evidence.'},
    'eba_d1_question': {'es': '¿SOPs críticos existen y se aplican?', 'en': 'Do critical SOPs exist and are applied?'},
    'eba_d1_ranges': {
      'es': '4 pts: SOPs actualizados + evidencia de aplicación\n3 pts: SOPs actualizados, evidencia parcial\n2 pts: SOPs desactualizados pero aplicados\n1 pt: SOPs incompletos o no aplicados\n0 pts: Sin SOPs críticos',
      'en': '4 pts: Updated SOPs + application evidence\n3 pts: Updated SOPs, partial evidence\n2 pts: Outdated SOPs but applied\n1 pt: Incomplete SOPs or not applied\n0 pts: No critical SOPs'
    },

    // EBA-D2: Plan contingencia
    'eba_d2_label': {'es': 'Plan de contingencia', 'en': 'Contingency plan'},
    'eba_d2_description': {'es': 'Auditoría de plan de emergencias y simulacros.', 'en': 'Emergency plan and drills audit.'},
    'eba_d2_question': {'es': '¿Plan de contingencia con simulacros?', 'en': 'Contingency plan with drills?'},
    'eba_d2_ranges': {
      'es': '4 pts: Plan vigente + simulacro anual realizado\n3 pts: Plan vigente, simulacro >1 año\n2 pts: Plan desactualizado, sin simulacro reciente\n1 pt: Plan incompleto\n0 pts: Sin plan de contingencia',
      'en': '4 pts: Current plan + annual drill done\n3 pts: Current plan, drill >1 year\n2 pts: Outdated plan, no recent drill\n1 pt: Incomplete plan\n0 pts: No contingency plan'
    },

    // EBA-T1: No ambulatorios
    'eba_t1_label': {'es': 'Animales no ambulatorios', 'en': 'Non-ambulatory animals'},
    'eba_t1_description': {'es': 'Conteo al momento del desembarque.', 'en': 'Count at unloading time.'},
    'eba_t1_question': {'es': '¿% no ambulatorios al arribo?', 'en': '% non-ambulatory at arrival?'},
    'eba_t1_ranges': {
      'es': '4 pts: 0-0.05%\n3 pts: 0.06-0.1%\n2 pts: 0.11-0.2%\n1 pt: 0.21-0.5%\n0 pts: >0.5%',
      'en': '4 pts: 0-0.05%\n3 pts: 0.06-0.1%\n2 pts: 0.11-0.2%\n1 pt: 0.21-0.5%\n0 pts: >0.5%'
    },

    // EBA-T2: DOA
    'eba_t2_label': {'es': 'Muertos a la llegada (DOA)', 'en': 'Dead on arrival (DOA)'},
    'eba_t2_description': {'es': 'Conteo de animales muertos al desembarque.', 'en': 'Count of dead animals at unloading.'},
    'eba_t2_question': {'es': '¿% muertos al arribo?', 'en': '% dead at arrival?'},
    'eba_t2_ranges': {
      'es': '4 pts: 0-0.03%\n3 pts: 0.04-0.06%\n2 pts: 0.07-0.1%\n1 pt: 0.11-0.2%\n0 pts: >0.2%',
      'en': '4 pts: 0-0.03%\n3 pts: 0.04-0.06%\n2 pts: 0.07-0.1%\n1 pt: 0.11-0.2%\n0 pts: >0.2%'
    },

    // EBA-T3: Densidad carga
    'eba_t3_label': {'es': 'Densidad de carga', 'en': 'Load density'},
    'eba_t3_description': {'es': 'Cálculo de área disponible vs peso de animales.', 'en': 'Calculation of available area vs animal weight.'},
    'eba_t3_question': {'es': '¿Densidad de carga adecuada?', 'en': 'Adequate load density?'},
    'eba_t3_ranges': {
      'es': '4 pts: Cumple 100% tablas según peso y clima\n3 pts: Cumple 90-99%\n2 pts: Cumple 75-89%\n1 pt: Cumple 50-74%\n0 pts: <50% cumplimiento',
      'en': '4 pts: Meets 100% tables by weight and climate\n3 pts: Meets 90-99%\n2 pts: Meets 75-89%\n1 pt: Meets 50-74%\n0 pts: <50% compliance'
    },

    // EBA-T4: Ayuno
    'eba_t4_label': {'es': 'Ayuno y agua pre-transporte', 'en': 'Pre-transport fasting and water'},
    'eba_t4_description': {'es': 'Revisión de protocolo de ayuno y acceso a agua.', 'en': 'Review of fasting protocol and water access.'},
    'eba_t4_question': {'es': '¿Cumple ayuno y acceso a agua?', 'en': 'Meets fasting and water access?'},
    'eba_t4_ranges': {
      'es': '4 pts: Cumple ayuno (12-18h) + agua hasta embarque\n3 pts: Cumple uno de los dos protocolos\n2 pts: Ayuno inadecuado pero con agua\n1 pt: Sin agua pero ayuno correcto\n0 pts: No cumple ninguno',
      'en': '4 pts: Meets fasting (12-18h) + water until loading\n3 pts: Meets one of two protocols\n2 pts: Inadequate fasting but with water\n1 pt: No water but correct fasting\n0 pts: Meets neither'
    },

    // EBA-S1: Resbalones
    'eba_s1_label': {'es': 'Resbalones y caídas', 'en': 'Slips and falls'},
    'eba_s1_description': {'es': 'Observación durante manejo previo al sacrificio.', 'en': 'Observation during pre-slaughter handling.'},
    'eba_s1_question': {'es': '¿% resbala/cae en manejo previo?', 'en': '% slipping/falling during prior handling?'},
    'eba_s1_ranges': {
      'es': '4 pts: ≤1% resbala o cae\n3 pts: 2-3% resbala o cae\n2 pts: 4-6% resbala o cae\n1 pt: 7-10% resbala o cae\n0 pts: >10% resbala o cae',
      'en': '4 pts: ≤1% slip or fall\n3 pts: 2-3% slip or fall\n2 pts: 4-6% slip or fall\n1 pt: 7-10% slip or fall\n0 pts: >10% slip or fall'
    },

    // EBA-S2: Aturdimiento
    'eba_s2_label': {'es': 'Aturdimiento al primer intento', 'en': 'First-attempt stunning'},
    'eba_s2_description': {'es': 'Auditoría de signos post-aturdimiento.', 'en': 'Post-stunning signs audit.'},
    'eba_s2_question': {'es': '¿% aturdidos al primer intento?', 'en': '% stunned on first attempt?'},
    'eba_s2_ranges': {
      'es': '4 pts: ≥98% efectivo al primer intento\n3 pts: 95-97% efectivo\n2 pts: 90-94% efectivo\n1 pt: 80-89% efectivo\n0 pts: <80% efectivo',
      'en': '4 pts: ≥98% effective on first attempt\n3 pts: 95-97% effective\n2 pts: 90-94% effective\n1 pt: 80-89% effective\n0 pts: <80% effective'
    },

    // EBA-S3: Parámetros equipo
    'eba_s3_label': {'es': 'Parámetros del equipo', 'en': 'Equipment parameters'},
    'eba_s3_description': {'es': 'Revisión técnica y registros de calibración.', 'en': 'Technical review and calibration records.'},
    'eba_s3_question': {'es': '¿Parámetros cumplen protocolo?', 'en': 'Parameters meet protocol?'},
    'eba_s3_ranges': {
      'es': '4 pts: Parámetros correctos + calibración vigente\n3 pts: Parámetros correctos, calibración vencida <1 mes\n2 pts: Desviación menor en parámetros\n1 pt: Desviación significativa\n0 pts: Sin calibración o parámetros incorrectos',
      'en': '4 pts: Correct parameters + current calibration\n3 pts: Correct parameters, calibration expired <1 month\n2 pts: Minor parameter deviation\n1 pt: Significant deviation\n0 pts: No calibration or incorrect parameters'
    },

    // EBA-S4: Vocalizaciones
    'eba_s4_label': {'es': 'Vocalizaciones', 'en': 'Vocalizations'},
    'eba_s4_description': {'es': 'Conteo durante manejo pre-faena.', 'en': 'Count during pre-slaughter handling.'},
    'eba_s4_question': {'es': '¿% vocaliza en manejo pre-faena?', 'en': '% vocalizing during pre-slaughter?'},
    'eba_s4_ranges': {
      'es': '4 pts: ≤3% vocaliza\n3 pts: 4-6% vocaliza\n2 pts: 7-10% vocaliza\n1 pt: 11-20% vocaliza\n0 pts: >20% vocaliza',
      'en': '4 pts: ≤3% vocalize\n3 pts: 4-6% vocalize\n2 pts: 7-10% vocalize\n1 pt: 11-20% vocalize\n0 pts: >20% vocalize'
    },

    // CLASIFICACIÓN
    'welfare_excellent_pigs': {'es': 'GRANJA CON EXCELENTE BIENESTAR', 'en': 'FARM WITH EXCELLENT WELFARE'},
    'welfare_good_pigs': {'es': 'GRANJA CON BUEN BIENESTAR', 'en': 'FARM WITH GOOD WELFARE'},
    'welfare_acceptable_pigs': {'es': 'GRANJA CON BIENESTAR ACEPTABLE', 'en': 'FARM WITH ACCEPTABLE WELFARE'},
    'welfare_deficient_pigs': {'es': 'GRANJA CON BIENESTAR DEFICIENTE', 'en': 'FARM WITH DEFICIENT WELFARE'},
    'welfare_critical_pigs': {'es': 'GRANJA CON BIENESTAR CRÍTICO', 'en': 'FARM WITH CRITICAL WELFARE'},
  };
}
