import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/member.dart';

class VolunteerEvent extends Event {
  VolunteerEvent({
    required super.boardOnly,
    required super.title,
    required super.description,
    required super.location,
    required super.start,
    required super.end,
    required this.capacity,
    required this.pointCost,
    required this.minMinutes,
    required this.minCollection,
    required this.totalRaised,
  });

  int? capacity;

  int? pointCost;
  int? minMinutes;
  int? minCollection;

  double? totalRaised;
}
