class Validators {
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );
  
  static const int phoneMaxLength = 10;
  static const int documentMaxLength = 15;
  static const int nameMaxLength = 100;
  static const int emailMaxLength = 100;
  static const int passwordMinLength = 8;

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required';
    }
    if (value.length > emailMaxLength) {
      return 'max_length';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'invalid_email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }
    if (value.length < passwordMinLength) {
      return 'min_length';
    }
    if (!passwordRegex.hasMatch(value)) {
      return 'invalid_password';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'field_required';
    }
    if (value != password) {
      return 'password_mismatch';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required';
    }
    if (value.length > nameMaxLength) {
      return 'max_length';
    }
    
    final names = value.trim().split(RegExp(r'\s+'));
    if (names.length < 2) {
      return 'name_format';
    }
    
    return null;
  }

  static String? validateDocument(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required';
    }
    if (value.length > documentMaxLength) {
      return 'max_length';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required';
    }
    if (value.length < 10) {
      return 'invalid_phone';
    }
    if (value.length > phoneMaxLength) {
      return 'max_length';
    }
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'field_required';
    }
    return null;
  }
}