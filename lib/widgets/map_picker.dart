import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';

class MapPickerWidget extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapPickerWidget({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _MapPickerWidgetState createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  LatLng? tappedCoordinates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a Location"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: tappedCoordinates == null
                ? null
                : () {
                    widget.onLocationSelected(tappedCoordinates!);
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
                  boxShadow: [
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
      ),
    );
  }
}
