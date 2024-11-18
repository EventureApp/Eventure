import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/marker_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          Consumer<MarkerProvider>(
            builder: (context, markerProvider, child) {
              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(49.4699765, 8.4819024),
                  initialZoom: 13.0,
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
          const Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              "© OpenStreetMap contributors",
              style: TextStyle(color: Colors.black54, fontSize: 12),
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
    final TextEditingController latController = TextEditingController();
    final TextEditingController lngController = TextEditingController();
    final TextEditingController titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: lngController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final double? lat = double.tryParse(latController.text);
                  final double? lng = double.tryParse(lngController.text);
                  final String title = titleController.text;

                  if (lat != null && lng != null && title.isNotEmpty) {
                    context
                        .read<MarkerProvider>()
                        .addMarker(LatLng(lat, lng), title);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill out all fields!')),
                    );
                  }
                },
                child: const Text('Add Marker'),
              ),
            ],
          ),
        );
      },
    );
  }
}
