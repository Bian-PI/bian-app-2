import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _presenter = AuthPresenter();
  final _formKey = GlobalKey<FormState>();

  String name = '', email = '', password = '', phone = '', cedula = '';
  bool loading = false;

  void doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final ok = await _presenter.register(name, email, password, phone, cedula);
    setState(() => loading = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al registrar')));
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
                "Crear cuenta 🐾",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00A896)),
              ),
              const SizedBox(height: 10),
              const Text("Únete a nuestra comunidad animalista", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person_outline)),
                onChanged: (v) => name = v,
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.email_outlined)),
                onChanged: (v) => email = v,
                validator: (v) => v!.contains('@') ? null : "Correo inválido",
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cédula', prefixIcon: Icon(Icons.badge_outlined)),
                onChanged: (v) => cedula = v,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone_outlined)),
                onChanged: (v) => phone = v,
              ),
              const SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
                onChanged: (v) => password = v,
                validator: (v) => v!.length < 4 ? "Mínimo 4 caracteres" : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: loading ? null : doRegister,
                child: Text(loading ? 'Cargando...' : 'Registrarse'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text("¿Ya tienes cuenta? Inicia sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
