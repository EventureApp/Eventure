import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng) onTap;
  final LatLng initialLocation;
  final bool isEditable;
  final bool isMandatory;
  final LatLng? userLocation;

  const MapWidget({
    Key? key,
    required this.onTap,
    required this.initialLocation,
    required this.isEditable,
    required this.isMandatory,
    this.userLocation,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _currentSelectedLocation;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _currentSelectedLocation = widget.initialLocation;
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLocation != oldWidget.initialLocation) {
      setState(() {
        _currentSelectedLocation = widget.initialLocation;
      });
      _mapController.move(_currentSelectedLocation, 13.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(children: [
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentSelectedLocation,
          initialZoom: 13.0,
          minZoom: 13.0,
          maxZoom: 100.0,
          onTap: widget.isEditable
              ? (tapPosition, point) {
                  widget.onTap(point);
                }
              : null,
        ),
        children: [
          TileLayer(
            urlTemplate: isDarkMode
                ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
                : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // Falls userLocation vorhanden ist, zeige blauen Marker für den Nutzerstandort
              if (widget.userLocation != null)
                Marker(
                  point: widget.userLocation!,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blueAccent,
                  ),
                ),
              // Ausgewählte Location (rot), nur anzeigen falls sie != userLocation ist
              if (widget.userLocation == null ||
                  _currentSelectedLocation != widget.userLocation)
                Marker(
                  point: _currentSelectedLocation,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
        ],
      ),
      widget.isEditable
          ? Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFEDEAF4),
                onPressed: () async {
                  _mapController.move(_currentSelectedLocation, 13.0);
                },
                child: const Icon(
                  Icons.near_me,
                  color: Color(0xFF7763AE),
                ),
              ),
            )
          : const SizedBox.shrink()
    ]);
  }
}

class LocationSelectBottomSheet extends StatefulWidget {
  final LatLng? initValue;
  final Function(LatLng?) onChanged;
  final bool isMandatory;
  final LatLng? userLocation;

  const LocationSelectBottomSheet({
    Key? key,
    required this.onChanged,
    this.initValue,
    this.isMandatory = false,
    this.userLocation,
  }) : super(key: key);

  @override
  _LocationSelectBottomSheetState createState() =>
      _LocationSelectBottomSheetState();
}

class _LocationSelectBottomSheetState extends State<LocationSelectBottomSheet> {
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
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF1976D2);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle + Close Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Standort auswählen",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close, size: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Tippe auf die Karte, um einen Standort festzulegen.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapWidget(
                  initialLocation: _selectedLocation ?? const LatLng(0.0, 0.0),
                  onTap: _updateLocation,
                  isEditable: true,
                  isMandatory: widget.isMandatory,
                  userLocation: widget.userLocation,
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
            Divider(
              color: theme.dividerColor.withOpacity(0.3),
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              child: const Text(
                'Fertig',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
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
  LatLng? _userLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initValue;
    if (_selectedLocation == null) {
      _getCurrentLocation();
    } else {
      _userLocation = _selectedLocation;
    }
  }

  Future<void> _getCurrentLocation() async {
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
      _userLocation = _selectedLocation;
      _isLoading = false;
    });
  }

  void _openLocationBottomSheet() {
    if (widget.isEditable) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LocationSelectBottomSheet(
            initValue: _selectedLocation,
            onChanged: (newLocation) {
              setState(() {
                _selectedLocation = newLocation;
              });
              widget.onChanged(newLocation);
            },
            isMandatory: widget.isMandatory,
            userLocation: _userLocation,
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
                              _selectedLocation ?? const LatLng(0.0, 0.0),
                          isEditable: false,
                          onTap: (_) {
                            _openLocationBottomSheet();
                          },
                          isMandatory: widget.isMandatory,
                          userLocation: _userLocation,
                        ),
                      ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openLocationBottomSheet,
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
