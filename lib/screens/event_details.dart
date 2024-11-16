import 'package:eventure/provider/eventure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.title});

  final String title;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Event Details',
            ),
            Consumer<EventureProvider>(
                builder: (context, provider, child) => Text("Hallo, ${provider.username}")
            ),
            Consumer<EventureProvider>(
                builder: (context, provider, child) => Column( children: [
                  Text("Selected event UUID: ${provider.selectedEvent}"),
                  provider.getEventWithUUID(provider.selectedEvent)==null?
                    Text("Event not found, it was probably deleted") :
                    Text("Description: ${provider.getEventWithUUID(provider.selectedEvent)!.description}")
                ])
            ),
            TextButton(
                child:const Text("Zurück"),
                onPressed:(){Navigator.pop(context);}
            )
          ],
        ),
      ),
    );
  }
}
