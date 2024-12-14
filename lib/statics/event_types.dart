import 'package:flutter/material.dart';

import 'custom_icons.dart';

enum EventType {
  concert,
  bar,
  party,
  rave,
  playNight,
  chilling,
  learning,
  connecting,
  someThingElse,
  gaming,
}

Map<EventType, IconData> EventTypesWithIcon = {
  EventType.concert: Icons.music_note,
  EventType.bar: Icons.local_bar,
  EventType.party: Icons.nightlife,
  EventType.rave: Icons.graphic_eq,
  EventType.chilling: Icons.weekend,
  EventType.learning: Icons.book,
  EventType.connecting: Icons.diversity_3,
  EventType.someThingElse: Icons.question_mark,
  EventType.gaming: CustomIcons.gamingcontroller
};
