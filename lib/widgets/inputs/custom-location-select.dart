import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng) onTap;
  final LatLng initialLocation;
  final bool isEditable;
  final bool isMandatory;

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
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLocation != oldWidget.initialLocation) {
      setState(() {
        _currentLocation = widget.initialLocation;
      });
      _mapController.move(_currentLocation, 13.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
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
          widget.onTap(point);
        }
            : null,
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
                Icons.location_on,
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
  final bool isMandatory;

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
    _selectedLocation = widget.initValue;
  }

  void _updateLocation(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _submitLocation() {
    if (_selectedLocation != null || !widget.isMandatory) {
      widget.onChanged(_selectedLocation);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a location!'),
        backgroundColor: Colors.red,
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
              height: 400, // Karte größer anzeigen
              child: MapWidget(
                initialLocation: _selectedLocation ?? LatLng(0.0, 0.0),
                onTap: _updateLocation,
                isEditable: true,
                isMandatory: true,
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
  final bool isMandatory;
  final bool isEditable;

  LocationSelect({
    required this.label,
    this.initValue,
    required this.onChanged,
    this.isMandatory = false,
    this.isEditable = true,
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

  void _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

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
                _selectedLocation = newLocation;
              });
              widget.onChanged(newLocation);
            },
            isMandatory: widget.isMandatory,
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: widget.isEditable ? _openLocationPopover : null,
              child: Icon(
                Icons.map,
                size: 24,
                color: widget.isEditable ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 300, // Größe der Karte hier angepasst
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isMandatory && _selectedLocation == null
                  ? Colors.red
                  : Colors.black.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : MapWidget(
            initialLocation: _selectedLocation ?? LatLng(0.0, 0.0),
            isEditable: false,
            onTap: (LatLng) {
              _openLocationPopover();
            },
            isMandatory: widget.isMandatory,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
