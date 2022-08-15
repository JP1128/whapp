import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:whapp/models/events/attendance.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/events/volunteer.dart';
import 'package:async/async.dart';

class EventsController extends GetxController {
  static final EventsController instance = Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createVolunteerEvent(VolunteerEvent event) async {
    await _db //
        .collection("volunteerEvents")
        .add({
      "boardOnly": event.boardOnly,
      "title": event.title,
      "description": event.description,
      "location": event.location,
      "start": event.start,
      "end": event.end,
      "capacity": event.capacity,
      "pointCost": event.pointCost,
      "minMinutes": event.minMinutes,
      "minCollection": event.minCollection,
      "totalRaised": event.totalRaised,
    });
  }

  Future<void> createAttendanceEvent(AttendanceEvent event) async {
    await _db //
        .collection("attendanceEvents")
        .add({
      "boardOnly": event.boardOnly,
      "title": event.title,
      "description": event.description,
      "location": event.location,
      "start": event.start,
      "end": event.end,
      "pointReward": event.pointReward,
    });
  }

  Stream<List<VolunteerEvent>> getVolunteerEvents() {
    var now = DateTime.now();
    var today = Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    return _db //
        .collection("volunteerEvents")
        .where("start", isGreaterThanOrEqualTo: today)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();

              var event = VolunteerEvent(
                boardOnly: doc['boardOnly'],
                title: doc['title'],
                description: doc['description'],
                location: doc['location'],
                start: doc['start'].toDate(),
                end: doc['end'].toDate(),
                capacity: doc['capacity'],
                pointCost: doc['pointCost'],
                minMinutes: doc['minMinutes'],
                minCollection: doc['minCollection'],
                totalRaised: doc['totalRaised'],
              );

              return event;
            }).toList());
  }

  Stream<List<AttendanceEvent>> getAttendanceEvent() {
    var now = DateTime.now();
    var today = Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    return _db //
        .collection("attendanceEvents")
        .where("start", isGreaterThanOrEqualTo: today)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();

              var event = AttendanceEvent(
                boardOnly: doc['boardOnly'],
                title: doc['title'],
                description: doc['description'],
                location: doc['location'],
                start: doc['start'].toDate(),
                end: doc['end'].toDate(),
                pointReward: doc['pointReward'],
              );

              return event;
            }).toList());
  }

  Stream<List<List<Event>>> getEvents() {
    return StreamZip([
      getVolunteerEvents(),
      getAttendanceEvent(),
    ]);
  }
}
