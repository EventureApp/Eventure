import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarkerProvider extends ChangeNotifier {
  final List<Marker> _markers = [
    const Marker(
      point: LatLng(49.4699765, 8.4819024),
      width: 80,
      height: 80,
      child: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    ),
  ];

  List<Marker> get markers => List.unmodifiable(_markers);

  void addMarker(LatLng position, String title) {
    _markers.add(
      Marker(
        point: position,
        width: 80,
        height: 80,
        child: Tooltip(
          message: title,
          child: const Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 40,
          ),
        ),
      ),
    );
    notifyListeners();
  }
}
