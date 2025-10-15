import '../../../core/api/auth_service.dart';

class AuthPresenter {
  final _service = AuthService();

  Future<bool> login(String email, String password) async {
    return _service.login(email, password);
  }

  Future<bool> register(String name, String email, String password, String phone, String cedula) async {
    return _service.register(name, email, password, phone, cedula);
  }
}
