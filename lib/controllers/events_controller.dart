import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:whapp/models/events/attendance.dart';
import 'package:whapp/models/events/event.dart';
import 'package:whapp/models/events/volunteer.dart';
import 'package:async/async.dart';

class EventsController extends GetxController {
  static final EventsController instance = Get.find();

  final _db = FirebaseFirestore.instance;

  final dateController = DateRangePickerController();

  EventType? eventType;

  // General event information
  bool boardOnly = false;
  String? title;
  String? description;
  String? location;
  DateTime? start;
  DateTime? end;

  // Volunteer specific information
  int? capacity;
  int? pointCost;
  int? minMinutes;
  int? minCollection;

  // Attendance specific information
  int? pointReward;

  void clear() {
    dateController.selectedDate = null;
    eventType = null;

    boardOnly = false;
    title = null;
    description = null;
    location = null;
    start = null;
    end = null;

    capacity = null;
    pointCost = null;
    minMinutes = null;
    minCollection = null;

    pointReward = null;
  }

  Future<void> createVolunteerEvent() async {
    await _db //
        .collection("volunteerEvents")
        .add({
      "boardOnly": boardOnly,
      "title": title!,
      "description": description,
      "location": location!,
      "start": start!,
      "end": end!,
      "capacity": capacity,
      "pointCost": pointCost,
      "minMinutes": minMinutes,
      "minCollection": minCollection,
      "totalRaised": null,
    });
  }

  Future<void> createAttendanceEvent() async {
    await _db //
        .collection("attendanceEvents")
        .add({
      "boardOnly": boardOnly,
      "title": title!,
      "description": description,
      "location": location!,
      "start": start!,
      "end": end!,
      "pointReward": pointReward,
    });
  }

  Future<void> deleteEvent(Event event) async {
    if (event is AttendanceEvent) {
      await _db.collection("attendanceEvents").doc(event.id).delete();
    } else if (event is VolunteerEvent) {
      await _db.collection("volunteerEvents").doc(event.id).delete();
    }
  }

  Stream<List<VolunteerEvent>> getVolunteerEvents() {
    return _db //
        .collection("volunteerEvents")
        .where(
          "start",
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1)),
          ),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();

              var event = VolunteerEvent(
                id: doc.id,
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
    return _db //
        .collection("attendanceEvents")
        .where(
          "start",
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1)),
          ),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();

              var event = AttendanceEvent(
                id: doc.id,
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
