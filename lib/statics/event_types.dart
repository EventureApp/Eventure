import 'package:flutter/material.dart';

import 'custom_icons.dart';

enum EventType {
  concert,
  bar,
  party,
  rave,
  gameNight,
  hangout,
  study,
  connect,
  other,
  gaming,
  sport
}

Map<EventType, IconData> eventTypesWithIcon = {
  EventType.concert: Icons.music_note,
  EventType.bar: Icons.local_bar,
  EventType.party: Icons.nightlife,
  EventType.rave: Icons.graphic_eq,
  EventType.hangout: Icons.weekend,
  EventType.study: Icons.book,
  EventType.connect: Icons.diversity_3,
  EventType.other: Icons.question_mark,
  EventType.gaming: CustomIcons.gamingController,
  EventType.sport: Icons.sports_basketball_outlined
};
