import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      // General
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
      
      // Auth
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
      
      // Validation Messages
      'field_required': 'Este campo es requerido',
      'invalid_email': 'Correo electrónico inválido',
      'invalid_password': 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial',
      'password_mismatch': 'Las contraseñas no coinciden',
      'min_length': 'Mínimo {0} caracteres',
      'max_length': 'Máximo {0} caracteres',
      'invalid_phone': 'Teléfono inválido (mínimo 10 dígitos)',
      'invalid_document': 'Documento inválido',
      'name_format': 'Ingresa al menos nombre y apellido',
      
      // Auth Errors
      'invalid_credentials': 'Credenciales incorrectas',
      'user_not_verified': 'Tu cuenta no está verificada. Te hemos enviado un correo de verificación.',
      'user_exists': 'El usuario ya existe',
      'connection_error': 'Error de conexión',
      'timeout_error': 'Tiempo de espera agotado. Verifica tu conexión',
      'server_error': 'Error del servidor. Intenta de nuevo',
      
      // Auth Success
      'login_success': 'Inicio de sesión exitoso',
      'register_success': 'Registro exitoso',
      'logout_confirm': '¿Estás seguro que deseas cerrar sesión?',
      
      // Email Verification
      'verify_email': 'Verificar Correo',
      'email_not_verified': 'Correo no verificado',
      'email_verified': 'Correo verificado',
      'verification_sent': 'Correo de verificación enviado',
      'resend_verification': 'Reenviar correo de verificación',
      'check_email': 'Revisa tu correo para verificar tu cuenta',
      'verify_account_title': 'Verificación de Cuenta',
      'verify_account_message': 'Tu cuenta no está verificada. Te hemos enviado un correo de verificación.',
      'send_verification_email': 'Enviar correo de verificación',
      
      // Home
      'home': 'Inicio',
      'dashboard': 'Panel de Control',
      'welcome_user': '¡Bienvenido, {0}!',
      'select_species': 'Selecciona una especie',
      'manage_animal_welfare': 'Gestiona el bienestar animal',
      'birds': 'Aves',
      'birds_subtitle': 'Gestión de bienestar avícola',
      'pigs': 'Cerdos',
      'pigs_subtitle': 'Gestión de bienestar porcino',
      'quick_stats': 'Estadísticas Rápidas',
      'evaluations': 'Evaluaciones',
      'alerts': 'Alertas',
      'active': 'Activo',
      'verified': 'Verificado',
      'not_verified': 'No Verificado',
      
      // Profile
      'profile': 'Perfil',
      'my_profile': 'Mi Perfil',
      'edit_profile': 'Editar Perfil',
      'profile_updated': 'Perfil actualizado correctamente',
      'name': 'Nombre',
      'role': 'Rol',
      'account_status': 'Estado de Cuenta',
      'verification_status': 'Estado de Verificación',
      'admin': 'Administrador',
      'user': 'Usuario',
      
      // Drawer Menu
      'history': 'Historial',
      'reports': 'Reportes',
      'help': 'Ayuda',
      'about': 'Acerca de',
      'language': 'Idioma',
      'select_language': 'Seleccionar Idioma',
      'spanish': 'Español',
      'english': 'Inglés',
      
      // Coming Soon
      'coming_soon': '{0} próximamente',
      'feature_coming_soon': 'Esta función estará disponible próximamente',
      
      // Help
      'need_help': '¿Necesitas ayuda?',
      'contact_support': 'Contacta con soporte técnico en:',
      
      // Notifications
      'no_notifications': 'No tienes notificaciones nuevas',
      'notifications': 'Notificaciones',
      
      // Profile extras
      'optional': 'opcional',
      'leave_blank_keep_current': 'Dejar en blanco para mantener actual',
      
      // Email verification steps
      'step_1_title': 'Revisa tu bandeja',
      'step_1_description': 'Te enviamos un correo con el enlace de verificación',
      'step_2_title': 'Haz clic en el enlace',
      'step_2_description': 'Abre el correo y presiona el botón de verificación',
      'step_3_title': 'Inicia sesión',
      'step_3_description': 'Una vez verificado, podrás acceder a tu cuenta',
      'check_spam_folder': 'Si no encuentras el correo, revisa tu carpeta de spam o correo no deseado',
      'resend_in': 'Reenviar en',
      'seconds': 's',
      'go_to_login': 'Ir a Iniciar Sesión',
    },
    'en': {
      // General
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
      
      // Auth
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
      
      // Validation Messages
      'field_required': 'This field is required',
      'invalid_email': 'Invalid email',
      'invalid_password': 'Password must have at least 8 characters, one uppercase, one lowercase, one number and one special character',
      'password_mismatch': 'Passwords do not match',
      'min_length': 'Minimum {0} characters',
      'max_length': 'Maximum {0} characters',
      'invalid_phone': 'Invalid phone (minimum 10 digits)',
      'invalid_document': 'Invalid document',
      'name_format': 'Enter at least first and last name',
      
      // Auth Errors
      'invalid_credentials': 'Invalid credentials',
      'user_not_verified': 'Your account is not verified. We have sent you a verification email.',
      'user_exists': 'User already exists',
      'connection_error': 'Connection error',
      'timeout_error': 'Request timeout. Check your connection',
      'server_error': 'Server error. Try again',
      
      // Auth Success
      'login_success': 'Login successful',
      'register_success': 'Registration successful',
      'logout_confirm': 'Are you sure you want to logout?',
      
      // Email Verification
      'verify_email': 'Verify Email',
      'email_not_verified': 'Email not verified',
      'email_verified': 'Email verified',
      'verification_sent': 'Verification email sent',
      'resend_verification': 'Resend verification email',
      'check_email': 'Check your email to verify your account',
      'verify_account_title': 'Account Verification',
      'verify_account_message': 'Your account is not verified. We have sent you a verification email.',
      'send_verification_email': 'Send verification email',
      
      // Home
      'home': 'Home',
      'dashboard': 'Dashboard',
      'welcome_user': 'Welcome, {0}!',
      'select_species': 'Select a species',
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
      
      // Profile
      'profile': 'Profile',
      'my_profile': 'My Profile',
      'edit_profile': 'Edit Profile',
      'profile_updated': 'Profile updated successfully',
      'name': 'Name',
      'role': 'Role',
      'account_status': 'Account Status',
      'verification_status': 'Verification Status',
      'admin': 'Administrator',
      'user': 'User',
      
      // Drawer Menu
      'history': 'History',
      'reports': 'Reports',
      'help': 'Help',
      'about': 'About',
      'language': 'Language',
      'select_language': 'Select Language',
      'spanish': 'Spanish',
      'english': 'English',
      
      // Coming Soon
      'coming_soon': '{0} coming soon',
      'feature_coming_soon': 'This feature will be available soon',
      
      // Help
      'need_help': 'Need help?',
      'contact_support': 'Contact technical support at:',
      
      // Notifications
      'no_notifications': 'No new notifications',
      'notifications': 'Notifications',
      
      // Profile extras
      'optional': 'optional',
      'leave_blank_keep_current': 'Leave blank to keep current',
      
      // Email verification steps
      'step_1_title': 'Check your inbox',
      'step_1_description': 'We sent you an email with the verification link',
      'step_2_title': 'Click the link',
      'step_2_description': 'Open the email and press the verification button',
      'step_3_title': 'Sign in',
      'step_3_description': 'Once verified, you can access your account',
      'check_spam_folder': 'If you can\'t find the email, check your spam or junk folder',
      'resend_in': 'Resend in',
      'seconds': 's',
      'go_to_login': 'Go to Login',
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

  // Shortcuts para los textos más usados
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

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
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