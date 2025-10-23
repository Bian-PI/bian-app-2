import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';
import 'login_screen.dart';
import 'package:bian_app/utils/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _presenter = AuthPresenter();
  final _formKey = GlobalKey<FormState>();

  String name = '', email = '', password = '', phone = '', document = '';
  bool loading = false;

  void doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final ok = await _presenter.register(name, email, password, phone, document);
    setState(() => loading = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Crear cuenta",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Únete a nuestra comunidad animalista",
                style: TextStyle(color: AppConstants.textPrimaryColor),
              ),
              const SizedBox(height: 40),

              // Nombre
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: "Nombre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (v) => name = v,
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 15),

              // Correo
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Correo",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (v) => email = v,
                validator: (v) => v!.contains('@') ? null : "Correo inválido",
              ),
              const SizedBox(height: 15),

              // Cédula
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                  labelText: "Cédula",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (v) => document = v,
              ),
              const SizedBox(height: 15),

              // Teléfono
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined),
                  labelText: "Teléfono",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (v) => phone = v,
              ),
              const SizedBox(height: 15),

              // Contraseña
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
                validator: (v) => v!.length < 4 ? "Mínimo 4 caracteres" : null,
              ),
              const SizedBox(height: 25),

              // Botón principal
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor, // color de fondo
                  foregroundColor: Colors.white, // color del texto
                  minimumSize: const Size(double.infinity, 50), // ancho y alto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: loading ? null : doRegister,
                child: Text(loading ? 'Cargando...' : 'Registrarse'),
              ),
              const SizedBox(height: 10),

              // Enlace de inicio de sesión (solo "Inicia sesión" en rojo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿Ya tienes cuenta? ",
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text(
                      "Inicia sesión",
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
      ),
    );
  }
}
