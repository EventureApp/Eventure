import 'package:eventure/models/event.dart';
import 'package:flutter/material.dart';
import '../../widgets/event_card.dart';
import '../../providers/event_provider.dart';

class ListScreen extends StatelessWidget {
   const ListScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
     EventProvider provider = new EventProvider();
     List<Event> events = provider.events;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            name: event.name,
            startDate: event.startDate,
            adress: event.adress,
            icon: event.icon,
          );
        },
      ),
    );
  }
}
