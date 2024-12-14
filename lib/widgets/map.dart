import 'package:eventure/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';

import '../../providers/event_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? tappedCoordinates;

  List<Marker> _getMarkers(List<Event> events, LatLng currentLocation) {
    List<Marker> eventMarkers = events.map((event) {
      return Marker(
        point: event.location,
        child: GestureDetector(
            onTap: () {
              context.push('/events/${event.id!}');
            },
            child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                        event.icon,
                        color: Colors.black
                    ),
                  ),
                ))),
      );
    }).toList();
    Marker locationMarker = Marker(point: currentLocation, child: const Icon(
      Icons.my_location,
      color: Colors.blueAccent,
    ));

    return [...eventMarkers, locationMarker];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<LocationProvider>(context, listen: false)
          .fetchCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return Consumer2<EventProvider, LocationProvider>(
            builder: (context, eventProvider, locationProvider, child) {
              final currentLocation = locationProvider.currentLocation;
              if (currentLocation == null) {
                return const Center(
                  child: Text('Unable to fetch location.'),
                );
              }

              return Stack(
                children: [
                  Consumer<EventProvider>(
                    builder: (context, eventProvider, child) {
                      return FlutterMap(
                        options: MapOptions(
                          initialCenter: currentLocation,
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: _getMarkers(eventProvider.filteredEvents, currentLocation),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
