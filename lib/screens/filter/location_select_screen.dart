import 'package:eventure/models/event_filter.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../../widgets/inputs/custom_location_select.dart';
import '../../widgets/inputs/custom_number_select.dart';

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  final _formKey = GlobalKey<FormState>();

  late LatLng _location;
  late double _radius;

  @override
  void initState() {
    super.initState();

    EventFilter eventFilter = context
        .read<EventProvider>()
        .filter;
    _location = eventFilter.location;
    _radius = eventFilter.range;
  }

  void _applyLocation() {
    EventFilter eventFilter = context
        .read<EventProvider>()
        .filter;
    context.read<EventProvider>().setFilter(EventFilter(
      searchInput: eventFilter.searchInput,
      location: _location,
      range: _radius,
      startDate: eventFilter.startDate,
      endDate: eventFilter.endDate,
      eventType: eventFilter.eventType,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location changed")),
    );
    Navigator.pop(context);
  }

  void _resetLocation() {
    LatLng userLocation = context.read<LocationProvider>().currentLocation!;
    context.read<EventProvider>().resetLocation(userLocation);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location reset!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick location"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _resetLocation();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _applyLocation();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32.0),
            color: Theme.of(context).colorScheme.tertiary,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Standort
                  Consumer<LocationProvider>(
                      builder: (context, locationProvider, child) {
                        if (locationProvider.currentLocation == null) {
                          return const Center(
                            child: CircularProgressIndicator(), // Loading state
                          );
                        }

                        return LocationSelect(
                          label: "Location",
                          isEditable: true,
                          initValue: _location,
                          userLocation: locationProvider.currentLocation!,
                          onChanged: (location) {
                            setState(() {
                              _location = location!;
                            });
                          },
                        );
                      }),
                  const SizedBox(height: 32),

                  // Radius
                  CustomNumberInput(
                    label: "Radius (km)",
                    isMandatory: true,
                    initValue:
                    _radius.toString() == 'null' ? '' : _radius.toString(),
                    onChanged: (value) {
                      setState(() {
                        _radius = value!.toDouble();
                      });
                    },
                  ),

                  const SizedBox(height: 225)
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}