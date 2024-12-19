import 'package:eventure/models/event.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/utils/string_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventDetailViewScreen extends StatelessWidget {
  final Event event;

  const EventDetailViewScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context)
            .colorScheme
            .background, // or use a custom color like Color(0xFF1B2936)

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
        body: Column(
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
              child: Container(
                // Set the background color here
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
                              print('Navigation pressed');
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(Provider.of<UserProvider>(context)
                              .getUserName(event.organizer ?? "")),
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
                                    print('Event link pressed');
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
                              // Align children to the left
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  child: Text(
                                    event.description!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
