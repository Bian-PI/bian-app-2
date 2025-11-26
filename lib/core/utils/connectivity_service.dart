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

    // Primero emitir un estado optimista basado solo en tipo de red
    final initialResults = await _connectivity.checkConnectivity();
    final hasNetworkType = _hasAnyNetworkType(initialResults);

    // Emitir estado optimista inmediatamente
    _lastKnownState = hasNetworkType;
    connectionStatusController.add(hasNetworkType);
    print('🟢 Estado inicial optimista: $hasNetworkType (basado en tipo de red)');

    // Luego validar la conexión real en background
    if (hasNetworkType) {
      _validateRealConnection(initialResults).then((hasInternet) {
        if (_lastKnownState != hasInternet) {
          print('🔄 Validación real cambió estado de $_lastKnownState a $hasInternet');
          _lastKnownState = hasInternet;
          connectionStatusController.add(hasInternet);
        }
      });
    }

    // Escuchar cambios futuros
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
  }

  bool _hasAnyNetworkType(List<ConnectivityResult> results) {
    if (results.isEmpty || results.first == ConnectivityResult.none) {
      return false;
    }
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
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

    // Probar múltiples endpoints para validar conexión real
    // Solo necesitamos que UNO funcione para considerar que hay internet
    final testUrls = [
      'https://www.google.com',
      'https://1.1.1.1', // Cloudflare DNS
      'https://dns.google', // Google DNS
    ];

    for (final url in testUrls) {
      try {
        print('🌐 Probando conectividad con $url...');
        final response = await http.head(Uri.parse(url))
            .timeout(Duration(seconds: 8));
        if (response.statusCode >= 200 && response.statusCode < 500) {
          print('✅ Conectividad confirmada con $url (${response.statusCode})');
          return true;
        }
        print('⚠️ $url respondió con ${response.statusCode}, probando siguiente...');
      } catch (e) {
        print('⚠️ $url falló: $e, probando siguiente...');
        continue;
      }
    }

    print('❌ Todos los endpoints fallaron - Sin conectividad real');
    return false;
  }

  void dispose() {
    connectionStatusController.close();
  }
}