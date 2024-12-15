import 'package:eventure/utils/string_parser.dart';
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
              color: Colors.black.withOpacity(0.1), // Subtle shadow
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 117,
              height: 100,
              child: Center(
                child: Icon(
                  icon,
                  size: 36,
                  color: Theme.of(context).colorScheme.secondary,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ), // Dynamic text style
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary // Dynamic icon color
                        ),
                        const SizedBox(width: 8),
                        Text(
                          parseDateForEvents(startDate),
                          style: Theme.of(context).textTheme.bodySmall, // Dynamic text style
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          organizer,
                          style: Theme.of(context).textTheme.bodySmall,
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
