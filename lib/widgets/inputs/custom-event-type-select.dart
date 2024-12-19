import 'package:flutter/material.dart';
import 'package:eventure/statics/event_types.dart';

class EventSelect extends StatefulWidget {
  final String label;
  final List<EventType> initValues;
  final Map<EventType, IconData> events;
  final Function(List<EventType>) onChanged;
  final bool isMultiSelect;
  final bool isMandatory;
  final bool isEditable;

  const EventSelect({
    Key? key,
    required this.label,
    required this.initValues,
    required this.events,
    required this.onChanged,
    this.isMultiSelect = true,
    this.isMandatory = false,
    this.isEditable = true,
  }) : super(key: key);

  @override
  _EventSelectState createState() => _EventSelectState();
}

class _EventSelectState extends State<EventSelect> {
  late List<EventType> _selectedEvents;
  bool _hasAttemptedSubmit = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _selectedEvents = List.from(widget.initValues);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasError {
    return widget.isMandatory && _selectedEvents.isEmpty && _hasAttemptedSubmit;
  }

  void _toggleEventSelection(EventType event) {
    if (!widget.isEditable) return;

    setState(() {
      if (widget.isMultiSelect) {
        if (_selectedEvents.contains(event)) {
          _selectedEvents.remove(event);
        } else {
          _selectedEvents.add(event);
        }
      } else {
        _selectedEvents = [event];
      }
    });
    widget.onChanged(_selectedEvents);
  }

  void _openEventPopover() async {
    if (!widget.isEditable) return;

    List<EventType> tempSelection = List.from(_selectedEvents);
    String searchQuery = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final isMandatory = widget.isMandatory;

        return StatefulBuilder(builder: (context, setStateDialog) {
          bool dialogHasError =
              isMandatory && tempSelection.isEmpty && _hasAttemptedSubmit;

          void applySearch(String query) {
            setStateDialog(() {
              searchQuery = query;
            });
          }

          // Compute filtered events based on the current searchQuery
          List<EventType> filteredEvents = widget.events.keys
              .where((e) => e
                  .toString()
                  .split('.')
                  .last
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isMultiSelect ? 'Select Events' : 'Select Event',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap on an event to ${widget.isMultiSelect ? "toggle selection" : "select it"}.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    onChanged: applySearch,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search events...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Event Grid
                  Container(
                    height: 300, // Adjust as needed
                    child: filteredEvents.isEmpty
                        ? Center(
                            child: Text(
                              'No events found.',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                          )
                        : GridView.builder(
                            itemCount: filteredEvents.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, index) {
                              final eventKey = filteredEvents[index];
                              final eventIcon = widget.events[eventKey]!;
                              final isSelected =
                                  tempSelection.contains(eventKey);

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: widget.isEditable
                                    ? () {
                                        setStateDialog(() {
                                          if (widget.isMultiSelect) {
                                            if (tempSelection
                                                .contains(eventKey)) {
                                              tempSelection.remove(eventKey);
                                            } else {
                                              tempSelection.add(eventKey);
                                            }
                                          } else {
                                            tempSelection = [eventKey];
                                          }
                                        });
                                      }
                                    : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.15)
                                        : Theme.of(context).colorScheme.surface,
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.black.withOpacity(0.1),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(eventIcon,
                                          size: 40,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      const SizedBox(height: 8),
                                      Text(
                                        eventKey.toString().split('.').last,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isMandatory && tempSelection.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _hasAttemptedSubmit = true;
                            });
                            if (!(widget.isMandatory &&
                                tempSelection.isEmpty)) {
                              _selectedEvents = tempSelection;
                              widget.onChanged(_selectedEvents);
                              Navigator.of(context).pop();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      backgroundColor: (isMandatory && tempSelection.isEmpty)
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: (isMandatory && tempSelection.isEmpty)
                            ? Colors.white70
                            : Colors.white,
                      ),
                    ),
                  ),
                  if (dialogHasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'At least one event must be selected.',
                        style: TextStyle(color: Colors.red[700], fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final isError = _hasError;
    final borderColor = isError ? Colors.red : Colors.black.withOpacity(0.2);

    return GestureDetector(
      onTap: widget.isEditable ? _openEventPopover : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            // Expanded Wrap to hold chips and placeholder
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  // Display selected event chips
                  ..._selectedEvents.map((event) {
                    final icon = widget.events[event];
                    return Chip(
                      avatar: Icon(
                        icon,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      label: Text(
                        event.toString().split('.').last,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500),
                      ),
                      deleteIcon: widget.isEditable
                          ? Icon(
                              Icons.close,
                              size: 18,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                      onDeleted: widget.isEditable
                          ? () {
                              _toggleEventSelection(event);
                            }
                          : null,
                    );
                  }).toList(),

                  // Placeholder or prompt
                  if (_selectedEvents.isEmpty)
                    Text(
                      widget.isMandatory ? 'Mandatory' : 'Select event(s)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            // Dropdown Icon
            if (widget.isEditable)
              Icon(
                Icons.arrow_drop_down,
                color: isFocused
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
