import 'package:eventure/provider/eventure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventure/models/event_model.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.title});

  final String title;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {

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
              'Event Liste',
            ),
            Consumer<EventureProvider>(
              builder: (context, provider, child) => Text("Hallo, ${provider.username}")
            ),
            Expanded(
              child:Consumer<EventureProvider>(
                builder: (context, tasks, child) => ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: tasks.eventsAsList.length,
                    itemBuilder: (BuildContext listViewContext, int index) {
                      List<EventModel> currentEventList = tasks.eventsAsList;
                      return GestureDetector(
                        child: Container(
                          height:40,
                          color:Colors.greenAccent,
                          margin:const EdgeInsets.all(4),
                          child:Text(currentEventList[index].description),
                        ),
                        onTap: (){
                          context.read<EventureProvider>().selectedEvent=currentEventList[index].uuid;
                          Navigator.pushNamed(context,"/event_details");
                        }
                      );
                    }
                )
              ),
            ),
            TextButton(
              child:const Text("Log out"),
              onPressed:(){Navigator.pushReplacementNamed(context,"/login");}
            )
          ],
        ),
      ),
    );
  }
}
