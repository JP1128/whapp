enum EventType {
  volunteer,
  attendance,
}

class Event {
  Event({
    required this.id,
    required this.boardOnly,
    required this.title,
    required this.description,
    required this.location,
    required this.start,
    required this.end,
  });

  String id;
  bool boardOnly;

  String title;
  String? description;
  String location;

  DateTime start;
  DateTime end;
}
