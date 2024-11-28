import 'package:eventure/models/event_filter.dart';
import 'package:flutter/cupertino.dart';

class FilterProvider with ChangeNotifier {
  EventFilter filter = EventFilter(range: 10.0);
}
