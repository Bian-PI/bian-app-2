import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Modelo para almacenar información completa de ubicación
class LocationData {
  final String? department;      // Departamento / Estado
  final String? municipality;    // Ciudad / Municipio
  final String? subLocality;     // Vereda / Barrio
  final double latitude;
  final double longitude;
  final String formattedAddress; // Dirección formateada

  LocationData({
    this.department,
    this.municipality,
    this.subLocality,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });

  String get coordinatesString => '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  
  @override
  String toString() => formattedAddress;
}

class LocationService {
  static Future<LocationPermissionStatus> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    return LocationPermissionStatus.granted;
  }

  /// Obtiene la ubicación actual con datos detallados
  /// Retorna LocationData con departamento, municipio, coordenadas, etc.
  static Future<LocationData?> getCurrentLocationDetailed() async {
    try {
      final permissionStatus = await checkAndRequestPermission();

      if (permissionStatus != LocationPermissionStatus.granted) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      String? department;
      String? municipality;
      String? subLocality;
      String formattedAddress = '${position.latitude}, ${position.longitude}';

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          
          // Extraer datos
          department = place.administrativeArea; // Departamento/Estado
          municipality = place.locality ?? place.subAdministrativeArea; // Ciudad/Municipio
          subLocality = place.subLocality; // Vereda/Barrio
          
          // Construir dirección formateada
          List<String> parts = [];
          if (municipality != null && municipality.isNotEmpty) {
            parts.add(municipality);
          }
          if (department != null && department.isNotEmpty) {
            parts.add(department);
          }
          
          formattedAddress = parts.isNotEmpty 
              ? parts.join(', ') 
              : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        }
      } catch (geocodeError) {
        // Si falla el geocoding (sin conexión), solo usar coordenadas
        print('Geocoding failed (possibly offline): $geocodeError');
      }

      return LocationData(
        department: department,
        municipality: municipality,
        subLocality: subLocality,
        latitude: position.latitude,
        longitude: position.longitude,
        formattedAddress: formattedAddress,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Método legacy para compatibilidad - devuelve solo string
  static Future<String?> getCurrentLocation() async {
    final locationData = await getCurrentLocationDetailed();
    return locationData?.formattedAddress;
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}
