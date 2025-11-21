import 'package:flutter/material.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/utils/role_helper.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = SecureStorage();
  
  User? _currentUser;
  bool _isLoading = true;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    final user = await _storage.getUser();
    final verified = await _storage.isUserVerified();
    
    setState(() {
      _currentUser = user;
      _isVerified = verified;
      _isLoading = false;
    });
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
    
    return WillPopScope(
      onWillPop: () async {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.translate('profile')),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(BianTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              
              _buildInfoCard(
                context,
                icon: Icons.person_outline,
                title: loc.translate('name'),
                value: _currentUser?.name ?? 'N/A',
              ),
              
              const SizedBox(height: 16),
              
              _buildInfoCard(
                context,
                icon: Icons.email_outlined,
                title: loc.translate('email'),
                value: _currentUser?.email ?? 'N/A',
              ),
              
              const SizedBox(height: 16),
              
              _buildInfoCard(
                context,
                icon: Icons.badge_outlined,
                title: loc.translate('document'),
                value: _currentUser?.document ?? 'N/A',
              ),
              
              const SizedBox(height: 16),
              
              _buildInfoCard(
                context,
                icon: Icons.phone_outlined,
                title: loc.translate('phone'),
                value: _currentUser?.phone ?? 'N/A',
              ),
              
              const SizedBox(height: 16),
              
              _buildInfoCard(
                context,
                icon: Icons.admin_panel_settings_outlined,
                title: loc.translate('role'),
                value: RoleHelper.translateRole(context, _currentUser?.role),
              ),
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
        boxShadow: BianTheme.cardShadow,
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: BianTheme.mediumGray,
                  ),
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