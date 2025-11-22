import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/drafts_storage.dart';
import '../../core/storage/reports_storage.dart';
import '../../core/api/api_service.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';
import '../../core/models/species_model.dart';
import '../../core/models/evaluation_model.dart';
import '../../core/providers/language_provider.dart';
import '../../core/utils/role_helper.dart';
import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';
import '../evaluation/evaluation_screen.dart';
import '../evaluation/results_screen.dart';
import '../../core/widgets/connectivity_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = SecureStorage();
  final _apiService = ApiService();
  
  User? _currentUser;
  bool _isVerified = false;
  bool _isLoading = true;
  
  List<Evaluation> _drafts = [];
  List<Evaluation> _reports = [];
  int _farmsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    
    final user = await _storage.getUser();
    final verified = await _storage.isUserVerified();
    final drafts = await DraftsStorage.getAllDrafts();
    final reports = await ReportsStorage.getAllReports();
    final farms = await ReportsStorage.getUniqueFarms();
    
    setState(() {
      _currentUser = user;
      _isVerified = verified;
      _drafts = drafts;
      _reports = reports;
      _farmsCount = farms.length;
      _isLoading = false;
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (_currentUser == null) return;
    
    final loc = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final result = await _apiService.resendVerificationEmail(
        _currentUser!.id!,
        _currentUser!.email,
      );
      
      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success'] 
              ? loc.translate('verification_sent')
              : loc.translate('server_error')
          ),
          backgroundColor: result['success'] 
            ? BianTheme.successGreen 
            : BianTheme.errorRed,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('connection_error')),
          backgroundColor: BianTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final loc = AppLocalizations.of(context);
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('logout')),
        content: Text(loc.translate('logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BianTheme.errorRed),
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('logout')),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await _storage.clearAll();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  void _showLanguageDialog() {
    final loc = AppLocalizations.of(context);
    final provider = Provider.of<LanguageProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('select_language')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                title: Text(loc.translate('spanish')),
                onTap: () async {
                  await provider.setLocale(const Locale('es'));
                  if (mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: Text(loc.translate('english')),
                onTap: () async {
                  await provider.setLocale(const Locale('en'));
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEvaluation(Species species) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EvaluationScreen(
          species: species,
          currentLanguage: languageProvider.locale.languageCode,
        ),
      ),
    );
    
    _loadAllData();
  }

  void _continueDraft(Evaluation draft) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final species = draft.speciesId == 'birds' ? Species.birds() : Species.pigs();
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EvaluationScreen(
          species: species,
          draftToEdit: draft,
          currentLanguage: languageProvider.locale.languageCode,
        ),
      ),
    );
    
    _loadAllData();
  }

  void _viewReport(Evaluation report) async {
    final species = report.speciesId == 'birds' ? Species.birds() : Species.pigs();
    
    final results = _recalculateResults(report, species);

    final translatedRecommendations = _translateRecommendations(
      results['recommendations'],
      report.language,
    );

    final structuredJson = await report.generateStructuredJSON(
      species,
      results,
      translatedRecommendations,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          evaluation: report,
          species: species,
          results: results,
          structuredJson: structuredJson,
        ),
      ),
    );
  }

  Map<String, dynamic> _recalculateResults(Evaluation evaluation, Species species) {
    int totalQuestions = 0;
    int positiveResponses = 0;
    final categoryScores = <String, double>{};

    for (var category in species.categories) {
      int categoryTotal = 0;
      int categoryPositive = 0;

      for (var field in category.fields) {
        if (field.type == FieldType.yesNo) {
          final key = '${category.id}_${field.id}';
          final value = evaluation.responses[key];
          
          if (value != null) {
            categoryTotal++;
            totalQuestions++;
            
            bool isPositive = false;
            if (field.id.contains('access') || 
                field.id.contains('quality') || 
                field.id.contains('sufficient') ||
                field.id.contains('health') ||
                field.id.contains('vaccination') ||
                field.id.contains('natural_behavior') ||
                field.id.contains('movement') ||
                field.id.contains('ventilation') ||
                field.id.contains('training') ||
                field.id.contains('records') ||
                field.id.contains('biosecurity') ||
                field.id.contains('handling') ||
                field.id.contains('lighting') ||
                field.id.contains('enrichment') ||
                field.id.contains('resting_area') ||
                field.id.contains('castration')) {
              isPositive = value == true;
            } else {
              isPositive = value == false;
            }
            
            if (isPositive) {
              categoryPositive++;
              positiveResponses++;
            }
          }
        }
      }

      if (categoryTotal > 0) {
        categoryScores[category.id] = (categoryPositive / categoryTotal) * 100;
      }
    }

    final overallScore = totalQuestions > 0 ? (positiveResponses / totalQuestions) * 100 : 0;

    String complianceLevel;
    if (overallScore >= 90) {
      complianceLevel = 'excellent';
    } else if (overallScore >= 75) {
      complianceLevel = 'good';
    } else if (overallScore >= 60) {
      complianceLevel = 'acceptable';
    } else if (overallScore >= 40) {
      complianceLevel = 'needs_improvement';
    } else {
      complianceLevel = 'critical';
    }

    final recommendationKeys = <String>[];
    if (overallScore < 60) recommendationKeys.add('immediate_attention_required');
    if (categoryScores['feeding'] != null && categoryScores['feeding']! < 70) {
      recommendationKeys.add('improve_feeding_practices');
    }
    if (categoryScores['health'] != null && categoryScores['health']! < 70) {
      recommendationKeys.add('strengthen_health_program');
    }
    if (categoryScores['infrastructure'] != null && categoryScores['infrastructure']! < 70) {
      recommendationKeys.add('improve_infrastructure');
    }
    if (categoryScores['management'] != null && categoryScores['management']! < 70) {
      recommendationKeys.add('train_staff_welfare');
    }
    if (recommendationKeys.isEmpty) recommendationKeys.add('maintain_current_practices');

    return {
      'overall_score': overallScore,
      'compliance_level': complianceLevel,
      'category_scores': categoryScores,
      'recommendations': recommendationKeys,
      'critical_points': [],
      'strong_points': [],
    };
  }

  List<String> _translateRecommendations(List recommendationKeys, String language) {
    final translations = <String, String>{
      'immediate_attention_required': language == 'es' 
          ? 'Se requiere atención inmediata para mejorar las condiciones de bienestar animal'
          : 'Immediate attention required to improve animal welfare conditions',
      'improve_feeding_practices': language == 'es'
          ? 'Mejorar las prácticas de alimentación y asegurar acceso constante a agua y alimento de calidad'
          : 'Improve feeding practices and ensure constant access to quality water and food',
      'strengthen_health_program': language == 'es'
          ? 'Fortalecer el programa de salud animal, incluyendo vacunación y control de enfermedades'
          : 'Strengthen animal health program, including vaccination and disease control',
      'improve_infrastructure': language == 'es'
          ? 'Mejorar las instalaciones para proporcionar espacios adecuados, ventilación y condiciones ambientales óptimas'
          : 'Improve facilities to provide adequate space, ventilation and optimal environmental conditions',
      'train_staff_welfare': language == 'es'
          ? 'Capacitar al personal en bienestar animal y mantener registros actualizados'
          : 'Train staff in animal welfare and maintain updated records',
      'maintain_current_practices': language == 'es'
          ? 'Mantener las buenas prácticas actuales y continuar monitoreando el bienestar animal'
          : 'Maintain current good practices and continue monitoring animal welfare',
    };

    final translatedRecommendations = <String>[];
    for (var key in recommendationKeys) {
      if (translations.containsKey(key)) {
        translatedRecommendations.add(translations[key]!);
      }
    }

    return translatedRecommendations;
  }

  Future<void> _deleteDraft(String id) async {
    final loc = AppLocalizations.of(context);
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('delete_draft')),
        content: Text('¿Seguro que deseas eliminar este borrador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BianTheme.errorRed),
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('delete')),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await DraftsStorage.deleteDraft(id);
      _loadAllData();
    }
  }


@override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return ConnectivityWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.translate('home')),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.translate('no_notifications'))),
                );
              },
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: Column(
          children: [
            if (!_isVerified)
              Container(
                color: BianTheme.warningYellow,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        loc.translate('email_not_verified'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _resendVerificationEmail,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: BianTheme.warningYellow,
                      ),
                      child: Text(loc.translate('verify_email')),
                    ),
                  ],
                ),
              ),
            
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadAllData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(BianTheme.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeCard(context),
                      
                      const SizedBox(height: 30),
                      
                      Text(
                        loc.translate('select_species'),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 24),
                      _buildSpeciesCards(context),
                      
                      const SizedBox(height: 30),
                      
                      _buildQuickStats(context),
                      
                      if (_drafts.isNotEmpty) ...[
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              loc.translate('saved_drafts'),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              '${_drafts.length}/2',
                              style: TextStyle(
                                color: BianTheme.mediumGray,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._drafts.map((draft) => _buildDraftCard(context, draft)),
                      ],
                      
                      const SizedBox(height: 30),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.translate('completed_evaluations'),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '${_reports.length}',
                            style: TextStyle(
                              color: BianTheme.primaryRed,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (_reports.isEmpty)
                        _buildEmptyReportsCard(context)
                      else
                        ..._reports.map((report) => _buildReportCard(context, report)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: BianTheme.primaryGradient),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: BianTheme.primaryRed),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentUser?.name ?? 'Usuario',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          RoleHelper.translateRole(context, _currentUser?.role),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isVerified
                                ? Colors.green.withOpacity(0.3)
                                : Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isVerified ? Icons.check_circle : Icons.warning,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isVerified
                                    ? loc.translate('verified')
                                    : loc.translate('not_verified'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home_rounded, color: BianTheme.primaryRed),
            title: Text(loc.translate('home')),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: BianTheme.primaryRed),
            title: Text(loc.translate('profile')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: BianTheme.primaryRed),
            title: Text(loc.translate('language')),
            onTap: () {
              Navigator.pop(context);
              _showLanguageDialog();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: BianTheme.errorRed),
            title: Text(loc.translate('logout')),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: BianTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BianTheme.elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo2.png',
                width: 50,
                height: 50,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  loc.translate('active'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            loc.translate('welcome_user', [_currentUser?.name ?? 'Usuario']),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('manage_animal_welfare'),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesCards(BuildContext context) {
    final birds = Species.birds();
    final pigs = Species.pigs();
    
    return Column(
      children: [
        _buildSpeciesCard(
          species: birds,
          onTap: () => _navigateToEvaluation(birds),
        ),
        const SizedBox(height: 16),
        _buildSpeciesCard(
          species: pigs,
          onTap: () => _navigateToEvaluation(pigs),
        ),
      ],
    );
  }

  Widget _buildSpeciesCard({
    required Species species,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(int.parse(species.gradientColors[0])),
              Color(int.parse(species.gradientColors[1])),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(int.parse(species.gradientColors[0])).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SvgPicture.asset(
                species.iconPath,
                width: 40,
                height: 40,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate(species.id),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).translate('${species.id}_subtitle'),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('quick_stats'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: loc.translate('evaluations'),
                value: '${_reports.length}',
                icon: Icons.assignment_turned_in_rounded,
                color: BianTheme.successGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: loc.translate('farms'),
                value: '$_farmsCount',
                icon: Icons.home_work_rounded,
                color: BianTheme.infoBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BianTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: BianTheme.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftCard(BuildContext context, Evaluation draft) {
    final loc = AppLocalizations.of(context);
    final species = draft.speciesId == 'birds' ? Species.birds() : Species.pigs();
    final progress = draft.getProgress(species);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _continueDraft(draft),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BianTheme.warningYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.edit_note,
                        color: BianTheme.warningYellow,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${loc.translate('draft_for')} ${species.namePlural}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (draft.farmName.isNotEmpty)
                            Text(
                              draft.farmName,
                              style: TextStyle(
                                fontSize: 12,
                                color: BianTheme.mediumGray,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: BianTheme.errorRed),
                      onPressed: () => _deleteDraft(draft.id),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: BianTheme.lightGray,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            BianTheme.warningYellow,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: BianTheme.warningYellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _continueDraft(draft),
                  icon: Icon(Icons.play_arrow),
                  label: Text(loc.translate('continue_draft')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BianTheme.warningYellow,
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Evaluation report) {
    
    Color scoreColor;
    if (report.overallScore! >= 80) {
      scoreColor = BianTheme.successGreen;
    } else if (report.overallScore! >= 60) {
      scoreColor = BianTheme.warningYellow;
    } else {
      scoreColor = BianTheme.errorRed;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _viewReport(report),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${report.overallScore!.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          fontSize: 12,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.farmName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: BianTheme.mediumGray,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              report.farmLocation,
                              style: TextStyle(
                                fontSize: 12,
                                color: BianTheme.mediumGray,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: BianTheme.mediumGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${report.evaluationDate.day}/${report.evaluationDate.month}/${report.evaluationDate.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: BianTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: BianTheme.mediumGray,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyReportsCard(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BianTheme.lightGray.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: BianTheme.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            loc.translate('no_evaluations'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: BianTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('start_first_evaluation'),
            style: TextStyle(
              fontSize: 14,
              color: BianTheme.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}