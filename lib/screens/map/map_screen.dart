import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? tappedCoordinates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Open List',
            onPressed: () {
              // TODO: Navigate to ListScreen
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<EventProvider>(
            builder: (context, markerProvider, child) {
              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(49.4699765, 8.4819024),
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
                  MarkerLayer(markers: markerProvider.markers),
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
                color: Colors.white,
                child: Text(
                  'Tapped Location: \nLat: ${tappedCoordinates!.latitude}, Lng: ${tappedCoordinates!.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMarkerForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMarkerForm(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    // Populate the form with tapped coordinates if any
    final TextEditingController latController = TextEditingController();
    final TextEditingController lngController = TextEditingController();

    if (tappedCoordinates != null) {
      latController.text = tappedCoordinates!.latitude.toString();
      lngController.text = tappedCoordinates!.longitude.toString();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: latController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lngController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        String title = titleController.text;
                        String lat = latController.text;
                        String lng = lngController.text;

                        if (title.isEmpty || lat.isEmpty || lng.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill out all fields!')),
                          );
                          return;
                        }

                        try {
                          // Convert latitude and longitude to LatLng
                          double latitude = double.parse(lat);
                          double longitude = double.parse(lng);

                          // Add the marker to the map
                          context
                              .read<EventProvider>()
                              .addMarker(LatLng(latitude, longitude), title);
                          Navigator.pop(context); // Close the bottom sheet
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Invalid latitude or longitude!')),
                          );
                        }
                      },
                      child: const Text('Add Marker'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
