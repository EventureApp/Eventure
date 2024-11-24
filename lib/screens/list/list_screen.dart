import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../../widgets/event_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
        ),
        body: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            return ListView.builder(
              itemCount: eventProvider.events.length,
              itemBuilder: (context, index) {
                final event = eventProvider.events[index];
                return EventCard(
                  name: event.name,
                  startDate: event.startDate,
                  adress: event.adress,
                  icon: event.icon,
                );
              },
            );
          },
        ));
  }
}
