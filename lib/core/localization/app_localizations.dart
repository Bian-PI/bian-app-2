import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

// lib/core/localization/app_localizations.dart - AGREGAR TRADUCCIONES

  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'app_name': 'BIAN - Bienestar Animal',
      'welcome': 'Bienvenido',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'cancel': 'Cancelar',
      'accept': 'Aceptar',
      'close': 'Cerrar',
      'save': 'Guardar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'search': 'Buscar',
      'settings': 'Configuración',
      'logout': 'Cerrar Sesión',
      'yes': 'Sí',
      'no': 'No',

      'login': 'Iniciar Sesión',
      'register': 'Registrarse',
      'email': 'Correo Electrónico',
      'email_or_document': 'Correo o Cédula',
      'password': 'Contraseña',
      'confirm_password': 'Confirmar Contraseña',
      'full_name': 'Nombre Completo',
      'document': 'Cédula',
      'phone': 'Teléfono',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'no_account': '¿No tienes cuenta?',
      'have_account': '¿Ya tienes cuenta?',
      'sign_in': 'Entrar',
      'sign_up': 'Crear Cuenta',
      'signing_in': 'Iniciando sesión...',
      'registering': 'Registrando...',
      'login_subtitle': 'Inicia sesión para continuar',
      'register_subtitle': 'Únete a nuestra comunidad BIAN',

      // ✅ TRADUCCIONES DE CONECTIVIDAD Y MODO OFFLINE
      'offline_mode': 'Modo sin conexión',
      'no_connection': 'Sin conexión',
      'connection_lost': 'Conexión Perdida',
      'connection_restored': 'Conexión Restaurada',
      'you_have_connection': 'Tienes Conexión',
      'no_internet_detected': 'No se detectó conexión a internet',
      'internet_connection_detected':
          'Detectamos que tienes conexión a internet',
      'continue_offline_anyway':
          '¿Deseas continuar en modo sin conexión de todos modos?',
      'reports_wont_sync': 'Los reportes no se sincronizarán',
      'use_offline_mode': 'Usa el modo sin conexión para continuar',
      'no_connection_use_offline':
          'Sin conexión. Usa el modo sin conexión para continuar.',
      'continue_without_connection': 'Continuar sin conexión',
      'offline_mode_screen_title': 'Modo Sin Conexión',
      'what_can_do_offline': '¿Qué puedes hacer sin conexión?',
      'create_new_evaluations': 'Crear nuevas evaluaciones',
      'save_reports_locally': 'Guardar reportes localmente',
      'generate_pdfs': 'Generar PDFs',
      'offline_reports_warning':
          'Los reportes sin conexión NO se sincronizan y se perderán al cerrar la app',
      'offline_reports_lost_on_close':
          'Los reportes sin conexión se perderán al cerrar la app',
      'session_closed_for_security':
          'Se cerrará tu sesión por seguridad. Puedes continuar en modo sin conexión.',
      'wait': 'Esperar',
      'offline_mode_title': 'Modo Sin Conexión',
      'local_reports': 'Reportes Locales',
      'no_local_reports': 'No hay reportes locales',
      'create_new_evaluation': 'Crear Nueva Evaluación',
      'exit_offline_mode': 'Salir del modo sin conexión',
      'exit_offline_mode_warning':
          'Se perderán todos los reportes locales. ¿Deseas continuar?',
      'exit': 'Salir',
      'delete_local_report': 'Eliminar reporte',
      'delete_local_report_confirm':
          '¿Seguro que deseas eliminar este reporte local?',

      'field_required': 'Este campo es requerido',
      'invalid_email': 'Correo electrónico inválido',
      'invalid_password':
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial',
      'password_mismatch': 'Las contraseñas no coinciden',
      'min_length': 'Mínimo {0} caracteres',
      'max_length': 'Máximo {0} caracteres',
      'invalid_phone': 'Teléfono inválido (mínimo 10 dígitos)',
      'invalid_document': 'Documento inválido',
      'name_format': 'Ingresa al menos nombre y apellido',

      'invalid_credentials': 'Credenciales incorrectas',
      'user_not_verified':
          'Tu cuenta no está verificada. Te hemos enviado un correo de verificación.',
      'user_exists': 'El usuario ya existe',
      'connection_error': 'Error de conexión',
      'timeout_error': 'Tiempo de espera agotado. Verifica tu conexión',
      'server_error': 'Error del servidor. Intenta de nuevo',

      'login_success': 'Inicio de sesión exitoso',
      'register_success': 'Registro exitoso',
      'logout_confirm': '¿Estás seguro que deseas cerrar sesión?',

      'verify_email': 'Verificar Correo',
      'email_not_verified': 'Correo no verificado',
      'email_verified': 'Correo verificado',
      'verification_sent': 'Correo de verificación enviado',
      'resend_verification': 'Reenviar correo de verificación',
      'check_email': 'Revisa tu correo para verificar tu cuenta',
      'verify_account_title': 'Verificación de Cuenta',
      'verify_account_message':
          'Tu cuenta no está verificada. Te hemos enviado un correo de verificación.',
      'send_verification_email': 'Enviar correo de verificación',

      'home': 'Inicio',
      'dashboard': 'Panel de Control',
      'welcome_user': '¡Bienvenido, {0}!',
      'select_species': 'Selecciona una especie',
      'manage_animal_welfare': 'Gestiona el bienestar animal',
      'birds': 'Aves',
      'birds_subtitle': 'Gestión de bienestar avícola',
      'pigs': 'Cerdos',
      'species': 'Especies',
      'pigs_subtitle': 'Gestión de bienestar porcino',
      'quick_stats': 'Estadísticas Rápidas',
      'evaluations': 'Evaluaciones',
      'alerts': 'Alertas',
      'active': 'Activo',
      'verified': 'Verificado',
      'not_verified': 'No Verificado',

      'profile': 'Perfil',
      'my_profile': 'Mi Perfil',
      'edit_profile': 'Editar Perfil',
      'profile_updated': 'Perfil actualizado correctamente',
      'name': 'Nombre',
      'role': 'Rol',
      'account_status': 'Estado de Cuenta',
      'verification_status': 'Estado de Verificación',
      'role_user': 'Usuario',
      'role_admin': 'Administrador',
      'admin': 'Administrador',
      'user': 'Usuario',

      'history': 'Historial',
      'reports': 'Reportes',
      'help': 'Ayuda',
      'about': 'Acerca de',
      'language': 'Idioma',
      'select_language': 'Seleccionar Idioma',
      'spanish': 'Español',
      'english': 'Inglés',

      'coming_soon': '{0} próximamente',
      'feature_coming_soon': 'Esta función estará disponible próximamente',

      'need_help': '¿Necesitas ayuda?',
      'contact_support': 'Contacta con soporte técnico en:',

      'no_notifications': 'No tienes notificaciones nuevas',
      'notifications': 'Notificaciones',

      'optional': 'opcional',
      'leave_blank_keep_current': 'Dejar en blanco para mantener actual',

      'step_1_title': 'Revisa tu bandeja',
      'step_1_description':
          'Te enviamos un correo con el enlace de verificación',
      'step_2_title': 'Haz clic en el enlace',
      'step_2_description':
          'Abre el correo y presiona el botón de verificación',
      'step_3_title': 'Inicia sesión',
      'step_3_description': 'Una vez verificado, podrás acceder a tu cuenta',
      'check_spam_folder':
          'Si no encuentras el correo, revisa tu carpeta de spam o correo no deseado',
      'resend_in': 'Reenviar en',
      'seconds': 's',
      'go_to_login': 'Ir a Iniciar Sesión',

      'evaluation': 'Evaluación',
      'evaluation_of': 'Evaluación de',
      'farm_information': 'Información de la Granja',
      'farm_name': 'Nombre de la Granja',
      'farm_name_example': 'Ej: Granja El Paraíso',
      'location': 'Ubicación',
      'location_example': 'Ej: Ocaña, Norte de Santander',
      'evaluator_name': 'Nombre del Evaluador',
      'evaluator_name_hint': 'Tu nombre',
      'continue': 'Continuar',
      'start': 'Comenzar',
      'welcome_evaluation':
          'Esta evaluación está basada en la metodología del ICA (2024) y la Resolución 253 de 2020.',
      'categories_to_evaluate': 'Se evaluarán {0} categorías principales:',
      'first_enter_farm_data':
          'Primero ingresa los datos de la granja, luego completa cada categoría.',
      'complete_all_fields': 'Por favor completa todos los campos',
      'previous': 'Anterior',
      'next': 'Siguiente',
      'finish': 'Finalizar',
      'finish_evaluation': 'Finalizar Evaluación',
      'finish_evaluation_confirm':
          '¿Estás seguro de finalizar esta evaluación? Se generará un reporte completo.',
      'evaluation_completed': '¡Evaluación completada!',
      'complete_required_fields':
          'Por favor completa todos los campos obligatorios',
      'exit_without_saving': '¿Salir sin guardar?',
      'data_will_be_lost': 'Se perderán los datos no guardados.',
      'save_draft': 'Guardar borrador',
      'draft_saved': 'Borrador guardado',
      'information': 'Información',
      'category': 'Categoría',
      'of': 'de',
      'indicators': 'indicadores',
      'required': 'Requerido',
      'enter_value': 'Ingresa un valor',
      'write_answer': 'Escribe tu respuesta',

      'feeding': 'Alimentación',
      'health': 'Sanidad',
      'behavior': 'Comportamiento',
      'infrastructure': 'Infraestructura',
      'management': 'Manejo',

      'water_access': '¿Las aves tienen acceso permanente a agua limpia?',
      'feed_quality': '¿El alimento es de buena calidad y apropiado?',
      'feeders_sufficient':
          '¿Los comederos son suficientes para todas las aves?',
      'feed_frequency': 'Frecuencia de alimentación diaria',
      'times_per_day': 'veces/día',
      'general_health': '¿El lote presenta buen estado de salud general?',
      'mortality_rate': 'Tasa de mortalidad semanal',
      'injuries': '¿Se observan lesiones o heridas en las aves?',
      'vaccination': '¿El programa de vacunación está al día?',
      'diseases': '¿Hay presencia de enfermedades diagnosticadas?',
      'natural_behavior':
          '¿Las aves pueden expresar comportamientos naturales?',
      'aggression': '¿Se observa agresividad o canibalismo?',
      'stress_signs': '¿Hay signos de estrés en el lote?',
      'movement': '¿Las aves se mueven con normalidad?',
      'space_per_bird': 'Espacio disponible por ave',
      'cm2_per_bird': 'cm²/ave',
      'ventilation': '¿La ventilación es adecuada?',
      'temperature': 'Temperatura promedio del galpón',
      'celsius': '°C',
      'litter_quality': '¿La cama/piso está en buen estado?',
      'lighting': '¿La iluminación es apropiada?',
      'staff_training': '¿El personal está capacitado en bienestar animal?',
      'records': '¿Se llevan registros actualizados?',
      'biosecurity': '¿Se aplican medidas de bioseguridad?',
      'handling': '¿El manejo de las aves es gentil y apropiado?',

      'water_access_pigs':
          '¿Los cerdos tienen acceso permanente a agua limpia?',
      'feed_quality_pigs': '¿El alimento es de buena calidad y balanceado?',
      'feeders_sufficient_pigs':
          '¿Los comederos son suficientes para todos los animales?',
      'general_health_pigs':
          '¿Los cerdos presentan buen estado de salud general?',
      'injuries_pigs': '¿Se observan lesiones, cojeras o heridas?',
      'tail_biting': '¿Se observa mordedura de colas?',
      'natural_behavior_pigs':
          '¿Los cerdos pueden expresar comportamientos naturales?',
      'aggression_pigs': '¿Se observa agresividad excesiva?',
      'stress_signs_pigs': '¿Hay signos de estrés en los animales?',
      'movement_pigs': '¿Los cerdos se mueven con normalidad?',
      'enrichment': '¿Se proporciona enriquecimiento ambiental?',
      'space_per_pig': 'Espacio disponible por cerdo',
      'm2_per_pig': 'm²/cerdo',
      'temperature_facility': 'Temperatura promedio de la instalación',
      'floor_quality': '¿El piso está en buen estado y es adecuado?',
      'resting_area': '¿Hay área de descanso limpia y seca?',
      'handling_pigs': '¿El manejo de los cerdos es gentil y apropiado?',
      'castration': '¿La castración se realiza con anestesia/analgesia?',

      'evaluation_results': 'Resultados de la Evaluación',
      'overall_score': 'Puntuación General',
      'category_scores': 'Puntuaciones por Categoría',
      'recommendations': 'Recomendaciones',
      'critical_points': 'Puntos Críticos',
      'strong_points': 'Puntos Fuertes',
      'compliance_level': 'Nivel de Cumplimiento',
      'excellent': 'Excelente',
      'good': 'Bueno',
      'acceptable': 'Aceptable',
      'needs_improvement': 'Necesita Mejora',
      'critical': 'Crítico',

      'farms': 'Granjas',
      'completed_evaluations': 'Evaluaciones Completadas',
      'no_evaluations': 'No hay evaluaciones completadas',
      'start_first_evaluation': 'Comienza tu primera evaluación',
      'saved_drafts': 'Borradores Guardados',
      'no_drafts': 'No hay borradores guardados',
      'continue_draft': 'Continuar',
      'delete_draft': 'Eliminar',
      'view_report': 'Ver Reporte',
      'evaluation_date': 'Fecha de evaluación',
      'draft_for': 'Borrador para',

      'share_report': 'Compartir Reporte',
      'download_pdf': 'Descargar PDF',
      'generating_pdf': 'Generando PDF...',
      'pdf_generated': 'PDF generado exitosamente',
      'error_generating_pdf': 'Error al generar PDF',

      'improve_feeding_practices':
          'Mejorar las prácticas de alimentación y asegurar acceso constante a agua y alimento de calidad',
      'strengthen_health_program':
          'Fortalecer el programa de salud animal, incluyendo vacunación y control de enfermedades',
      'improve_infrastructure':
          'Mejorar las instalaciones para proporcionar espacios adecuados, ventilación y condiciones ambientales óptimas',
      'train_staff_welfare':
          'Capacitar al personal en bienestar animal y mantener registros actualizados',
      'maintain_current_practices':
          'Mantener las buenas prácticas actuales y continuar monitoreando el bienestar animal',
      'immediate_attention_required':
          'Se requiere atención inmediata para mejorar las condiciones de bienestar animal',

      'no_critical_points': 'No se identificaron puntos críticos',
      'no_strong_points': 'No se identificaron puntos fuertes destacables',
    },
    'en': {
      'app_name': 'BIAN - Animal Welfare',
      'welcome': 'Welcome',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'accept': 'Accept',
      'close': 'Close',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'settings': 'Settings',
      'logout': 'Logout',
      'yes': 'Yes',
      'no': 'No',

      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'email_or_document': 'Email or ID',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'document': 'ID Document',
      'phone': 'Phone',
      'forgot_password': 'Forgot your password?',
      'no_account': "Don't have an account?",
      'have_account': 'Already have an account?',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'signing_in': 'Signing in...',
      'registering': 'Registering...',
      'login_subtitle': 'Sign in to continue',
      'register_subtitle': 'Join our BIAN community',

      // ✅ CONNECTIVITY AND OFFLINE MODE TRANSLATIONS
      'offline_mode': 'Offline Mode',
      'no_connection': 'No connection',
      'connection_lost': 'Connection Lost',
      'connection_restored': 'Connection Restored',
      'you_have_connection': 'You Have Connection',
      'no_internet_detected': 'No internet connection detected',
      'internet_connection_detected':
          'We detected that you have internet connection',
      'continue_offline_anyway':
          'Do you want to continue in offline mode anyway?',
      'reports_wont_sync': 'Reports will not be synchronized',
      'use_offline_mode': 'Use offline mode to continue',
      'no_connection_use_offline':
          'No connection. Use offline mode to continue.',
      'continue_without_connection': 'Continue without connection',
      'offline_mode_screen_title': 'Offline Mode',
      'what_can_do_offline': 'What can you do offline?',
      'create_new_evaluations': 'Create new evaluations',
      'save_reports_locally': 'Save reports locally',
      'generate_pdfs': 'Generate PDFs',
      'offline_reports_warning':
          'Offline reports will NOT be synchronized and will be lost when closing the app',
      'offline_reports_lost_on_close':
          'Offline reports will be lost when closing the app',
      'session_closed_for_security':
          'Your session will be closed for security. You can continue in offline mode.',
      'wait': 'Wait',
      'offline_mode_title': 'Offline Mode',
      'local_reports': 'Local Reports',
      'no_local_reports': 'No local reports',
      'create_new_evaluation': 'Create New Evaluation',
      'exit_offline_mode': 'Exit offline mode',
      'exit_offline_mode_warning':
          'All local reports will be lost. Do you want to continue?',
      'exit': 'Exit',
      'delete_local_report': 'Delete report',
      'delete_local_report_confirm':
          'Are you sure you want to delete this local report?',

      'field_required': 'This field is required',
      'invalid_email': 'Invalid email',
      'invalid_password':
          'Password must have at least 8 characters, one uppercase, one lowercase, one number and one special character',
      'password_mismatch': 'Passwords do not match',
      'min_length': 'Minimum {0} characters',
      'max_length': 'Maximum {0} characters',
      'invalid_phone': 'Invalid phone (minimum 10 digits)',
      'invalid_document': 'Invalid document',
      'name_format': 'Enter at least first and last name',

      'invalid_credentials': 'Invalid credentials',
      'user_not_verified':
          'Your account is not verified. We have sent you a verification email.',
      'user_exists': 'User already exists',
      'connection_error': 'Connection error',
      'timeout_error': 'Request timeout. Check your connection',
      'server_error': 'Server error. Try again',

      'login_success': 'Login successful',
      'register_success': 'Registration successful',
      'logout_confirm': 'Are you sure you want to logout?',

      'verify_email': 'Verify Email',
      'email_not_verified': 'Email not verified',
      'email_verified': 'Email verified',
      'verification_sent': 'Verification email sent',
      'resend_verification': 'Resend verification email',
      'check_email': 'Check your email to verify your account',
      'verify_account_title': 'Account Verification',
      'verify_account_message':
          'Your account is not verified. We have sent you a verification email.',
      'send_verification_email': 'Send verification email',

      'home': 'Home',
      'dashboard': 'Dashboard',
      'welcome_user': 'Welcome, {0}!',
      'select_species': 'Select a species',
      'species': 'Species',
      'manage_animal_welfare': 'Manage animal welfare',
      'birds': 'Birds',
      'birds_subtitle': 'Poultry welfare management',
      'pigs': 'Pigs',
      'pigs_subtitle': 'Swine welfare management',
      'quick_stats': 'Quick Stats',
      'evaluations': 'Evaluations',
      'alerts': 'Alerts',
      'active': 'Active',
      'verified': 'Verified',
      'not_verified': 'Not Verified',

      'profile': 'Profile',
      'my_profile': 'My Profile',
      'edit_profile': 'Edit Profile',
      'profile_updated': 'Profile updated successfully',
      'name': 'Name',
      'role': 'Role',
      'account_status': 'Account Status',
      'verification_status': 'Verification Status',
      'role_user': 'User',
      'role_admin': 'Administrator',
      'admin': 'Administrator',
      'user': 'User',

      'history': 'History',
      'reports': 'Reports',
      'help': 'Help',
      'about': 'About',
      'language': 'Language',
      'select_language': 'Select Language',
      'spanish': 'Spanish',
      'english': 'English',

      'coming_soon': '{0} coming soon',
      'feature_coming_soon': 'This feature will be available soon',

      'need_help': 'Need help?',
      'contact_support': 'Contact technical support at:',

      'no_notifications': 'No new notifications',
      'notifications': 'Notifications',

      'optional': 'optional',
      'leave_blank_keep_current': 'Leave blank to keep current',

      'step_1_title': 'Check your inbox',
      'step_1_description': 'We sent you an email with the verification link',
      'step_2_title': 'Click the link',
      'step_2_description': 'Open the email and press the verification button',
      'step_3_title': 'Sign in',
      'step_3_description': 'Once verified, you can access your account',
      'check_spam_folder':
          'If you can\'t find the email, check your spam or junk folder',
      'resend_in': 'Resend in',
      'seconds': 's',
      'go_to_login': 'Go to Login',

      'evaluation': 'Evaluation',
      'evaluation_of': 'Evaluation of',
      'farm_information': 'Farm Information',
      'farm_name': 'Farm Name',
      'farm_name_example': 'E.g.: Paradise Farm',
      'location': 'Location',
      'location_example': 'E.g.: Ocaña, Norte de Santander',
      'evaluator_name': 'Evaluator Name',
      'evaluator_name_hint': 'Your name',
      'continue': 'Continue',
      'start': 'Start',
      'welcome_evaluation':
          'This evaluation is based on the ICA (2024) methodology and Resolution 253 of 2020.',
      'categories_to_evaluate': '{0} main categories will be evaluated:',
      'first_enter_farm_data':
          'First enter the farm data, then complete each category.',
      'complete_all_fields': 'Please complete all fields',
      'previous': 'Previous',
      'next': 'Next',
      'finish': 'Finish',
      'finish_evaluation': 'Finish Evaluation',
      'finish_evaluation_confirm':
          'Are you sure you want to finish this evaluation? A complete report will be generated.',
      'evaluation_completed': 'Evaluation completed!',
      'complete_required_fields': 'Please complete all required fields',
      'exit_without_saving': 'Exit without saving?',
      'data_will_be_lost': 'Unsaved data will be lost.',

      'save_draft': 'Save draft',
      'draft_saved': 'Draft saved',
      'information': 'Information',
      'category': 'Category',
      'of': 'of',
      'indicators': 'indicators',
      'required': 'Required',
      'enter_value': 'Enter a value',
      'write_answer': 'Write your answer',

      'feeding': 'Feeding',
      'health': 'Health',
      'behavior': 'Behavior',
      'infrastructure': 'Infrastructure',
      'management': 'Management',

      'water_access': 'Do birds have permanent access to clean water?',
      'feed_quality': 'Is the feed of good quality and appropriate?',
      'feeders_sufficient': 'Are feeders sufficient for all birds?',
      'feed_frequency': 'Daily feeding frequency',
      'times_per_day': 'times/day',
      'general_health': 'Does the flock show good general health?',
      'mortality_rate': 'Weekly mortality rate',
      'injuries': 'Are injuries or wounds observed in birds?',
      'vaccination': 'Is the vaccination program up to date?',
      'diseases': 'Is there presence of diagnosed diseases?',
      'natural_behavior': 'Can birds express natural behaviors?',
      'aggression': 'Is aggression or cannibalism observed?',
      'stress_signs': 'Are there signs of stress in the flock?',
      'movement': 'Do birds move normally?',
      'space_per_bird': 'Available space per bird',
      'cm2_per_bird': 'cm²/bird',
      'ventilation': 'Is ventilation adequate?',
      'temperature': 'Average barn temperature',
      'celsius': '°C',
      'litter_quality': 'Is the litter/floor in good condition?',
      'lighting': 'Is lighting appropriate?',
      'staff_training': 'Is staff trained in animal welfare?',
      'records': 'Are updated records kept?',
      'biosecurity': 'Are biosecurity measures applied?',
      'handling': 'Is bird handling gentle and appropriate?',

      'water_access_pigs': 'Do pigs have permanent access to clean water?',
      'feed_quality_pigs': 'Is the feed of good quality and balanced?',
      'feeders_sufficient_pigs': 'Are feeders sufficient for all animals?',
      'general_health_pigs': 'Do pigs show good general health?',
      'injuries_pigs': 'Are injuries, lameness or wounds observed?',
      'tail_biting': 'Is tail biting observed?',
      'natural_behavior_pigs': 'Can pigs express natural behaviors?',
      'aggression_pigs': 'Is excessive aggression observed?',
      'stress_signs_pigs': 'Are there signs of stress in the animals?',
      'movement_pigs': 'Do pigs move normally?',
      'enrichment': 'Is environmental enrichment provided?',
      'space_per_pig': 'Available space per pig',
      'm2_per_pig': 'm²/pig',
      'temperature_facility': 'Average facility temperature',
      'floor_quality': 'Is the floor in good condition and adequate?',
      'resting_area': 'Is there a clean and dry resting area?',
      'handling_pigs': 'Is pig handling gentle and appropriate?',
      'castration': 'Is castration performed with anesthesia/analgesia?',

      'evaluation_results': 'Evaluation Results',
      'overall_score': 'Overall Score',
      'category_scores': 'Category Scores',
      'recommendations': 'Recommendations',
      'critical_points': 'Critical Points',
      'strong_points': 'Strong Points',
      'compliance_level': 'Compliance Level',
      'excellent': 'Excellent',
      'good': 'Good',
      'acceptable': 'Acceptable',
      'needs_improvement': 'Needs Improvement',
      'critical': 'Critical',

      'farms': 'Farms',
      'completed_evaluations': 'Completed Evaluations',
      'no_evaluations': 'No completed evaluations',
      'start_first_evaluation': 'Start your first evaluation',
      'saved_drafts': 'Saved Drafts',
      'no_drafts': 'No saved drafts',
      'continue_draft': 'Continue',
      'delete_draft': 'Delete',
      'view_report': 'View Report',
      'evaluation_date': 'Evaluation date',
      'draft_for': 'Draft for',

      'share_report': 'Share Report',
      'download_pdf': 'Download PDF',
      'generating_pdf': 'Generating PDF...',
      'pdf_generated': 'PDF generated successfully',
      'error_generating_pdf': 'Error generating PDF',

      'improve_feeding_practices':
          'Improve feeding practices and ensure constant access to quality water and food',
      'strengthen_health_program':
          'Strengthen animal health program, including vaccination and disease control',
      'improve_infrastructure':
          'Improve facilities to provide adequate space, ventilation and optimal environmental conditions',
      'train_staff_welfare':
          'Train staff in animal welfare and maintain updated records',
      'maintain_current_practices':
          'Maintain current good practices and continue monitoring animal welfare',
      'immediate_attention_required':
          'Immediate attention required to improve animal welfare conditions',

      'no_critical_points': 'No critical points identified',
      'no_strong_points': 'No strong points identified',
    },
  };

  String translate(String key, [List<String>? params]) {
    String? value = _localizedValues[locale.languageCode]?[key];

    if (value == null) {
      return key;
    }

    if (params != null) {
      for (int i = 0; i < params.length; i++) {
        value = value!.replaceAll('{$i}', params[i]);
      }
    }

    return value!;
  }

  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
