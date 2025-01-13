import 'package:eventure/models/event.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/utils/string_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailViewScreen extends StatelessWidget {
  final Event event;

  const EventDetailViewScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context)
            .colorScheme
            .tertiary,

        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            FirebaseAuth.instance.currentUser?.uid == event.organizer
                ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/editEvent/${event.id}');
              },
            )
                : const SizedBox.shrink(),
            IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  context.push("/chat/${event.id}");
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      event.icon,
                      size: 70,
                    ),
                  )),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0), // Add horizontal padding
                      child: Text(
                        event.name,
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timelapse,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(parseDateForEvents(event.startDate)),
                          const SizedBox(width: 10),
                          const Text('bis'),
                          const SizedBox(width: 10),
                          Text(parseDateForEvents(event.endDate))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_pin,
                              size: 40,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 10),
                          TextButton.icon(
                            label: const Text('Navigation'),
                            icon: Icon(
                              Icons.navigation,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary, // Set the icon color here
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surface, // Button background color
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary, // Text color
                            ),
                            onPressed: () async {
                              Uri googleMapsUri = Uri.https('maps.google.com', '', {'q': '${event.location.latitude},${event.location.longitude}'});
                              if (!await launchUrl(googleMapsUri)) {
                                throw Exception('Could not launch $googleMapsUri');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                           Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.secondary, // Optional: passe die Farbe des Icons an
                          ),
                          const SizedBox(width: 10),
                          TextButton.icon(
                            label: Text(
                              Provider.of<UserProvider>(context).getUserName(event.organizer ?? ""),
                            ),
                            icon: Icon(
                              Icons.person_outline, // Optional: passe das Symbol an
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
                              context.push('/userProfile/${event.organizer}');
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.supervised_user_circle, size: 40),
                          const SizedBox(width: 10),
                          Text(capitalizeString(event.visibility.name)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          Icon(event.icon, size: 40),
                          const SizedBox(width: 10),
                          Text(capitalizeString(event.eventType.name)),
                        ],
                      ),
                    ),
                    event.eventLink != null
                        ? Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.link, size: 40),
                          const SizedBox(width: 10),
                          InkWell(
                            child: Text(event.eventLink!),
                            onTap: () async {
                            },
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                    event.description != null
                        ? Container(
                      margin: const EdgeInsets.only(left: 20, top: 50),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            event.description!,
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
