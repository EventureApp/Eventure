import 'package:eventure/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// Dein MapWidget
class MapWidget extends StatefulWidget {
  final Function(LatLng) onTap;
  final LatLng? initialLocation;

  const MapWidget({super.key, required this.onTap, this.initialLocation});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? tappedCoordinates;
  LatLng? currentLocation;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Funktion, um den aktuellen Standort zu holen
  void _getCurrentLocation() async {
    setState(() {
      currentLocation =
          Provider.of<LocationProvider>(context, listen: false).currentLocation;
      mapController.move(currentLocation!,
          13.0); // Karte auf den aktuellen Standort zentrieren
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter:
                  widget.initialLocation ?? LatLng(49.4699765, 8.4819024),
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  tappedCoordinates = point;
                });
                widget.onTap(
                    point); // Callback zur Übertragung der ausgewählten Position
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              if (tappedCoordinates != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: tappedCoordinates!,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              // Zeigt den aktuellen Standort als Marker an, wenn vorhanden
              if (currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.my_location,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Popover für die Auswahl der Location
class LocationSelectPopover extends StatefulWidget {
  final LatLng? initValue;
  final Function(LatLng?) onChanged;

  LocationSelectPopover({required this.onChanged, this.initValue});

  @override
  _LocationSelectPopoverState createState() => _LocationSelectPopoverState();
}

class _LocationSelectPopoverState extends State<LocationSelectPopover> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initValue;
  }

  void _updateLocation(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _submitLocation() {
    widget.onChanged(_selectedLocation);
    Navigator.pop(context); // PopOver schließen
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Schließen-Button oben links
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // PopOver schließen
                },
              ),
            ),
            // MapWidget im PopOver mit Zoom und Navigation
            SizedBox(
              width: double.infinity,
              height: 300,
              child: MapWidget(
                initialLocation: _selectedLocation,
                onTap:
                    _updateLocation, // Methode zum Aktualisieren der Position
              ),
            ),
            SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: _submitLocation,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Haupt LocationSelect Widget
class LocationSelect extends StatefulWidget {
  final String label;
  final LatLng? initValue; // Initial ausgewählte Location
  final Function(LatLng?) onChanged; // Callback für Änderungen

  LocationSelect({
    required this.label,
    this.initValue,
    required this.onChanged,
  });

  @override
  _LocationSelectState createState() => _LocationSelectState();
}

class _LocationSelectState extends State<LocationSelect> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation =
        widget.initValue; // Initialisiere mit der übergebenen Location
  }

  // Methode zum Öffnen des Popovers
  void _openLocationPopover() {
    showDialog(
      context: context,
      builder: (context) {
        return LocationSelectPopover(
          initValue: _selectedLocation,
          onChanged: (newLocation) {
            setState(() {
              _selectedLocation = newLocation;
            });
            widget.onChanged(newLocation);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _openLocationPopover,
          child: Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[300],
            child: _selectedLocation != null
                ? Center(
                    child: Text(
                      'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Center(child: Text('Tap to select location')),
          ),
        ),
        SizedBox(height: 16),
        if (_selectedLocation != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Chip(
                label: Text(
                  'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                ),
                backgroundColor: Colors.blue.withOpacity(0.2),
              ),
            ],
          )
        else
          Text(
            'No Location Selected',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
      ],
    );
  }
}
