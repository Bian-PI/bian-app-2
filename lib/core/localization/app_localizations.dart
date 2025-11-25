import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();


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

      // Sincronización
      'sync_to_server': 'Sincronizar con Servidor',
      'syncing_to_server': 'Sincronizando con servidor...',
      'evaluation_synced_successfully': 'Evaluación sincronizada exitosamente',
      'sync_error': 'Error al sincronizar',
      'sync_requires_login': 'Inicia sesión para sincronizar con el servidor',
      'offline_mode_active': 'Modo offline activo',
      'pending_sync_reports': 'Reportes pendientes de sincronización',
      'pending_sync_message': 'Abre cada reporte y presiona "Sincronizar con Servidor"',

      'continue_offline': 'Continuar sin conexión',
      'no_internet_connection': 'Sin conexión a internet',
      'exit_question': '¿Salir?',
      'lose_progress_warning': 'Si sales ahora, perderás todo el progreso de esta evaluación.',
      'cannot_save_drafts_offline': 'En modo offline no se pueden guardar borradores',
      'exit_and_lose_progress': 'Salir y perder progreso',
      'get_current_location': 'Obtener ubicación actual',
      'getting_location': 'Obteniendo ubicación...',
      'location_permission_denied': 'Permiso de ubicación denegado',
      'location_error': 'Error al obtener ubicación',
      'enable_gps': 'Habilitar GPS',
      'manual_location': 'Ingresar manualmente',
      'gps_disabled': 'El GPS está desactivado',
      'permission_denied_permanently': 'Permiso de ubicación denegado permanentemente',
      'open_settings': 'Abrir configuración',

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
      'invalid_document2': 'El documento debe tener al menos 6 caracteres',
      'min_length2': 'Debe tener al menos {0} caracteres',
      'name_format2': 'Ingresa el nombre completo (nombre y apellido)',
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

      'report_deleted': 'Reporte eliminado',
      'no_pending_reports_to_sync': 'No hay reportes pendientes de sincronizar',
      'enter_id_to_link_reports': 'Ingresa tu documento de identidad para asociar los reportes:',
      'enter_your_document': 'Ingresa tu documento',
      'reports_synced_successfully': 'reporte(s) sincronizado(s) correctamente',
      'reports_synced_with_errors': 'sincronizado(s), {0} con error',
      'could_not_open_pdf_automatically': 'No se pudo abrir automáticamente. Busca el archivo en Descargas.',
      'share': 'Compartir',
      'pdf_report_options': 'Opciones de Reporte PDF',
      'share_pdf': 'Compartir PDF',
      'please_wait': 'Por favor espera...',
      'storage_permissions_required': 'Se requieren permisos de almacenamiento',
      'view_pdf': 'Ver PDF',
      'try_sharing': 'Intentar Compartir',
      'press_again_to_exit': 'Presiona de nuevo para salir',
      'resending': 'Reenviando...',
      'download_pdf_title': 'Descargar PDF',
      'download_on_device': 'Guardar en el dispositivo',
      'share_via_apps': 'WhatsApp, Gmail, Drive, etc.',

      'biometric_consent_title': 'Autenticación Biométrica',
      'biometric_consent_message':
          'Para habilitar el inicio de sesión con huella dactilar o Face ID, necesitamos tu consentimiento para almacenar tus credenciales de forma segura en tu dispositivo.',
      'important_information': 'Información Importante',
      'biometric_local_only':
          'Tus credenciales se almacenan solo en tu dispositivo',
      'biometric_device_only':
          'La huella o Face ID solo se usa en este dispositivo',
      'biometric_disable_anytime':
          'Puedes desactivar esta función en cualquier momento',
      'biometric_no_external_sharing':
          'Nunca compartimos tus datos biométricos con terceros',
      'decline': 'Rechazar',
      'accept_and_continue': 'Aceptar y Continuar',
      'remember_account': 'Recordar cuenta',
      'use_biometric': 'Usar huella/Face ID',
      'biometric_login': 'Iniciar con biometría',
      'authenticate_with': 'Autenticarse con {0}',
      'session_expired': 'Sesión expirada',
      'session_expired_message':
          'Tu sesión expiró por inactividad. Por favor, inicia sesión nuevamente.',

      'report_deleted_successfully': 'Reporte eliminado',
      'no_pending_reports_sync': 'No hay reportes pendientes de sincronizar',
      'syncing_reports': 'Sincronizando Reportes',
      'uploading_to_cloud': 'Subiendo a la nube...',
      'reports_synced_successfully_count': '{0} reporte(s) sincronizado(s) correctamente',
      'reports_synced_with_errors_count': '{0} sincronizado(s), {1} con error',
      'sync_error_try_later': 'Error al sincronizar. Intenta más tarde.',
      'connection_error_msg': 'Error de conexión: {0}',
      'want_go_to_login_screen': '¿Deseas ir a la pantalla de inicio de sesión?',
      'local_reports_will_be_kept': 'Tus {0} reporte(s) local(es) se conservarán',
      'go_to_login_short': 'Ir a Login',
      'sync_action': 'Sincronizar',
      'reports_ready_to_sync': '{0} reporte(s) listo(s) para sincronizar',
      'reports_created_saved_here': 'Los reportes que crees se guardarán aquí',
      'local_badge': 'Local',
      'syncing_status': 'Sincronizando...',
      'report_synced_successfully': 'Reporte sincronizado correctamente',
      'error_prefix': 'Error: {0}',
      'sync_reports_title': 'Sincronizar Reportes',
      'reports_pending_count': '{0} reporte(s) pendiente(s)',
      'sync_all': 'Sincronizar Todos',
      'sync_report': 'Sincronizar Reporte',
      'sync_report_confirm': '¿Deseas sincronizar este reporte?',
      'sync_now': 'Sincronizar Ahora',

      'ai_chat_welcome_message': '¡Hola! 👋 Soy tu asistente de bienestar animal.\n\nHe analizado tu reporte ({0}% de cumplimiento). Puedes hacerme **2 preguntas cada 5 minutos** sobre:\n\n• Recomendaciones específicas\n• Cómo mejorar puntos críticos\n• Mejores prácticas\n• Interpretación de resultados\n\n¿En qué puedo ayudarte?',
      'wait_time_format': '{0}m {1}s',
      'rate_limit_reached': 'Límite alcanzado. Espera {0} para más preguntas',
      'need_internet_connection_ai': 'Necesitas conexión a internet',
      'ai_error_generating_response': '❌ Error al generar respuesta. Por favor intenta de nuevo.',
      'ai_consultation': 'Consulta con IA',
      'thinking_status': 'Pensando...',
      'wait_for_more_questions': 'Espera {0} para más preguntas',
      'questions_remaining': '{0} pregunta restante',
      'ask_something': 'Pregunta algo...',

      'pdf_saved_title': '¡PDF Guardado!',
      'pdf_saved_successfully_at': 'El PDF se ha guardado exitosamente en:',
      'find_in_downloads_android': 'Busca en "Archivos" → "Descargas" de tu dispositivo',
      'find_in_documents_ios': 'Busca en la carpeta de Documentos',
      'storage_directory_error': 'No se pudo determinar directorio de almacenamiento',
      'file_not_created_correctly': 'El archivo no se creó correctamente',
      'pdf_shared_successfully': 'PDF compartido exitosamente',
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

      // Synchronization
      'sync_to_server': 'Sync to Server',
      'syncing_to_server': 'Syncing to server...',
      'evaluation_synced_successfully': 'Evaluation synced successfully',
      'sync_error': 'Sync error',
      'sync_requires_login': 'Log in to sync with server',
      'offline_mode_active': 'Offline mode active',
      'pending_sync_reports': 'Pending sync reports',
      'pending_sync_message': 'Open each report and press "Sync to Server"',

      'continue_offline': 'Continue offline',
      'no_internet_connection': 'No internet connection',
      'exit_question': 'Exit?',
      'lose_progress_warning': 'If you leave now, you will lose all progress on this evaluation.',
      'cannot_save_drafts_offline': 'Cannot save drafts in offline mode',
      'exit_and_lose_progress': 'Exit and lose progress',
      'get_current_location': 'Get current location',
      'getting_location': 'Getting location...',
      'location_permission_denied': 'Location permission denied',
      'location_error': 'Error getting location',
      'enable_gps': 'Enable GPS',
      'manual_location': 'Enter manually',
      'gps_disabled': 'GPS is disabled',
      'permission_denied_permanently': 'Location permission permanently denied',
      'open_settings': 'Open settings',

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
      'invalid_document2': 'Document must have at least 6 characters',
      'min_length2': 'Must be at least {0} characters',
      'name_format2': 'Enter full name (first and last name)',
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

      'report_deleted': 'Report deleted',
      'no_pending_reports_to_sync': 'No pending reports to sync',
      'enter_id_to_link_reports': 'Enter your ID document to link reports:',
      'enter_your_document': 'Enter your document',
      'reports_synced_successfully': 'report(s) synced successfully',
      'reports_synced_with_errors': 'synced, {0} with error',
      'could_not_open_pdf_automatically': 'Could not open automatically. Look for the file in Downloads.',
      'share': 'Share',
      'pdf_report_options': 'PDF Report Options',
      'share_pdf': 'Share PDF',
      'please_wait': 'Please wait...',
      'storage_permissions_required': 'Storage permissions required',
      'view_pdf': 'View PDF',
      'try_sharing': 'Try Sharing',
      'press_again_to_exit': 'Press again to exit',
      'resending': 'Resending...',
      'download_pdf_title': 'Download PDF',
      'download_on_device': 'Save on device',
      'share_via_apps': 'WhatsApp, Gmail, Drive, etc.',

      'biometric_consent_title': 'Biometric Authentication',
      'biometric_consent_message':
          'To enable login with fingerprint or Face ID, we need your consent to securely store your credentials on your device.',
      'important_information': 'Important Information',
      'biometric_local_only':
          'Your credentials are stored only on your device',
      'biometric_device_only':
          'Fingerprint or Face ID is only used on this device',
      'biometric_disable_anytime':
          'You can disable this feature at any time',
      'biometric_no_external_sharing':
          'We never share your biometric data with third parties',
      'decline': 'Decline',
      'accept_and_continue': 'Accept and Continue',
      'remember_account': 'Remember account',
      'use_biometric': 'Use fingerprint/Face ID',
      'biometric_login': 'Login with biometrics',
      'authenticate_with': 'Authenticate with {0}',
      'session_expired': 'Session expired',
      'session_expired_message':
          'Your session expired due to inactivity. Please log in again.',

      'report_deleted_successfully': 'Report deleted',
      'no_pending_reports_sync': 'No pending reports to sync',
      'syncing_reports': 'Syncing Reports',
      'uploading_to_cloud': 'Uploading to cloud...',
      'reports_synced_successfully_count': '{0} report(s) synced successfully',
      'reports_synced_with_errors_count': '{0} synced, {1} with error',
      'sync_error_try_later': 'Sync error. Try again later.',
      'connection_error_msg': 'Connection error: {0}',
      'want_go_to_login_screen': 'Do you want to go to the login screen?',
      'local_reports_will_be_kept': 'Your {0} local report(s) will be kept',
      'go_to_login_short': 'Go to Login',
      'sync_action': 'Sync',
      'reports_ready_to_sync': '{0} report(s) ready to sync',
      'reports_created_saved_here': 'Reports you create will be saved here',
      'local_badge': 'Local',
      'syncing_status': 'Syncing...',
      'report_synced_successfully': 'Report synced successfully',
      'error_prefix': 'Error: {0}',
      'sync_reports_title': 'Sync Reports',
      'reports_pending_count': '{0} report(s) pending',
      'sync_all': 'Sync All',
      'sync_report': 'Sync Report',
      'sync_report_confirm': 'Do you want to sync this report?',
      'sync_now': 'Sync Now',

      'ai_chat_welcome_message': 'Hi! 👋 I\'m your animal welfare assistant.\n\nI\'ve analyzed your report ({0}% compliance). You can ask me **2 questions every 5 minutes** about:\n\n• Specific recommendations\n• How to improve critical points\n• Best practices\n• Results interpretation\n\nHow can I help you?',
      'wait_time_format': '{0}m {1}s',
      'rate_limit_reached': 'Limit reached. Wait {0} for more questions',
      'need_internet_connection_ai': 'You need internet connection',
      'ai_error_generating_response': '❌ Error generating response. Please try again.',
      'ai_consultation': 'AI Consultation',
      'thinking_status': 'Thinking...',
      'wait_for_more_questions': 'Wait {0} for more questions',
      'questions_remaining': '{0} question remaining',
      'ask_something': 'Ask something...',

      'pdf_saved_title': 'PDF Saved!',
      'pdf_saved_successfully_at': 'The PDF has been successfully saved at:',
      'find_in_downloads_android': 'Look in "Files" → "Downloads" on your device',
      'find_in_documents_ios': 'Look in the Documents folder',
      'storage_directory_error': 'Could not determine storage directory',
      'file_not_created_correctly': 'The file was not created correctly',
      'pdf_shared_successfully': 'PDF shared successfully',
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
