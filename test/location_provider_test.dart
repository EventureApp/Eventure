//test/location_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'mocks/mock_location_provider.dart';

void main() {
  group('LocationProvider Tests', () {
    late MockLocationProvider mockLocationProvider;

    setUp(() {
      mockLocationProvider = MockLocationProvider();
    });

    test('Should fetch current location and notify listeners', () async {
      // Arrange
      when(mockLocationProvider.fetchCurrentLocation())
          .thenAnswer((_) async => Future.value());

      // Act
      await mockLocationProvider.fetchCurrentLocation();

      // Assert
      verify(mockLocationProvider.fetchCurrentLocation()).called(1);
    });

    test('Should set and retrieve current location', () {
      // Arrange
      const mockLocation = LatLng(52.5200, 13.4050);

      // Act
      mockLocationProvider.setMockCurrentLocation(mockLocation);

      // Assert
      expect(mockLocationProvider.currentLocation, mockLocation);
    });

    test('Should set and retrieve current selected location', () {
      // Arrange
      const mockSelectedLocation = LatLng(48.8566, 2.3522);

      // Act
      mockLocationProvider.setMockCurrentSelectedLocation(mockSelectedLocation);

      // Assert
      expect(mockLocationProvider.currentSelectedLocation, mockSelectedLocation);
    });
  });
}
