import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage.dart';
import 'package:bian_app/utils/app_constants.dart';
import '../../auth/views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // // Ajusta el método según tu implementación de SecureStorage
    // // Opciones comunes: readSecureData, get, getValue, etc.
    // final name = await SecureStorage().readSecureData('user_name');
    // setState(() {
    //   userName = name ?? 'Usuario';
    // });
  }

  void logout(BuildContext context) async {
    await SecureStorage().clear();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "BIAN Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 30),
                const Text(
                  "Selecciona una especie",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Gestiona el bienestar animal",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                _buildAnimalCards(context),
                const SizedBox(height: 30),
                _buildStatsCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.primaryColor,
                    AppConstants.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName ?? 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Administrador",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home_rounded,
              title: 'Inicio',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.poll_rounded,
              title: 'Reportes',
              onTap: () {
                Navigator.pop(context);
                // Navegar a reportes
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: 'Configuración',
              onTap: () {
                Navigator.pop(context);
                // Navegar a configuración
              },
            ),
            _buildDrawerItem(
              icon: Icons.help_outline_rounded,
              title: 'Ayuda',
              onTap: () {
                Navigator.pop(context);
                // Navegar a ayuda
              },
            ),
            const Divider(height: 32),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Cerrar Sesión',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppConstants.errorColor : AppConstants.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppConstants.errorColor : AppConstants.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Activo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "¡Bienvenido, ${userName ?? 'Usuario'}!",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Gestiona el bienestar de tus animales",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalCards(BuildContext context) {
    return Column(
      children: [
        _buildAnimalCard(
          context: context,
          title: 'Aves',
          subtitle: 'Gestión de bienestar avícola',
          icon: Icons.flutter_dash_rounded,
          gradient: [const Color(0xFF4A90E2), const Color(0xFF357ABD)],
          onTap: () {
            // Navegar a la sección de aves
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sección de Aves')),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildAnimalCard(
          context: context,
          title: 'Cerdos',
          subtitle: 'Gestión de bienestar porcino',
          icon: Icons.pets_rounded,
          gradient: [const Color(0xFFE85D75), const Color(0xFFD84A64)],
          onTap: () {
            // Navegar a la sección de cerdos
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sección de Cerdos')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimalCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
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
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
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
              child: Icon(icon, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Estadísticas Rápidas",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Evaluaciones',
                value: '24',
                icon: Icons.assignment_turned_in_rounded,
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Alertas',
                value: '3',
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFFF9800),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
            style: const TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}