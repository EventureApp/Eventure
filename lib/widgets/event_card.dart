import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final String address;
  final IconData icon;
  final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.name,
    required this.startDate,
    required this.address,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle taps.
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: Row(
          children: [
            Container(
              width: 117,
              height: 141,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  icon,
                  size: 64,
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
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 20,
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
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
