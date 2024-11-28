

class EventFilter {
  String? searchInput;
  double range;
  DateTime? startDate;
  DateTime? endDate;

  EventFilter({
    this.searchInput,
    required this.range,
    this.startDate,
    this.endDate,
  });
}
