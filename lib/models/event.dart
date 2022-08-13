class Event {
  Event({
    required this.eventType,
    required this.boardOnly,
    required this.title,
    required this.description,
    required this.location,
    required this.start,
    required this.end,
    this.capacity,
    this.requiredPoints,
    this.requiredMinutes,
    this.requiredCollection,
    this.rewardedPoints,
  });

  String eventType; // volunteer, donation, attendance
  bool boardOnly;

  String title;
  String description;
  String location;

  DateTime start;
  DateTime end;

  //////////////////////////////////////////////////////
  /// VOLUNTEER
  //////////////////////////////////////////////////////
  int? capacity; // maximum number of sign-ups

  // requirement for sign-up
  int? requiredPoints;
  int? requiredMinutes;
  int? requiredCollection;

  //////////////////////////////////////////////////////
  /// ATTENDANCE
  //////////////////////////////////////////////////////
  int? rewardedPoints;

  //////////////////////////////////////////////////////
  /// ITEM DONATION
  //////////////////////////////////////////////////////

}
