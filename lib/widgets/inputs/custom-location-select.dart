import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng) onTap;
  final LatLng initialLocation;
  final bool isEditable; // Flag, um zu entscheiden, ob die Karte bearbeitbar ist
  final bool isMandatory; // Flag, ob der Standort verpflichtend ist

  const MapWidget({
    super.key,
    required this.onTap,
    required this.initialLocation,
    required this.isEditable,
    required this.isMandatory,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _currentLocation;
  late MapController _mapController; // MapController für die Steuerung der Karte

  @override
  void initState() {
    super.initState();
    // Sicherstellen, dass der initiale Standort immer einen gültigen Wert hat
    _currentLocation = widget.initialLocation;
    _mapController = MapController(); // Initialisiere den MapController
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Wenn sich der initiale Standort ändert, aktualisieren wir den Standort der Karte.
    if (widget.initialLocation != oldWidget.initialLocation) {
      setState(() {
        _currentLocation = widget.initialLocation;
      });
      // Bewege die Karte zum neuen Standort
      _mapController.move(_currentLocation, 13.0); // Verschiebe die Karte und setze den Zoom-Level
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController, // MapController zur Steuerung der Karte
      options: MapOptions(
        initialCenter: _currentLocation,
        initialZoom: 13.0,
        minZoom: 13.0,
        maxZoom: 100.0,
        interactionOptions: widget.isEditable
            ? InteractionOptions(flags: InteractiveFlag.all)
            : InteractionOptions(flags: InteractiveFlag.none),
        onTap: widget.isEditable
            ? (tapPosition, point) {
          widget.onTap(point); // Den getippten Punkt zurückgeben
        }
            : null, // Wenn nicht editierbar, keine Interaktion
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentLocation,
              width: 50,
              height: 50,
              child: Icon(
                Icons.location_on, // Marker Icon
                size: 50,
                color: Colors.blue, // Wenn editierbar, rot, sonst blau
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
  final bool isMandatory; // Flag, ob der Standort verpflichtend ist

  LocationSelectPopover({
    required this.onChanged,
    this.initValue,
    this.isMandatory = false,
  });

  @override
  _LocationSelectPopoverState createState() => _LocationSelectPopoverState();
}

class _LocationSelectPopoverState extends State<LocationSelectPopover> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initValue; // Default fallback value
  }

  void _updateLocation(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _submitLocation() {
    if (_selectedLocation != null || !widget.isMandatory) {
      widget.onChanged(_selectedLocation); // Callback für den ausgewählten Standort
      Navigator.pop(context); // Schließt das Dialogfenster
    } else {
      // Wenn der Standort erforderlich ist und nicht gesetzt wurde, eine Warnung anzeigen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a location!'),
        backgroundColor: Colors.blue,
      ));
    }
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
                initialLocation: _selectedLocation ?? LatLng(0.0, 0.0),
                onTap: _updateLocation,
                isEditable: true, // Karte editierbar
                isMandatory: true, // Pflichtfeld Flag
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
  final bool isMandatory; // Flag, ob der Standort verpflichtend ist
  final bool isEditable; // Flag, ob die Karte bearbeitbar ist

  LocationSelect({
    required this.label,
    this.initValue,
    required this.onChanged,
    this.isMandatory = false,
    this.isEditable = true, // Standardmäßig auf `true` gesetzt
  });

  @override
  _LocationSelectState createState() => _LocationSelectState();
}

class _LocationSelectState extends State<LocationSelect> {
  LatLng? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initValue;
    if (_selectedLocation == null) {
      _getCurrentLocation();
    }
  }

  // Funktion, um den aktuellen Standort zu holen
  void _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Überprüfen, ob Standortdienste aktiviert sind
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Berechtigungen prüfen
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (permission == LocationPermission.denied || permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // Hole den aktuellen Standort
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  void _openLocationPopover() {
    if (widget.isEditable) {
      showDialog(
        context: context,
        builder: (context) {
          return LocationSelectPopover(
            initValue: _selectedLocation,
            onChanged: (newLocation) {
              setState(() {
                _selectedLocation = newLocation; // Aktualisieren der ausgewählten Position
              });
              widget.onChanged(newLocation); // Callback an den übergeordneten Widget
            },
            isMandatory: widget.isMandatory, // Standort verpflichtend?
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: widget.isEditable ? _openLocationPopover : null, // Nur klickbar wenn `isEditable` true
              child: Icon(
                Icons.map,
                size: 24,
                color: widget.isEditable ? Colors.blue : Colors.grey, // Ausgegraut wenn nicht bearbeitbar
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.grey[200], // Hellerer Hintergrund für das Map-Widget
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : MapWidget(
            initialLocation: _selectedLocation ?? LatLng(0.0, 0.0),
            isEditable: false, // Karte bearbeitbar je nach Flag
            onTap: (LatLng) {
              _openLocationPopover(); // Öffnet den Popover zur Auswahl der Location
            },
            isMandatory: true, // Pflichtfeld Flag
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
