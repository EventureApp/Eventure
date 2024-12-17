import 'package:eventure/models/event_filter.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:eventure/widgets/inputs/custom-number-select.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../statics/custom_icons.dart';
import '../../statics/event_types.dart';
import '../../statics/event_visibility.dart';
import '../../widgets/inputs/custom-event-type-select.dart';
import '../../widgets/inputs/custom-location-select.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';

class EventFilterScreen extends StatefulWidget {
  @override
  _EventFilterScreenState createState() => _EventFilterScreenState();
}

class _EventFilterScreenState extends State<EventFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime? _startDate;
  late DateTime? _endDate;
  late EventVisability _visibility;
  late List<EventType>? _eventType;
  late LatLng? _location;
  late double? _radius;

  @override
  void initState() {
    super.initState();
    EventFilter eventFilter = context.read<EventProvider>().filter;

    _startDate = eventFilter.startDate;
    _endDate = eventFilter.endDate;
    _visibility = EventVisability.public;
    _eventType = eventFilter.eventType;
    _location = eventFilter.location;
    _radius = eventFilter.range;
  }

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      context.read<LocationProvider>().setLocation(_location);
      context.read<EventProvider>().setFilter(EventFilter(
            range: _radius,
            startDate: _startDate,
            endDate: _endDate,
            location: _location,
            eventType: _eventType,
          ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Filters applied!")),
      );
      Navigator.pop(context);
    }
  }

  void _resetFilters() {
    context.read<EventProvider>().resetFilter();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Filters reset!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _resetFilters();
              }),
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                (_radius == null &&
                        _location == null &&
                        _endDate == null &&
                        _startDate == null &&
                        _eventType == null)
                    ? null
                    : _applyFilters();
              }),
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
                    CustomIcons.filteroptions,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Startdatum
                  CustomDateAndTimePicker(
                    label: "Start Date",
                    required: false,
                    editable: true,
                    initValue: _startDate,
                    onDateChanged: (date) {
                      setState(() {
                        _startDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Enddatum
                  CustomDateAndTimePicker(
                    label: "End Date",
                    required: false,
                    editable: true,
                    initValue: _endDate,
                    onDateChanged: (date) {
                      setState(() {
                        _endDate = date;
                      });
                    },
                  ),
                  // SizedBox(height: 16),
                  //
                  // // // Sichtbarkeit (Dropdown)
                  // // SingleSelectDropdown(
                  // //   label: 'Visibility',
                  // //   initValue: _visibility.toString().split('.').last,
                  // //   data: eventVisibilityData,
                  // //   required: true,
                  // //   editable: true,
                  // //   onChanged: (value) {
                  // //     setState(() {
                  // //       _visibility = eventVisibilityData[value];
                  // //     });
                  // //   },
                  // // ),
                  const SizedBox(height: 16),

                  // Event-Typ (Einzelauswahl)
                  EventSelect(
                    label: 'Event Type',
                    isEditable: true,
                    initValues: _eventType ?? [],
                    events: eventTypesWithIcon,
                    isMultiSelect: true,
                    onChanged: (selected) {
                      setState(() {
                        _eventType = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

                  // Radius
                  CustomNumberInput(
                    label: "Radius (km)",
                    initValue:
                        _radius.toString() == 'null' ? '' : _radius.toString(),
                    onChanged: (value) {
                      setState(() {
                        _radius = value!.toDouble();
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
