import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whapp/models/event.dart';

class History {
  History({
    required this.uid,
    this.eid,
    this.eventTitle,
    this.in_,
    this.out,
    this.message,
    required this.pointsEarned,
    required this.minutesEarned,
    required this.collectionEarned,
    required this.timestamp,
  });

  String uid;

  String? eid;
  String? eventTitle;

  TimeOfDay? in_;
  TimeOfDay? out;

  String? message;

  int pointsEarned;
  int minutesEarned;
  double collectionEarned;

  Timestamp timestamp;
}
