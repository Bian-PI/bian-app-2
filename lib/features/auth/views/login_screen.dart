import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';
import '../../home/views/home_screen.dart';
import 'register_screen.dart';
import 'package:bian_app/utils/app_constants.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _presenter = AuthPresenter();
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool loading = false;

  // void doLogin() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => loading = true);
  //   final ok = await _presenter.login(email, password);
  //   setState(() => loading = false);
  //
  //   if (ok && mounted) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const HomeScreen()),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Credenciales incorrectas')),
  //     );
  //   }
  // }

  void doLogin() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 1)); // simula espera de login
    setState(() => loading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min, // solo ocupa espacio necesario
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animación Lottie
                Lottie.asset(
                  'assets/animations/home.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Inicia sesión para continuar",
                  style: TextStyle(color: AppConstants.textPrimaryColor),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: "Correo o Cédula",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onChanged: (v) => email = v,
                        validator: (v) => v!.isEmpty ? "Campo requerido" : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          labelText: "Contraseña",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onChanged: (v) => password = v,
                        validator: (v) =>
                        v!.length < 4 ? "Mínimo 4 caracteres" : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: loading ? null : doLogin,
                        child: Text(loading ? "Cargando..." : "Entrar"),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿No tienes cuenta? ",
                            style: TextStyle(color: Colors.black87),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            ),
                            child: const Text(
                              "Regístrate",
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
