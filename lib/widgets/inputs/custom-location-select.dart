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
              child: const Icon(
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

  const LocationSelectPopover({
    Key? key,
    required this.onChanged,
    this.initValue,
    this.isMandatory = false,
  }) : super(key: key);

  @override
  _LocationSelectPopoverState createState() => _LocationSelectPopoverState();
}

class _LocationSelectPopoverState extends State<LocationSelectPopover> {
  LatLng? _selectedLocation;
  bool _hasAttemptedSubmit = false;

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
    setState(() {
      _hasAttemptedSubmit = true;
    });
    if (_selectedLocation != null || !widget.isMandatory) {
      widget.onChanged(_selectedLocation);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isError =
        widget.isMandatory && _selectedLocation == null && _hasAttemptedSubmit;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Wähle einen Standort',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tippe auf die Karte, um einen Standort festzulegen.',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isError ? Colors.red : Colors.grey.withOpacity(0.3),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapWidget(
                  initialLocation: _selectedLocation ?? LatLng(0.0, 0.0),
                  onTap: _updateLocation,
                  isEditable: true,
                  isMandatory: widget.isMandatory,
                ),
              ),
            ),
            if (isError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Bitte wähle einen Standort aus.',
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitLocation,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              child: const Text('Fertig',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  const LocationSelect({
    Key? key,
    required this.label,
    this.initValue,
    required this.onChanged,
    this.isMandatory = false,
    this.isEditable = true,
  }) : super(key: key);

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

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (permission == LocationPermission.denied ||
        permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
    bool showError = widget.isMandatory && _selectedLocation == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: widget.label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            children: widget.isMandatory
                ? [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Colors.red[700],
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        // Use a Stack so we can overlay a transparent InkWell on top of the map
        SizedBox(
          width: double.infinity,
          height: 300,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        showError ? Colors.red : Colors.black.withOpacity(0.2),
                    width: 1.5,
                  ),
                  color: Colors.grey[100],
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: MapWidget(
                          initialLocation:
                              _selectedLocation ?? LatLng(0.0, 0.0),
                          isEditable: false,
                          onTap: (LatLng) {
                            _openLocationPopover();
                          },
                          isMandatory: widget.isMandatory,
                        ),
                      ),
              ),
              // Transparent overlay that catches taps and opens the popover
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openLocationPopover,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Ein Standort ist erforderlich.',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
