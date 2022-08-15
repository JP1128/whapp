import 'package:whapp/models/events/event.dart';

class AttendanceEvent extends Event {
  AttendanceEvent({
    required super.boardOnly,
    required super.title,
    required super.description,
    required super.location,
    required super.start,
    required super.end,
    required this.pointReward,
  });

  int pointReward;
}
