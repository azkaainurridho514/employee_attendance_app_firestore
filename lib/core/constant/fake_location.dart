import 'package:geolocator/geolocator.dart';
import 'package:trust_location/trust_location.dart';

class LocationService {
  static Future<bool> isFakeLocation() async {
    try {
      TrustLocation.start(5);

      bool isMock = await TrustLocation.isMockLocation;

      await TrustLocation.stop();

      return isMock;
    } catch (e) {
      print('Error checking fake location: $e');
      return true;
    }
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}
