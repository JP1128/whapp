enum EventType {
  volunteer,
  attendance,
}

class Event {
  Event({
    required this.boardOnly,
    required this.title,
    required this.description,
    required this.location,
    required this.start,
    required this.end,
  });

  bool boardOnly;

  String title;
  String description;
  String location;

  DateTime start;
  DateTime end;
}
