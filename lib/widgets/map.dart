import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? tappedCoordinates;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            return FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(49.4699765, 8.4819024),
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    tappedCoordinates = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                    markers: eventProvider.events.map((event) {
                  return Marker(
                    point: event.location,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/events/${event.id!}');
                      },
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                      ),
                    ),
                  );
                }).toList()),
              ],
            );
          },
        ),
        if (tappedCoordinates != null)
          Positioned(
            bottom: 100,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Tapped Location: \nLat: ${tappedCoordinates!.latitude}, Lng: ${tappedCoordinates!.longitude}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
