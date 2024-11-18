import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../providers/marker_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

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
          Consumer<MarkerProvider>(
            builder: (context, markerProvider, child) {
              return FlutterMap(
                options: MapOptions(
                  center: LatLng(49.4699765, 8.4819024),
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController postalCodeController = TextEditingController();
    final TextEditingController titleController = TextEditingController();

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
                      controller: streetController,
                      decoration: const InputDecoration(labelText: 'Street'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: postalCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Postal Code'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String street = streetController.text;
                        String city = cityController.text;
                        String postalCode = postalCodeController.text;
                        String title = titleController.text;

                        if (street.isEmpty || city.isEmpty || postalCode.isEmpty || title.isEmpty) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill out all fields!')),
                            );
                          }
                          return;
                        }

                        try {
                          // Combine the address parts into a single string
                          String fullAddress = '$street, $postalCode $city';

                          // Geocode the address
                          final locations = await locationFromAddress(fullAddress);
                          if (locations.isNotEmpty) {
                            final lat = locations.first.latitude;
                            final lng = locations.first.longitude;

                            if (context.mounted) {
                              context.read<MarkerProvider>().addMarker(LatLng(lat, lng), title);
                              Navigator.pop(context); // Close the bottom sheet
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not find the location for the given address!')),
                            );
                          }
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
