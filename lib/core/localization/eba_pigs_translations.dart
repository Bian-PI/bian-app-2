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

    // EBA-A1
    'eba_a1_label': {'es': 'Relación animales por bebedero', 'en': 'Animals per drinker ratio'},
    'eba_a1_description': {'es': 'Conteo de bebederos funcionales y animales. Lechones ≤10, Ceba ≤12, Gestantes ≤8 = 4 pts.', 'en': 'Count of functional drinkers and animals. Piglets ≤10, Finishing ≤12, Gestating ≤8 = 4 pts.'},
    'eba_a1_question': {'es': '¿Cuántos animales hay por bebedero funcional?', 'en': 'How many animals per functional drinker?'},

    // EBA-A2
    'eba_a2_label': {'es': 'Caudal del bebedero', 'en': 'Drinker flow rate'},
    'eba_a2_description': {'es': 'Medición con probeta 30s. Lechones: 0.6-1.0 L/min, Ceba: 1.0-1.5 L/min = 4 pts.', 'en': 'Measurement with cylinder 30s. Piglets: 0.6-1.0 L/min, Finishing: 1.0-1.5 L/min = 4 pts.'},
    'eba_a2_question': {'es': '¿El caudal abastece los requerimientos?', 'en': 'Does the flow rate meet requirements?'},

    // EBA-A3
    'eba_a3_label': {'es': 'Calidad microbiológica del agua', 'en': 'Water microbiological quality'},
    'eba_a3_description': {'es': 'Análisis de coliformes y E. coli. Sin coliformes ni E. coli = 4 pts.', 'en': 'Coliform and E. coli analysis. No coliforms or E. coli = 4 pts.'},
    'eba_a3_question': {'es': '¿Coliformes y E. coli cumplen norma?', 'en': 'Do coliforms and E. coli meet standards?'},

    // EBA-F1
    'eba_f1_label': {'es': 'Espacios de comedero suficientes', 'en': 'Sufficient feeder spaces'},
    'eba_f1_description': {'es': 'Lechones ≤4, Ceba ≤6, Gestantes ≤5 animales/espacio = 4 pts.', 'en': 'Piglets ≤4, Finishing ≤6, Gestating ≤5 animals/space = 4 pts.'},
    'eba_f1_question': {'es': '¿Relación animales:comedero adecuada?', 'en': 'Is animal-to-feeder ratio adequate?'},

    // EBA-F2
    'eba_f2_label': {'es': 'Condición corporal (CC)', 'en': 'Body condition score (BCS)'},
    'eba_f2_description': {'es': '0-2% animales con CC <2.5/5 = 4 pts.', 'en': '0-2% animals with BCS <2.5/5 = 4 pts.'},
    'eba_f2_question': {'es': '¿% animales con CC <2.5/5?', 'en': '% animals with BCS <2.5/5?'},

    // EBA-F3
    'eba_f3_label': {'es': 'Tiempo de acceso tras reparto', 'en': 'Access time after feeding'},
    'eba_f3_description': {'es': '≤2 min para que todos accedan = 4 pts.', 'en': '≤2 min for all to access = 4 pts.'},
    'eba_f3_question': {'es': '¿Tiempo hasta que todos acceden?', 'en': 'Time until all access?'},

    // EBA-E1
    'eba_e1_label': {'es': 'Índice temperatura-humedad (THI)', 'en': 'Temperature-Humidity Index (THI)'},
    'eba_e1_description': {'es': 'THI ≤70 en horas críticas = 4 pts.', 'en': 'THI ≤70 during critical hours = 4 pts.'},
    'eba_e1_question': {'es': '¿Índice THI en horas críticas?', 'en': 'THI during critical hours?'},

    // EBA-E2
    'eba_e2_label': {'es': 'Nivel de amoníaco (NH₃)', 'en': 'Ammonia level (NH₃)'},
    'eba_e2_description': {'es': '≤10 ppm a nivel del hocico = 4 pts.', 'en': '≤10 ppm at snout level = 4 pts.'},
    'eba_e2_question': {'es': '¿ppm de NH₃ a nivel del hocico?', 'en': 'ppm of NH₃ at snout level?'},

    // EBA-E3
    'eba_e3_label': {'es': 'Nivel de CO₂', 'en': 'CO₂ level'},
    'eba_e3_description': {'es': '≤2000 ppm = 4 pts.', 'en': '≤2000 ppm = 4 pts.'},
    'eba_e3_question': {'es': '¿ppm de CO₂ a nivel del hocico?', 'en': 'ppm of CO₂ at snout level?'},

    // EBA-E4
    'eba_e4_label': {'es': 'Nivel de ruido', 'en': 'Noise level'},
    'eba_e4_description': {'es': '≤65 dB(A) promedio = 4 pts.', 'en': '≤65 dB(A) average = 4 pts.'},
    'eba_e4_question': {'es': '¿Nivel de ruido promedio?', 'en': 'Average noise level?'},

    // EBA-E5
    'eba_e5_label': {'es': 'Iluminación mínima', 'en': 'Minimum lighting'},
    'eba_e5_description': {'es': '≥80 lux = 4 pts.', 'en': '≥80 lux = 4 pts.'},
    'eba_e5_question': {'es': '¿Iluminación mínima diurna?', 'en': 'Minimum daytime lighting?'},

    // EBA-I1
    'eba_i1_label': {'es': 'Densidad de alojamiento', 'en': 'Housing density'},
    'eba_i1_description': {'es': '≥0.8 m²/animal (≥110kg) = 4 pts.', 'en': '≥0.8 m²/animal (≥110kg) = 4 pts.'},
    'eba_i1_question': {'es': '¿m² por animal según peso?', 'en': 'm² per animal by weight?'},

    // EBA-I2
    'eba_i2_label': {'es': 'Estado de los pisos', 'en': 'Floor condition'},
    'eba_i2_description': {'es': '0-2% superficie dañada = 4 pts.', 'en': '0-2% damaged surface = 4 pts.'},
    'eba_i2_question': {'es': '¿% superficie con daños lesivos?', 'en': '% surface with injurious damage?'},

    // EBA-I3
    'eba_i3_label': {'es': 'Área de descanso seca', 'en': 'Dry resting area'},
    'eba_i3_description': {'es': '≥95% seca = 4 pts.', 'en': '≥95% dry = 4 pts.'},
    'eba_i3_question': {'es': '¿% área de descanso seca?', 'en': '% dry resting area?'},

    // EBA-I4
    'eba_i4_label': {'es': 'Suciedad corporal', 'en': 'Body dirtiness'},
    'eba_i4_description': {'es': '0-3% con ≥20% cuerpo sucio = 4 pts.', 'en': '0-3% with ≥20% body dirty = 4 pts.'},
    'eba_i4_question': {'es': '¿% con ≥20% cuerpo sucio?', 'en': '% with ≥20% body dirty?'},

    // EBA-I5
    'eba_i5_label': {'es': 'Material manipulable disponible', 'en': 'Available manipulable material'},
    'eba_i5_description': {'es': '≥95% corrales con material = 4 pts.', 'en': '≥95% pens with material = 4 pts.'},
    'eba_i5_question': {'es': '¿% corrales con material manipulable?', 'en': '% pens with manipulable material?'},

    // EBA-R1
    'eba_r1_label': {'es': 'Ganancia media diaria (GMD)', 'en': 'Average daily gain (ADG)'},
    'eba_r1_description': {'es': '≥850 g/día = 4 pts.', 'en': '≥850 g/day = 4 pts.'},
    'eba_r1_question': {'es': '¿GMD promedio del lote?', 'en': 'Average ADG of batch?'},

    // EBA-L3
    'eba_l3_label': {'es': 'Temperatura del nido/placa', 'en': 'Nest/heating pad temperature'},
    'eba_l3_description': {'es': 'Cumple 100% del tiempo = 4 pts.', 'en': 'Meets 100% of time = 4 pts.'},
    'eba_l3_question': {'es': '¿Temperatura en rango para neonatos?', 'en': 'Temperature in range for neonates?'},

    // EBA-H1
    'eba_h1_label': {'es': 'Cojeras', 'en': 'Lameness'},
    'eba_h1_description': {'es': '0-1% con locomoción anormal = 4 pts.', 'en': '0-1% with abnormal locomotion = 4 pts.'},
    'eba_h1_question': {'es': '¿% con locomoción anormal?', 'en': '% with abnormal locomotion?'},

    // EBA-H2
    'eba_h2_label': {'es': 'Lesiones tegumentarias', 'en': 'Skin lesions'},
    'eba_h2_description': {'es': '0-2% con heridas >2cm = 4 pts.', 'en': '0-2% with wounds >2cm = 4 pts.'},
    'eba_h2_question': {'es': '¿% con heridas >2cm?', 'en': '% with wounds >2cm?'},

    // EBA-H3
    'eba_h3_label': {'es': 'Tos y estornudos', 'en': 'Coughing and sneezing'},
    'eba_h3_description': {'es': '≤0.05 eventos/animal/min = 4 pts.', 'en': '≤0.05 events/animal/min = 4 pts.'},
    'eba_h3_question': {'es': '¿Eventos tos/estornudo por animal/min?', 'en': 'Cough/sneeze events per animal/min?'},

    // EBA-H4
    'eba_h4_label': {'es': 'Diarrea', 'en': 'Diarrhea'},
    'eba_h4_description': {'es': '0-2% con perineo sucio = 4 pts.', 'en': '0-2% with dirty perineum = 4 pts.'},
    'eba_h4_question': {'es': '¿% con diarrea/perineo sucio?', 'en': '% with diarrhea/dirty perineum?'},

    // EBA-H5
    'eba_h5_label': {'es': 'Mortalidad del lote', 'en': 'Batch mortality'},
    'eba_h5_description': {'es': '≤1% engorde, ≤0.5% reproductoras = 4 pts.', 'en': '≤1% finishing, ≤0.5% breeding = 4 pts.'},
    'eba_h5_question': {'es': '¿% mortalidad del ciclo?', 'en': 'Cycle mortality %?'},

    // EBA-H6
    'eba_h6_label': {'es': 'Analgesia/anestesia en procedimientos', 'en': 'Analgesia/anesthesia in procedures'},
    'eba_h6_description': {'es': '100% con protocolo = 4 pts.', 'en': '100% with protocol = 4 pts.'},
    'eba_h6_question': {'es': '¿% procedimientos con analgesia?', 'en': '% procedures with analgesia?'},

    // EBA-H8
    'eba_h8_label': {'es': 'Cicatrices de cola', 'en': 'Tail scars'},
    'eba_h8_description': {'es': '0-2% con cicatrices = 4 pts.', 'en': '0-2% with scars = 4 pts.'},
    'eba_h8_question': {'es': '¿% con cicatrices en cola?', 'en': '% with tail scars?'},

    // EBA-B1
    'eba_b1_label': {'es': 'Peleas (>3 segundos)', 'en': 'Fights (>3 seconds)'},
    'eba_b1_description': {'es': '0-1 peleas en 10 min = 4 pts.', 'en': '0-1 fights in 10 min = 4 pts.'},
    'eba_b1_question': {'es': '¿Peleas >3s en 10 min/corral?', 'en': 'Fights >3s in 10 min/pen?'},

    // EBA-B2
    'eba_b2_label': {'es': 'Uso de enriquecimiento', 'en': 'Enrichment use'},
    'eba_b2_description': {'es': '≥60% interactuando = 4 pts.', 'en': '≥60% interacting = 4 pts.'},
    'eba_b2_question': {'es': '¿% interactúa con enriquecimiento?', 'en': '% interact with enrichment?'},

    // EBA-B3
    'eba_b3_label': {'es': 'Huida al acercamiento humano', 'en': 'Flight from human approach'},
    'eba_b3_description': {'es': '0-10% huyen >1m = 4 pts.', 'en': '0-10% flee >1m = 4 pts.'},
    'eba_b3_question': {'es': '¿% huye >1m ante acercamiento?', 'en': '% flee >1m upon approach?'},

    // EBA-R2
    'eba_r2_label': {'es': 'Colas mordidas activas', 'en': 'Active tail biting'},
    'eba_r2_description': {'es': '0-1% con lesiones recientes = 4 pts.', 'en': '0-1% with recent injuries = 4 pts.'},
    'eba_r2_question': {'es': '¿% con lesiones recientes en cola?', 'en': '% with recent tail injuries?'},

    // EBA-L1
    'eba_l1_label': {'es': 'Mortalidad predestete', 'en': 'Pre-weaning mortality'},
    'eba_l1_description': {'es': '≤8% = 4 pts.', 'en': '≤8% = 4 pts.'},
    'eba_l1_question': {'es': '¿% mortalidad nacimiento-destete?', 'en': '% mortality birth-weaning?'},

    // EBA-L2
    'eba_l2_label': {'es': 'Aplastamientos', 'en': 'Crushing deaths'},
    'eba_l2_description': {'es': '≤3% = 4 pts.', 'en': '≤3% = 4 pts.'},
    'eba_l2_question': {'es': '¿% muertos por aplastamiento?', 'en': '% dead by crushing?'},

    // EBA-G1
    'eba_g1_label': {'es': 'Gestantes en grupo', 'en': 'Group-housed gestating sows'},
    'eba_g1_description': {'es': '≥90% en grupo = 4 pts.', 'en': '≥90% in group = 4 pts.'},
    'eba_g1_question': {'es': '¿% gestantes en alojamiento grupal?', 'en': '% gestating sows in group housing?'},

    // EBA-P1
    'eba_p1_label': {'es': 'Capacitación en bienestar animal', 'en': 'Animal welfare training'},
    'eba_p1_description': {'es': '≥90% personal capacitado = 4 pts.', 'en': '≥90% staff trained = 4 pts.'},
    'eba_p1_question': {'es': '¿% personal con capacitación anual?', 'en': '% staff with annual training?'},

    // EBA-D1
    'eba_d1_label': {'es': 'Procedimientos escritos (SOPs)', 'en': 'Written procedures (SOPs)'},
    'eba_d1_description': {'es': 'SOPs actualizados + evidencia = 4 pts.', 'en': 'Updated SOPs + evidence = 4 pts.'},
    'eba_d1_question': {'es': '¿SOPs críticos existen y se aplican?', 'en': 'Do critical SOPs exist and are applied?'},

    // EBA-D2
    'eba_d2_label': {'es': 'Plan de contingencia', 'en': 'Contingency plan'},
    'eba_d2_description': {'es': 'Plan vigente + simulacro = 4 pts.', 'en': 'Current plan + drill = 4 pts.'},
    'eba_d2_question': {'es': '¿Plan de contingencia con simulacros?', 'en': 'Contingency plan with drills?'},

    // EBA-T1
    'eba_t1_label': {'es': 'Animales no ambulatorios', 'en': 'Non-ambulatory animals'},
    'eba_t1_description': {'es': '0-0.05% = 4 pts.', 'en': '0-0.05% = 4 pts.'},
    'eba_t1_question': {'es': '¿% no ambulatorios al arribo?', 'en': '% non-ambulatory at arrival?'},

    // EBA-T2
    'eba_t2_label': {'es': 'Muertos a la llegada (DOA)', 'en': 'Dead on arrival (DOA)'},
    'eba_t2_description': {'es': '0-0.03% = 4 pts.', 'en': '0-0.03% = 4 pts.'},
    'eba_t2_question': {'es': '¿% muertos al arribo?', 'en': '% dead at arrival?'},

    // EBA-T3
    'eba_t3_label': {'es': 'Densidad de carga', 'en': 'Load density'},
    'eba_t3_description': {'es': 'Cumple tablas por clima y peso = 4 pts.', 'en': 'Meets tables by climate and weight = 4 pts.'},
    'eba_t3_question': {'es': '¿Densidad de carga adecuada?', 'en': 'Adequate load density?'},

    // EBA-T4
    'eba_t4_label': {'es': 'Ayuno y agua pre-transporte', 'en': 'Pre-transport fasting and water'},
    'eba_t4_description': {'es': 'Cumple ambos = 4 pts.', 'en': 'Meets both = 4 pts.'},
    'eba_t4_question': {'es': '¿Cumple ayuno y acceso a agua?', 'en': 'Meets fasting and water access?'},

    // EBA-S1
    'eba_s1_label': {'es': 'Resbalones y caídas', 'en': 'Slips and falls'},
    'eba_s1_description': {'es': '≤1% = 4 pts.', 'en': '≤1% = 4 pts.'},
    'eba_s1_question': {'es': '¿% resbala/cae en manejo previo?', 'en': '% slipping/falling during prior handling?'},

    // EBA-S2
    'eba_s2_label': {'es': 'Aturdimiento al primer intento', 'en': 'First-attempt stunning'},
    'eba_s2_description': {'es': '≥98% = 4 pts.', 'en': '≥98% = 4 pts.'},
    'eba_s2_question': {'es': '¿% aturdidos al primer intento?', 'en': '% stunned on first attempt?'},

    // EBA-S3
    'eba_s3_label': {'es': 'Parámetros del equipo', 'en': 'Equipment parameters'},
    'eba_s3_description': {'es': 'Cumple y calibrado = 4 pts.', 'en': 'Meets and calibrated = 4 pts.'},
    'eba_s3_question': {'es': '¿Parámetros cumplen protocolo?', 'en': 'Parameters meet protocol?'},

    // EBA-S4
    'eba_s4_label': {'es': 'Vocalizaciones', 'en': 'Vocalizations'},
    'eba_s4_description': {'es': '≤3% = 4 pts.', 'en': '≤3% = 4 pts.'},
    'eba_s4_question': {'es': '¿% vocaliza en manejo pre-faena?', 'en': '% vocalizing during pre-slaughter?'},

    // CLASIFICACIÓN
    'welfare_excellent_pigs': {'es': 'GRANJA CON EXCELENTE BIENESTAR', 'en': 'FARM WITH EXCELLENT WELFARE'},
    'welfare_good_pigs': {'es': 'GRANJA CON BUEN BIENESTAR', 'en': 'FARM WITH GOOD WELFARE'},
    'welfare_acceptable_pigs': {'es': 'GRANJA CON BIENESTAR ACEPTABLE', 'en': 'FARM WITH ACCEPTABLE WELFARE'},
    'welfare_deficient_pigs': {'es': 'GRANJA CON BIENESTAR DEFICIENTE', 'en': 'FARM WITH DEFICIENT WELFARE'},
    'welfare_critical_pigs': {'es': 'GRANJA CON BIENESTAR CRÍTICO', 'en': 'FARM WITH CRITICAL WELFARE'},
  };
}
