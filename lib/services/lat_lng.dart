import 'dart:math';

import 'package:latlong2/latlong.dart';

class LatLngBounds {
  final double north;
  final double south;
  final double east;
  final double west;

  LatLngBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  factory LatLngBounds.fromCenterAndRadius(LatLng center, double radiusInKm) {
    const double earthRadiusKm = 6371.0;

    final double deltaLatitude = radiusInKm / earthRadiusKm * (180 / pi);
    final double deltaLongitude = radiusInKm /
        (earthRadiusKm * cos(center.latitude * pi / 180)) *
        (180 / pi);

    return LatLngBounds(
      north: center.latitude + deltaLatitude,
      south: center.latitude - deltaLatitude,
      east: center.longitude + deltaLongitude,
      west: center.longitude - deltaLongitude,
    );
  }
}
