class EventStruct {
  final String summary;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String timezone;
  final List<String> recurrenceRules;

  EventStruct({
    required this.summary,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.timezone,
    required this.recurrenceRules,
  });
}