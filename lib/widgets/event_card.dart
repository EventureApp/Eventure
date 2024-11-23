import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final String adress;
  final IconData icon; // URL oder Asset-Pfad für das Bild
  // final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.name,
    required this.startDate,
    required this.adress,
    required this.icon,
  }) : super(key: key);

  // Alternativer Factory-Konstruktor zur Verwendung eines Event-Objekts
  factory EventCard.fromEvent(Event event) {
    return EventCard(
      name: event.name,
      startDate: event.startDate,
      adress: event.adress,
      icon: event.icon,
    );
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      child: Container(
        width: 342,
        height: 141,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            // Event Icon
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 117,
                height: 141,
                color: Colors.grey[300], // Hintergrundfarbe
                child: Center(
                  child: Icon(
                    icon, // IconData wird hier verwendet
                    size: 64, // Größe des Icons
                    color: Colors.blue, // Farbe des Icons
                  ),
                ),
              ),
            ),
            // Event title
            Positioned(
              top: 8,
              left: 130,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ),
            // Event time
            Positioned(
              top: 49,
              left: 130,
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    startDate.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Event address
            Positioned(
              top: 89,
              left: 130,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.black),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      adress,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ], // Hier war ein Problem mit der Klammer
        ),
      ),
    );
  }
}
