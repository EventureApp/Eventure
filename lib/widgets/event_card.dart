import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final String address;
  final String organizer;
  final IconData icon;
  final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.name,
    required this.startDate,
    required this.address,
    required this.icon,
    required this.onTap,
    required this.organizer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 117,
              height: 141,
              child: Center(
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.blue,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 18, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          startDate.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          organizer,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
