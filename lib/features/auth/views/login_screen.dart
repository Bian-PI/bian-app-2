import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';
import '../../home/views/home_screen.dart';
import 'register_screen.dart';

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

  void doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final ok = await _presenter.login(email, password);
    setState(() => loading = false);

    if (ok && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciales incorrectas')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido 🐶",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF00A896)),
            ),
            const SizedBox(height: 8),
            const Text("Inicia sesión para continuar", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 50),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: "Correo o Cédula",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    onChanged: (v) => password = v,
                    validator: (v) => v!.length < 4 ? "Mínimo 4 caracteres" : null,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: loading ? null : doLogin,
                    child: Text(loading ? "Cargando..." : "Entrar"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text("¿No tienes cuenta? Regístrate"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
