import 'package:eventure/models/event_filter.dart';
import 'package:eventure/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../statics/custom_icons.dart';
import '../../statics/event_types.dart';
import '../../widgets/inputs/custom_event_type_select.dart';
import '../../widgets/inputs/custom_date_time_picker.dart';

class EventFilterScreen extends StatefulWidget {
  const EventFilterScreen({super.key});

  @override
  EventFilterScreenState createState() => EventFilterScreenState();
}

class EventFilterScreenState extends State<EventFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime? _startDate;
  late DateTime? _endDate;
  late List<EventType>? _eventType;

  @override
  void initState() {
    super.initState();
    EventFilter eventFilter = context.read<EventProvider>().filter;

    _startDate = eventFilter.startDate;
    _endDate = eventFilter.endDate;
    _eventType = eventFilter.eventType;
  }

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      EventFilter eventFilter = context.read<EventProvider>().filter;
      context.read<EventProvider>().setFilter(EventFilter(
            range: eventFilter.range,
            startDate: _startDate,
            endDate: _endDate,
            location: eventFilter.location,
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
                (_endDate == null && _startDate == null && _eventType == null)
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
                    CustomIcons.filterOptions,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.tertiary,
            padding: const EdgeInsets.all(32.0),
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
                  const SizedBox(height: 32),

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
                  const SizedBox(height: 32),

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

                  const SizedBox(height: 420)
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
