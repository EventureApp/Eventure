import 'package:eventure/models/event.dart';
import 'package:eventure/widgets/inputs/custom-number-select.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart'; // Provider importieren

import '../../providers/event_provider.dart'; // Dein EventProvider
import '../../statics/event_types.dart';
import '../../statics/event_visibility.dart';
import '../../widgets/inputs/custom-event-select.dart';
import '../../widgets/inputs/custom-link-select.dart';
import '../../widgets/inputs/custom-location-select.dart';
import '../../widgets/inputs/custom-single-select.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';
import '../../widgets/inputs/custom_discription_input.dart';
import '../../widgets/inputs/custom_input_line.dart';

class EventScreen extends StatefulWidget {
  final Event? event;

  EventScreen({this.event});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
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
      _isEditing = false;
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
      _endDate = DateTime.now().add(Duration(hours: 1));
      _location = LatLng(0.0, 0.0);
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
      // Neues Event-Objekt erstellen
      Event newEvent = Event(
        name: _title,
        startDate: _startDate,
        endDate: _endDate,
        location: _location,
        address: '',
        // Address handling could be added here
        eventType: _eventType,
        icon: _eventIcon,
        visibility: _visibility,
        eventLink: _link,
        maxParticipants: _maxParticipants,
        description: _description,
        organizer: 'Current User', // Replace with actual user
      );

      // Event über den Provider speichern
      Provider.of<EventProvider>(context, listen: false).addEvent(newEvent);

      // Feedback an den Nutzer und zurück navigieren
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event successfully saved!")),
      );
      context.go("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.event == null ? "Create Event" : "Edit Event"),
        actions: [
          IconButton(
            icon: Icon(widget.event == null || _isEditing ? Icons.save : Icons.edit),
            onPressed: _isFormValid
                ? () {
              _saveEvent(context);
            } : _isEditing == false ? () {
              setState(() {
                _isEditing = true;
              });
            }: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _eventIcon,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Container(
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
                  CustomInputLine(
                    label: "Title",
                    required: true,
                    editable: _isEditing,
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),
                  CustomDateAndTimePicker(
                    label: "Start Date",
                    required: true,
                    editable: _isEditing,
                    onDateChanged: (date) {
                      setState(() {
                        _startDate = date;
                      });
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),
                  CustomDateAndTimePicker(
                    label: "End Date",
                    required: true,
                    editable: _isEditing,
                    onDateChanged: (date) {
                      setState(() {
                        _endDate = date;
                      });
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),
                  LocationSelect(
                    label: "Location",
                    isEditable: _isEditing,
                    onChanged: (location) {
                      setState(() {
                        _location = location!;
                      });
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  CustomLinkInput(
                    label: "Link",
                    onChanged: (value) {
                      setState(() {
                        _link = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  CustomNumberInput(
                    label: "Max Participants",
                    onChanged: (value) {
                      setState(() {
                        _maxParticipants = value;
                      });
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),
                  CustomDescriptionInput(
                    label: "Description",
                    required: true,
                    editable: _isEditing,
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),
                  SingleSelectDropdown(
                    label: 'Visibility',
                    initValue: _visibility.toString().split('.').last,
                    data: eventVisibilityData,
                    required: true,
                    editable: _isEditing,
                    onChanged: (value) {
                      setState(() {
                        _visibility = eventVisibilityData[value];
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
