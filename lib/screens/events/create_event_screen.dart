import 'package:eventure/models/event.dart';
import 'package:eventure/providers/location_provider.dart';
import 'package:eventure/widgets/inputs/custom_number_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../../statics/event_types.dart';
import '../../statics/event_visibility.dart';
import '../../widgets/inputs/custom_event_type_select.dart';
import '../../widgets/inputs/custom_link_select.dart';
import '../../widgets/inputs/custom_location_select.dart';
import '../../widgets/inputs/custom_single_select.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';
import '../../widgets/inputs/custom_discription_input.dart';
import '../../widgets/inputs/custom_input_line.dart';

class EventScreen extends StatefulWidget {
  final Event? event;

  const EventScreen({super.key, this.event});

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {
  bool _isEditing = true;
  final _formKey = GlobalKey<FormState>();

  // Felder für die Form-Daten
  late String _title;
  late DateTime _startDate;
  late DateTime _endDate;
  late LatLng _location;
  late EventType _eventType;
  late IconData _eventIcon;
  late EventVisability _visibility;
  late String? _link;
  late int? _maxParticipants;
  late String? _description;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      // Felder vorbefüllen, falls Bearbeitung
      _isEditing = true;
      _title = widget.event!.name;
      _startDate = widget.event!.startDate;
      _endDate = widget.event!.endDate;
      _location = widget.event!.location;
      _eventType = widget.event!.eventType;
      _eventIcon = widget.event!.icon;
      _visibility = widget.event!.visibility;
      _link = widget.event!.eventLink;
      _maxParticipants = widget.event!.maxParticipants;
      _description = widget.event!.description;
    } else {
      // Felder initialisieren für neues Event
      _title = '';
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(hours: 1));
      _location = const LatLng(0.0, 0.0);
      _eventType = EventType.other;
      _eventIcon = Icons.event;
      _visibility = EventVisability.public;
      _link = null;
      _maxParticipants = null;
      _description = null;
    }
    _validateForm();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _title.isNotEmpty &&
          _description != null &&
          _description!.isNotEmpty &&
          _startDate.isBefore(_endDate) &&
          (_maxParticipants != null && _maxParticipants! > 0);
    });
  }

  void _saveEvent(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Neues oder bestehendes Event-Objekt erstellen
      Event newEvent = Event(
        id: widget.event?.id ?? UniqueKey().toString(),
        name: _title,
        startDate: _startDate,
        endDate: _endDate,
        location: _location,
        address: '',
        eventType: _eventType,
        icon: _eventIcon,
        visibility: _visibility,
        eventLink: _link,
        maxParticipants: _maxParticipants,
        description: _description,
        organizer: widget.event?.organizer ?? FirebaseAuth.instance.currentUser!.uid,
      );

      // Event über den Provider speichern oder aktualisieren
      if (widget.event == null) {
        Provider.of<EventProvider>(context, listen: false).addEvent(newEvent);
      } else {
        Provider.of<EventProvider>(context, listen: false).updateEvent(newEvent);
      }

      // Feedback an den Nutzer und zurück navigieren
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event successfully saved!")),
      );
      context.go("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.event == null ? "Create Event" : "Edit Event"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                if (_isFormValid) {
                  _saveEvent(context);
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.tertiary,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Icon(
                        _eventIcon,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputLine(
                        label: "Title",
                        required: true,
                        editable: _isEditing,
                        initValue: _title, // Set initial value
                        onChanged: (value) {
                          setState(() => _title = value);
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDateAndTimePicker(
                        label: "Start Date",
                        required: true,
                        editable: _isEditing,
                        initValue: _startDate,
                        onDateChanged: (date) {
                          setState(() => _startDate = date);
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDateAndTimePicker(
                        label: "End Date",
                        required: true,
                        editable: _isEditing,
                        initValue: _endDate,
                        onDateChanged: (date) {
                          setState(() => _endDate = date);
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      Consumer<LocationProvider>(
                        builder: (context, locationProvider, child) {
                          if (locationProvider.currentLocation == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return LocationSelect(
                            label: "Location",
                            isEditable: true,
                            userLocation: locationProvider.currentLocation!,
                            initValue: _location,
                            onChanged: (location) {
                              setState(() {
                                _location = location!;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      EventSelect(
                        label: 'Event Type',
                        isEditable: _isEditing,
                        initValues: [_eventType],
                        events: eventTypesWithIcon,
                        isMultiSelect: false,
                        onChanged: (selected) {
                          setState(() {
                            _eventType = selected[0];
                            _eventIcon = eventTypesWithIcon[selected[0]]!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomLinkInput(
                        label: "Link",
                        onChanged: (value) {
                          setState(() => _link = value ?? '');
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomNumberInput(
                        label: "Max Participants",
                        isMandatory: true,
                        onChanged: (value) {
                          setState(() => _maxParticipants = value);
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDescriptionInput(
                        label: "Description",
                        required: true,
                        editable: _isEditing,
                        initValue: _description,
                        onChanged: (value) {
                          setState(() => _description = value);
                          _validateForm();
                        },
                      ),
                      const SizedBox(height: 16),
                      SingleSelectDropdown(
                        label: 'Visibility',
                        initValue: _visibility.toString().split('.').last,
                        data: eventVisibilityData,
                        required: true,
                        editable: _isEditing,
                        onChanged: (value) {
                          setState(() => _visibility = eventVisibilityData[value]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}