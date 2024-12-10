import 'package:eventure/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? tappedCoordinates;

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
                            markers: eventProvider.filteredEvents.map((event) {
                              return Marker(
                                point: event.location,
                                child: GestureDetector(
                                  onTap: () {
                                    context.push('/events/${event.id!}');
                                  },
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        event.icon,
                                      ),
                                    )
                                ),
                              );
                            }).toList(),
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
