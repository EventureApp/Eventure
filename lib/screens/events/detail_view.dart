import 'package:eventure/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';

class EventDetailViewScreen extends StatelessWidget {
  final Event event;

  const EventDetailViewScreen({super.key, required this.event});

  static Widget create(BuildContext context, String id) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final event = eventProvider.events.firstWhere((event) => event.id == id);
    return EventDetailViewScreen(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
        child: Center(
          child: Column(children: [
            Title(color: Colors.red, child: Text(event.name)),
            Row(
              children: [
                const Icon(Icons.timelapse),
                Text(event.startDate.toString()),
                Text(event.endDate.toString())
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_pin),
                Text(event.location.toString())
              ],
            ),
            Row(
              children: [
                const Icon(Icons.person),
                Text(event.organizer ?? 'none')
              ],
            ),
            Row(
              children: [
                const Icon(Icons.supervised_user_circle),
                Text(event.eventType.name)
              ],
            ),
            event.eventLink != null
                ? Row(
                    children: [const Icon(Icons.link), Text(event.eventLink!)],
                  )
                : const SizedBox.shrink(),
            event.description != null
                ? Column(
                    children: [
                      const Text(
                        'Beschreibung',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          event.description!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                : const SizedBox.shrink()
          ]),
        ),
      ),
    );
  }
}
