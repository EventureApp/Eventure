import 'package:eventure/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../models/event.dart';

class MapWidget extends StatelessWidget {
  final MapController _mapController = MapController();

  MapWidget({super.key});

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
                        mapController: _mapController,
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: _getMarkers(eventProvider.filteredEvents,
                                currentLocation, context),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFFEDEAF4),
                      onPressed: () async {
                        await locationProvider.fetchCurrentLocation();
                        LatLng currentLocation =
                            locationProvider.currentLocation!;
                        _mapController.move(currentLocation, 13.0);
                      },
                      child: const Icon(Icons.my_location, color: Color(
                          0xFF7763AE),),
                    ),
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}
