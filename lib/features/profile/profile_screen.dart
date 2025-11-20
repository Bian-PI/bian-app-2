import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/api/api_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/role_helper.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _storage = SecureStorage();
  final _apiService = ApiService();
  
  User? _currentUser;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isVerified = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    final user = await _storage.getUser();
    final verified = await _storage.isUserVerified();
    
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _documentController.text = user.document ?? '';
      _phoneController.text = user.phone ?? '';
    }
    
    setState(() {
      _currentUser = user;
      _isVerified = verified;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final updateData = <String, dynamic>{};
      
      // Name
      if (_nameController.text.trim().isNotEmpty && 
          _nameController.text.trim() != _currentUser!.name) {
        updateData['name'] = _nameController.text.trim();
      }
      
      // Phone
      if (_phoneController.text.trim().isNotEmpty && 
          _phoneController.text.trim() != (_currentUser!.phone ?? '')) {
        updateData['phone'] = _phoneController.text.trim();
      }
      
      // Password (opcional)
      if (_passwordController.text.isNotEmpty) {
        updateData['password'] = _passwordController.text;
      }
      
      print('📤 Sending update: $updateData');
      
      if (updateData.isEmpty) {
        setState(() {
          _isSaving = false;
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay cambios para guardar'),
            backgroundColor: BianTheme.warningYellow,
          ),
        );
        return;
      }
      
      final result = await _apiService.updateUser(
        _currentUser!.id!,
        updateData,
      );
      
      if (!mounted) return;
      
      setState(() => _isSaving = false);
      
      final loc = AppLocalizations.of(context);
      
      if (result['success']) {
        final updatedUser = _currentUser!.copyWith(
          name: updateData.containsKey('name') 
              ? updateData['name'] 
              : _currentUser!.name,
          phone: updateData.containsKey('phone') 
              ? updateData['phone'] 
              : _currentUser!.phone,
        );
        await _storage.saveUser(updatedUser);
        
        setState(() {
          _currentUser = updatedUser;
          _isEditing = false;
          _passwordController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(loc.translate('profile_updated'))),
              ],
            ),
            backgroundColor: BianTheme.successGreen,
          ),
        );
      } else {
        final message = result['message'] ?? 'server_error';
        
        String errorMsg;
        if (message.contains('phone')) {
          errorMsg = 'El teléfono ya está en uso';
        } else {
          errorMsg = loc.translate(message);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(errorMsg)),
              ],
            ),
            backgroundColor: BianTheme.errorRed,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('💥 Error saving: $e');
      setState(() => _isSaving = false);
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate('connection_error')),
          backgroundColor: BianTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.translate('profile'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('profile')),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BianTheme.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar y estado
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: BianTheme.primaryGradient,
                            boxShadow: BianTheme.elevatedShadow,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        if (_isVerified)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: BianTheme.successGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentUser?.name ?? 'Usuario',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isVerified
                            ? BianTheme.successGreen.withOpacity(0.1)
                            : BianTheme.warningYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isVerified
                              ? BianTheme.successGreen
                              : BianTheme.warningYellow,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isVerified ? Icons.check_circle : Icons.warning,
                            color: _isVerified
                                ? BianTheme.successGreen
                                : BianTheme.warningYellow,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isVerified
                                ? loc.translate('verified')
                                : loc.translate('not_verified'),
                            style: TextStyle(
                              color: _isVerified
                                  ? BianTheme.successGreen
                                  : BianTheme.warningYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Formulario
              TextFormField(
                controller: _nameController,
                enabled: _isEditing && !_isSaving,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(Validators.nameMaxLength),
                ],
                decoration: InputDecoration(
                  labelText: loc.translate('name'),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: _isEditing
                    ? (value) {
                        final error = Validators.validateFullName(value);
                        return error != null ? loc.translate(error) : null;
                      }
                    : null,
              ),
              
              const SizedBox(height: 16),
              
              // Email - NO editable
              TextFormField(
                controller: _emailController,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: BianTheme.mediumGray,
                ),
                decoration: InputDecoration(
                  labelText: loc.translate('email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: BianTheme.lightGray.withOpacity(0.3),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Document - NO editable
              TextFormField(
                controller: _documentController,
                enabled: false,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: BianTheme.mediumGray,
                ),
                decoration: InputDecoration(
                  labelText: loc.translate('document'),
                  prefixIcon: const Icon(Icons.badge_outlined),
                  filled: true,
                  fillColor: BianTheme.lightGray.withOpacity(0.3),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Phone
              TextFormField(
                controller: _phoneController,
                enabled: _isEditing && !_isSaving,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(Validators.phoneMaxLength),
                ],
                decoration: InputDecoration(
                  labelText: loc.translate('phone'),
                  prefixIcon: const Icon(Icons.phone_outlined),
                  helperText: _isEditing ? loc.translate('optional') : null,
                ),
                validator: _isEditing
                    ? (value) {
                        if (value == null || value.isEmpty) return null;
                        final error = Validators.validatePhone(value);
                        return error != null ? loc.translate(error) : null;
                      }
                    : null,
              ),
              
              if (_isEditing) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  enabled: !_isSaving,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: '${loc.translate('password')} (${loc.translate('optional')})',
                    hintText: loc.translate('leave_blank_keep_current'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _isSaving
                          ? null
                          : () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final error = Validators.validatePassword(value);
                    return error != null ? loc.translate(error) : null;
                  },
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Botones
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                setState(() {
                                  _isEditing = false;
                                  _passwordController.clear();
                                });
                                _loadUserData();
                              },
                        child: Text(loc.translate('cancel')),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(loc.translate('save')),
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 16),
              
              // Información adicional (solo lectura)
              if (!_isEditing) ...[
                _buildInfoCard(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  title: loc.translate('role'),
                  value: RoleHelper.translateRole(context, _currentUser?.role),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BianTheme.lightGray),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: BianTheme.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: BianTheme.primaryRed),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}