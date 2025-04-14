class EventStruct {
  final String summary;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String timezone;
  final List<String> recurrenceRules;
  final bool isGraduateLevel;

  EventStruct({
    required this.summary,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.timezone,
    required this.recurrenceRules,
    required this.isGraduateLevel,
  });

  @override
  String toString() {
    return 'EventStruct('
        'summary: $summary, '
        'description: $description, '
        'location: $location, '
        'startTime: $startTime, '
        'endTime: $endTime, '
        'timezone: $timezone, '
        'recurrenceRules: $recurrenceRules,'
        '${(isGraduateLevel) ? "Graduate level" : "Undergraduate level"}';
  }

}