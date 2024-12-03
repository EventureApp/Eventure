import 'package:flutter/cupertino.dart';

import 'custom_icons.dart';

enum EventType {
  concert,
  bar,
  praty,
  rave,
  playNight,
  chilling,
  learning,
  connecting,
  someThingElse,
}


Map<EventType, IconData> EventTypesWithIcon = {
  EventType.concert : CustomIcons.beer2,
  EventType.bar : CustomIcons.beer2,
  EventType.praty : CustomIcons.beer2,
  EventType.rave : CustomIcons.beer2,
  EventType.playNight : CustomIcons.beer2,
  EventType.chilling :CustomIcons.beer2,
  EventType.learning : CustomIcons.beer2,
  EventType.connecting : CustomIcons.beer2,
  EventType.someThingElse : CustomIcons.beer2
};