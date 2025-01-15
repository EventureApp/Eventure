import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';

class MockLocationProvider extends Mock implements ChangeNotifier {
  LatLng? _mockCurrentLocation;
  LatLng? _mockCurrentSelectedLocation;

  LatLng? get currentLocation => _mockCurrentLocation;

  LatLng? get currentSelectedLocation => _mockCurrentSelectedLocation;

  Future<void> fetchCurrentLocation() async {
    super.noSuchMethod(
      Invocation.method(#fetchCurrentLocation, []),
      returnValue: Future<void>.value(),
    );
  }

  void setMockCurrentLocation(LatLng? location) {
    _mockCurrentLocation = location;
    notifyListeners();
  }

  void setMockCurrentSelectedLocation(LatLng? location) {
    _mockCurrentSelectedLocation = location;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.noSuchMethod(
      Invocation.method(#notifyListeners, []),
    );
  }
}

