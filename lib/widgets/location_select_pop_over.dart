import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'input_map_widget.dart';

class LocationSelectPopover extends StatefulWidget {
  final LatLng? initValue;
  final Function(LatLng?) onChanged;

  const LocationSelectPopover({super.key, required this.onChanged, this.initValue});

  @override
  LocationSelectPopoverState createState() => LocationSelectPopoverState();
}

class LocationSelectPopoverState extends State<LocationSelectPopover> {
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
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: MapWidget(
                onTap: _updateLocation,
              ),
            ),
            if (_selectedLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Selected Location:\nLat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: _submitLocation,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
