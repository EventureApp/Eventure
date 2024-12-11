import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/screens/events/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/event_provider.dart';
import '../../widgets/event_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          return ListView.builder(
            itemCount: eventProvider.filteredEvents.length,
            itemBuilder: (context, index) {
              final event = eventProvider.filteredEvents[index];
              return EventCard(
                name: event.name,
                startDate: event.startDate,
                address: event.address,
                icon: event.icon,
                organizer: Provider.of<UserProvider>(context)
                    .getUserName(event.organizer ?? ""),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailViewScreen(event: event),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
