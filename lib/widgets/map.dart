import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../models/event.dart';

class MapWidget extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? currentSelectedLocation;

  const MapWidget(
      {super.key, required this.currentLocation, this.currentSelectedLocation});

  @override
  State<StatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  late LatLng _currentLocation;
  late LatLng? _currentSelectedLocation;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.currentLocation;
    _currentSelectedLocation = widget.currentSelectedLocation;
    Provider.of<EventProvider>(context, listen: false)
        .addListener(_onLocationChanged);
  }

  void _onLocationChanged() {
    final newLocation =
        Provider.of<EventProvider>(context, listen: false).filter.location;
    if (newLocation != _currentSelectedLocation && _isMapReady) {
      setState(() {
        _currentSelectedLocation = newLocation;
      });
      _mapController.move(
          _currentSelectedLocation!, _mapController.camera.zoom);
    }
  }

  List<Marker> _getMarkers(
      List<Event> events, LatLng currentLocation, BuildContext context) {
    List<Marker> eventMarkers = events.map((event) {
      return Marker(
        point: event.location,
        child: GestureDetector(
            onTap: () {
              context.push('/events/${event.id!}');
            },
            child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(event.icon, color: Colors.black),
                  ),
                ))),
      );
    }).toList();
    Marker locationMarker = Marker(
        point: currentLocation,
        child: const Icon(
          Icons.my_location,
          color: Colors.blueAccent,
        ));

    return [...eventMarkers, locationMarker];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            return FlutterMap(
              options: MapOptions(
                  initialCenter: _currentLocation,
                  initialZoom: 13.0,
                  onMapReady: () {
                    setState(() {
                      _isMapReady = true;
                    });
                  }),
              mapController: _mapController,
              children: [
                TileLayer(
                  urlTemplate: isDarkMode
                      ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
                      : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _getMarkers(
                      eventProvider.filteredEvents, _currentLocation, context),
                ),
              ],
            );
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.surface,
            onPressed: () async {
              _mapController.move(_currentLocation, 13.0);
            },
            child: Icon(
              Icons.near_me,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }
}
