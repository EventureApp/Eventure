import 'package:eventure/models/event.dart'; // Your Event model
import 'package:eventure/providers/auth_provider.dart';
import 'package:eventure/widgets/map_picker.dart'; // Your custom map picker widget
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../../widgets/icon_picker.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(hours: 1));
  String _address = '';
  LatLng _location = LatLng(0.0, 0.0);
  IconData _icon = Icons.event;
  EventType _eventType = EventType.public;
  String _eventLink = '';
  int _participants = 0;
  String? _organizer = AuthenticationProvider().currentUser?.uid;

  void onLocationSelected(LatLng location) {
    setState(() {
      _location = location;
    });
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        description: _description.isNotEmpty ? _description : null,
        startDate: _startDate,
        endDate: _endDate,
        adress: _address,
        location: _location,
        icon: _icon,
        eventType: _eventType,
        eventLink: _eventLink.isNotEmpty ? _eventLink : null,
        maxParticipants: _participants > 0 ? _participants : null,
        organizer: _organizer,
      );

      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.addEvent(newEvent);

      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveEvent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start Date: ${_startDate.toLocal()}'),
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (newDate != null && newDate != _startDate) {
                        setState(() {
                          _startDate = newDate;
                        });
                      }
                    },
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('End Date: ${_endDate.toLocal()}'),
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (newDate != null && newDate != _endDate) {
                        setState(() {
                          _endDate = newDate;
                        });
                      }
                    },
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
              ),
              IconPicker(
                selectedIcon: _icon,
                onIconSelected: (icon) {
                  setState(() {
                    _icon = icon;
                  });
                },
              ),
              DropdownButton<EventType>(
                value: _eventType,
                onChanged: (EventType? newValue) {
                  setState(() {
                    _eventType = newValue!;
                  });
                },
                items: EventType.values
                    .map<DropdownMenuItem<EventType>>(
                      (EventType value) => DropdownMenuItem<EventType>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      ),
                    )
                    .toList(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Link (optional)'),
                onChanged: (value) {
                  setState(() {
                    _eventLink = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Max. Participants (optional)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _participants = int.tryParse(value) ?? 0;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  height: 300,
                  child: MapPickerWidget(
                      onLocationSelected:
                          onLocationSelected), // Pass onLocationSelected as a callback
                ),
              ),
              if (_location != LatLng(0.0, 0.0))
                Text(
                  'Location: Lat ${_location.latitude}, Lng ${_location.longitude}',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
