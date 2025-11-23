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
  bool? _lastKnownState;

  Future<void> initialize() async {
    print('🔧 Inicializando ConnectivityService...');
    
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      print('📡 Cambio detectado en conectividad: $results');
      final hasConnection = await _validateRealConnection(results);
      
      if (_lastKnownState != hasConnection) {
        print('🔄 Estado cambió de $_lastKnownState a $hasConnection - EMITIENDO');
        _lastKnownState = hasConnection;
        connectionStatusController.add(hasConnection);
      } else {
        print('⏸️ Estado igual ($_lastKnownState) - NO emitir');
      }
    });

    final hasConnection = await checkConnection();
    _lastKnownState = hasConnection;
    connectionStatusController.add(hasConnection);
    print('🟢 Estado inicial: $hasConnection');
  }

  Future<bool> checkConnection() async {
    try {
      print('🔍 Verificando conexión...');
      final results = await _connectivity.checkConnectivity();
      print('📱 Resultados de connectivity: $results');
      final isConnected = await _validateRealConnection(results);
      print(isConnected ? '✅ CONEXIÓN OK' : '❌ SIN CONEXIÓN');
      return isConnected;
    } catch (e) {
      print('❌ Error checking connection: $e');
      return false;
    }
  }

  Future<bool> _validateRealConnection(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.first == ConnectivityResult.none) {
      print('❌ Sin tipo de red (none)');
      return false;
    }

    final hasNetworkType = results.any((result) => 
      result == ConnectivityResult.mobile || 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet
    );

    if (!hasNetworkType) {
      print('❌ Sin tipo de red válido');
      return false;
    }

    try {
      print('🌐 Haciendo ping a Google...');
      final response = await http.get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5));
      final hasInternet = response.statusCode == 200;
      print(hasInternet ? '✅ Ping exitoso (200)' : '❌ Ping falló (${response.statusCode})');
      return hasInternet;
    } catch (e) {
      print('❌ Ping falló con excepción: $e');
      return false;
    }
  }

  void dispose() {
    connectionStatusController.close();
  }
}