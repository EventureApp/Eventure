import 'package:eventure/models/event_filter.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../statics/event_types.dart';
import '../../statics/event_visibility.dart';
import '../../widgets/inputs/custom-event-select.dart';
import '../../widgets/inputs/custom-location-select.dart';
import '../../widgets/inputs/custom-number-select.dart';
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
  late List<EventType> _eventType;
  late LatLng _location;
  late double _radius;

  @override
  void initState() {
    super.initState();

    _startDate = null;
    _endDate = null;
    _visibility = EventVisability.public;
    _eventType = [EventType.someThingElse];
    _location = context.read<EventProvider>().filter.location;
    _radius = context.read<EventProvider>().filter.range;
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
        SnackBar(content: Text("Filters applied!")),
      );
      Navigator.pop(context);
    }
  }

  void _resetFilters() {
    context.read<EventProvider>().resetFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Icon(Icons.filter_list, color: Colors.white),
            SizedBox(width: 8),
            Text("Filter Events"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
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
                    initValue: context
                        .read<EventProvider>()
                        .filter
                        .startDate
                        ?.toString(),
                    onDateChanged: (date) {
                      setState(() {
                        _startDate = date;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Enddatum
                  CustomDateAndTimePicker(
                    label: "End Date",
                    required: false,
                    editable: true,
                    initValue: context
                        .read<EventProvider>()
                        .filter
                        .endDate
                        ?.toString(),
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
                  SizedBox(height: 16),

                  // Event-Typ (Einzelauswahl)
                  EventSelect(
                    label: 'Event Type',
                    isEditable: true,
                    initValues:
                        context.read<EventProvider>().filter.eventType ??
                            _eventType,
                    events: EventTypesWithIcon,
                    isMultiSelect: true,
                    onChanged: (selected) {
                      setState(() {
                        _eventType = selected;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Standort
                  LocationSelect(
                    label: "Location",
                    isEditable: true,
                    onChanged: (location) {
                      setState(() {
                        _location = location!;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Radius
                  CustomNumberInput(
                    label: "Radius (km)",
                    hint: context.read<EventProvider>().filter.range.toString(),
                    onChanged: (value) {
                      setState(() {
                        _radius = value!.toDouble();
                      });
                    },
                  ),
                  SizedBox(height: 32),

                  // Filter-Button
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text("Filter"),
                  ),
                  ElevatedButton(
                    onPressed: _resetFilters,
                    child: Text("Reset"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}