//test/event_filter_model_test.dart
import 'package:eventure/models/event_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventure/statics/event_types.dart';

void main() {
  group('EventFilter Model Tests', () {
    test('EventFilter should be correctly created with given parameters', () {
      final eventFilter = EventFilter(
        searchInput: 'test event',
        range: 10.0,
        location: LatLng(52.52, 13.405),
        startDate: DateTime(2025, 01, 01),
        endDate: DateTime(2025, 12, 31),
        eventType: [EventType.study, EventType.sport],
      );

      expect(eventFilter.searchInput, 'test event');
      expect(eventFilter.range, 10.0);
      expect(eventFilter.location.latitude, 52.52);
      expect(eventFilter.location.longitude, 13.405);
      expect(eventFilter.startDate, DateTime(2025, 01, 01));
      expect(eventFilter.endDate, DateTime(2025, 12, 31));
      expect(eventFilter.eventType, [EventType.study, EventType.sport]);
    });

    test('toString should return a readable string representation of EventFilter', () {
      final eventFilter = EventFilter(
        searchInput: 'test event',
        range: 10.0,
        location: LatLng(52.52, 13.405),
        startDate: DateTime(2025, 01, 01),
        endDate: DateTime(2025, 12, 31),
        eventType: [EventType.study, EventType.sport],
      );

      final eventFilterString = eventFilter.toString();

      expect(eventFilterString, contains('test event'));
      expect(eventFilterString, contains('10.0'));
      expect(eventFilterString, contains('LatLng(latitude:52.52, longitude:13.405)'));
      expect(eventFilterString, contains('2025-01-01 00:00:00.000'));
      expect(eventFilterString, contains('2025-12-31 00:00:00.000'));
      expect(eventFilterString, contains('[EventType.study, EventType.sport]'));
    });

    test('EventFilter should handle null values properly', () {
      final eventFilter = EventFilter(
        searchInput: null,
        range: 10.0,
        location: LatLng(52.52, 13.405),
        startDate: null,
        endDate: null,
        eventType: null,
      );

      expect(eventFilter.searchInput, isNull);
      expect(eventFilter.startDate, isNull);
      expect(eventFilter.endDate, isNull);
      expect(eventFilter.eventType, isNull);
    });
  });
}
