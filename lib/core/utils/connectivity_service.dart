// lib/core/utils/connectivity_service.dart - MEJORAR DETECCIÓN
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => connectionStatusController.stream;

  Future<void> initialize() async {
    // ✅ ESCUCHAR CAMBIOS EN TIEMPO REAL
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final hasConnection = await _validateRealConnection(results);
      connectionStatusController.add(hasConnection);
      print('🔄 Conexión cambió: $hasConnection');
    });

    final hasConnection = await checkConnection();
    connectionStatusController.add(hasConnection);
    print('🟢 Conexión inicial: $hasConnection');
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return await _validateRealConnection(results);
    } catch (e) {
      print('❌ Error checking connection: $e');
      return false;
    }
  }

  // ✅ VALIDAR CONEXIÓN REAL (no solo WiFi/Mobile)
  Future<bool> _validateRealConnection(List<ConnectivityResult> results) async {
    final hasNetworkType = results.any((result) => 
      result == ConnectivityResult.mobile || 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet
    );

    if (!hasNetworkType) {
      return false;
    }

    // ✅ PING A GOOGLE PARA VALIDAR INTERNET REAL
    try {
      final response = await http.get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ No hay internet real: $e');
      return false;
    }
  }

  void dispose() {
    connectionStatusController.close();
  }
}