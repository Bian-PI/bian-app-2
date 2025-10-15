import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage.dart';
import '../../auth/views/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout(BuildContext context) async {
    await SecureStorage().clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A896),
        title: const Text("Inicio", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Bienvenido a BIAN 🐕",
          style: TextStyle(fontSize: 22, color: Color(0xFF333333)),
        ),
      ),
    );
  }
}
