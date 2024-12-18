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
      appBar: AppBar(
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
              : const SizedBox.shrink()
        ],
      ),
      body: Column(
        children: [
          Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(
                  event.icon,
                  size: 70,
                ),
              )),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(event.name,
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.bold)),
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
                        const SizedBox(
                          width: 10,
                        ),
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
                        const Icon(
                          Icons.location_pin,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          label: const Text('Navigation'),
                          icon: const Icon(Icons.navigation),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.black),
                          onPressed: () async {
                            // TODO call google maps using url_launcher
                            // Uri googleMapsLink = Uri.parse(
                            //     'https://www.google.com/maps/dir/?api=1&destination=${event.location.latitude},${event.location.longitude}');
                            // await launchUrl(googleMapsLink);
                            print('Navigation pressed');
                          },
                        )
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
                            .getUserName(event.organizer ?? ""))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.supervised_user_circle, size: 40),
                        const SizedBox(width: 10),
                        Text(capitalizeString(event.visibility.name))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      children: [
                        Icon(event.icon, size: 40),
                        const SizedBox(width: 10),
                        Text(capitalizeString(event.eventType.name))
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
                                  // TODO call link using url_launcher
                                  // final Uri url = Uri.parse(event.eventLink!);
                                  // await launchUrl(url);
                                  print('Event link pressed');
                                },
                              )
                            ],
                          ))
                      : const SizedBox.shrink(),
                  event.description != null
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 50, right: 20),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Beschreibung',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                event.description!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ))
                      : const SizedBox.shrink()
                ]),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, right: 16.0),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFEDEAF4),
          onPressed: () async {
            context.push("/chat/${event.id}");
          },
          child: const Icon(
            Icons.message,
            color: Color(0xFF7763AE),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
