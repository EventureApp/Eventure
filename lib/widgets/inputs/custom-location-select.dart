import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng) onTap;
  final LatLng? initialLocation;

  const MapWidget({
    super.key,
    required this.onTap,
    this.initialLocation,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? tappedCoordinates; // Die Position, die der Benutzer auswählt
  LatLng? currentLocation; // Der initiale Standort
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Hole die aktuelle Position
    tappedCoordinates = widget.initialLocation; // Setze die initiale Position (wenn vorhanden)
  }

  // Funktion, um den aktuellen Standort zu holen
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Überprüfen, ob Standortdienste aktiviert sind
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Berechtigungen prüfen
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    } else if (permission == LocationPermission.denied || permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    // Hole den aktuellen Standort
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      // Setze den aktuellen Standort als Initialwert, falls noch kein initialLocation übergeben wurde
      if (widget.initialLocation == null) {
        mapController.move(currentLocation!, 13.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: tappedCoordinates ?? widget.initialLocation ?? LatLng(49.4699765, 8.4819024), // Standardwert
        initialZoom: 13.0,
        minZoom: 1.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) {
          widget.onTap(point); // Den getippten Punkt zurückgeben
          setState(() {
            tappedCoordinates = point; // Die angeklickte Position als neue Markerposition setzen
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        // Zeige den benutzerdefinierten Marker (der ausgewählte Punkt)
        if (tappedCoordinates != null)
          MarkerLayer(
            markers: [
              Marker(
                point: tappedCoordinates!,
                width: 50,
                height: 50,
                child: Icon(
                  Icons.location_on, // Benutzerdefiniertes Icon für den Marker
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        // Zeige den aktuellen Standort als Marker (falls der Benutzer diesen noch nicht gesetzt hat)
        if (currentLocation != null && tappedCoordinates == null)
          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
                width: 50,
                height: 50,
                child: Icon(
                  Icons.location_on, // Nutzer-Standort als Marker
                  size: 50,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

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
    _selectedLocation = widget.initValue; // Setze den initWert des Markers
  }

  void _updateLocation(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _submitLocation() {
    widget.onChanged(_selectedLocation);
    Navigator.pop(context);
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
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: MapWidget(
                initialLocation: _selectedLocation, // Initialisiert die Karte mit der aktuellen oder ausgewählten Position
                onTap: _updateLocation,
              ),
            ),
            SizedBox(height: 16),
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

class LocationSelect extends StatefulWidget {
  final String label;
  final LatLng? initValue;
  final Function(LatLng?) onChanged;

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
    _selectedLocation = widget.initValue;
  }

  void _openLocationPopover() {
    showDialog(
      context: context,
      builder: (context) {
        return LocationSelectPopover(
          initValue: _selectedLocation, // Initialisiert die Karte mit der aktuellen oder ausgewählten Position
          onChanged: (newLocation) {
            setState(() {
              _selectedLocation = newLocation;
            });
            widget.onChanged(newLocation); // Ändere die ausgewählte Position
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

void main() {
  runApp(MaterialApp(home: Scaffold(body: LocationSelect(label: 'Wählen Sie einen Standort', onChanged: (location) {}))));
}
