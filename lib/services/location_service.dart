import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Enum defining location error statuses for UI and service handling.
enum LocationErrorStatus {
  none,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeoutOrFailed,
}

/// Data model representing captured location and reverse geocoded address.
class LocationResult {
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final String formattedAddress;
  final bool isSuccess;
  final LocationErrorStatus errorStatus;
  final String? errorMessage;

  const LocationResult({
    this.latitude,
    this.longitude,
    this.accuracy,
    required this.formattedAddress,
    required this.isSuccess,
    this.errorStatus = LocationErrorStatus.none,
    this.errorMessage,
  });

  factory LocationResult.success({
    required double latitude,
    required double longitude,
    required double accuracy,
    required String address,
  }) {
    return LocationResult(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      formattedAddress: address,
      isSuccess: true,
      errorStatus: LocationErrorStatus.none,
    );
  }

  factory LocationResult.failure({
    required LocationErrorStatus errorStatus,
    required String errorMessage,
  }) {
    return LocationResult(
      formattedAddress: errorMessage,
      isSuccess: false,
      errorStatus: errorStatus,
      errorMessage: errorMessage,
    );
  }
}

/// Service for retrieving GPS coordinates, managing permissions, and reverse geocoding addresses.
class LocationService {
  /// Checks if device GPS location services are enabled.
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      return false;
    }
  }

  /// Checks permission status.
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Requests location permission from the operating system.
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Opens app settings page.
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Opens device location settings.
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Acquires real device GPS coordinates, applies accuracy filter,
  /// and performs reverse geocoding into formatted human-readable address.
  static Future<LocationResult> getCurrentLocation({
    Duration timeout = const Duration(seconds: 8),
    bool reverseGeocode = true,
  }) async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.failure(
          errorStatus: LocationErrorStatus.serviceDisabled,
          errorMessage:
              'Location service disabled. Please turn on GPS and tap Reload.',
        );
      }

      var permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.failure(
            errorStatus: LocationErrorStatus.permissionDenied,
            errorMessage:
                'Location permission denied. Please allow access and tap Reload.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.failure(
          errorStatus: LocationErrorStatus.permissionDeniedForever,
          errorMessage:
              'Location permission permanently denied. Enable in app settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeout,
        ),
      );

      final lat = position.latitude;
      final lng = position.longitude;
      final acc = position.accuracy;

      String formattedAddress =
          'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';

      if (reverseGeocode) {
        final address = await getAddressFromCoordinates(
          latitude: lat,
          longitude: lng,
        );
        if (address != null && address.trim().isNotEmpty) {
          formattedAddress = address;
        }
      }

      return LocationResult.success(
        latitude: lat,
        longitude: lng,
        accuracy: acc,
        address: formattedAddress,
      );
    } catch (_) {
      return LocationResult.failure(
        errorStatus: LocationErrorStatus.timeoutOrFailed,
        errorMessage:
            'Unable to acquire GPS location. Please tap Reload to retry.',
      );
    }
  }

  /// Reverse geocodes latitude/longitude into human-readable address.
  static Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
    Duration timeout = const Duration(seconds: 4),
  }) async {
    try {
      final placemarks = await Geocoding()
          .placemarkFromCoordinates(latitude, longitude)
          .timeout(timeout);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.subAdministrativeArea,
          p.administrativeArea,
          p.postalCode,
          p.country,
        ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();
        if (parts.isNotEmpty) {
          return parts.join(', ');
        }
      }
    } catch (_) {}
    return null;
  }
}
