enum EventType { attendance, volunteer }

class Event {
  Event({
    required this.id,
    required this.eventType,
    required this.boardOnly,
    required this.title,
    required this.description,
    required this.location,
    required this.start,
    required this.end,
    this.pointReward,
    this.capacity,
    this.minMinutes,
    this.minCollection,
    this.totalRaised,
    this.checkedId,
    this.signUpsId,
    this.signUps,
  });

  String id;
  EventType eventType;
  bool boardOnly;

  String title;
  String description;
  String location;

  DateTime start;
  DateTime end;

  // attendance
  // amount of point rewarded for attending
  int? pointReward;

  // volunteer
  int? capacity;
  int? minMinutes;
  int? minCollection;
  double? totalRaised;

  List<String>? checkedId;
  List<String>? signUpsId;
  List<SignedUpMembers>? signUps;
}

class SignedUpMembers {
  SignedUpMembers({
    required this.uid,
    required this.photoURL,
    required this.fullName,
    required this.gradeLevel,
    required this.phoneNumber,
    required this.emailAddress,
  });

  String uid;
  String photoURL;
  String fullName;
  String gradeLevel;
  String phoneNumber;
  String emailAddress;
}
