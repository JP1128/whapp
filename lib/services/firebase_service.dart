import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/history.dart';
import 'package:whapp/models/member.dart';

class FirebaseService extends ChangeNotifier {
  static final instance = FirebaseService._();

  static final _storage = FirebaseStorage.instance;
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static final _histories = _db.collection("histories");
  static final _members = _db.collection("members");
  static final _events = _db.collection("events");

  FirebaseService._();

  User? get currentUser => _auth.currentUser;

  Stream<User?> userChanges() => _auth.authStateChanges();

  Stream<Member?> memberChanges() => currentUser != null //
      ? memberChangesById(currentUser!.uid)
      : const Stream.empty();

  Stream<Member?> memberChangesById(String uid) => _members //
      .doc(uid)
      .snapshots()
      .map(memberFromDocumentSnapshot);

  Future<Member?> getMember(String uid) async {
    return await _members //
        .doc(uid)
        .get()
        .then(memberFromDocumentSnapshot);
  }

  Future<void> updateMember(Member member) async => await _members //
      .doc(member.uid)
      .set(memberToMap(member));

  Future<void> updateMemberFields(
    String uid,
    Map<String, dynamic> changes,
  ) async =>
      await _members //
          .doc(uid)
          .update(changes);

  Future<String> createEvent(Map<String, dynamic> eventData) async => await _events //
      .add(eventData)
      .then((value) => value.id);

  Future<void> deleteEvent(String id) async => await _events //
      .doc(id)
      .delete();

  Stream<List<Event>?> streamEvents({
    DateTime? after,
    DateTime? before,
  }) {
    return _events //
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((events) {
      var eventsFiltered = events.map(eventFromDocumentSnapshot);

      if (after != null) {
        eventsFiltered = eventsFiltered.where((event) => isAfter(event, after));
      }

      if (before != null) {
        eventsFiltered = eventsFiltered.where((event) => isBefore(event, before));
      }

      return eventsFiltered.toList();
    });
  }

  bool isAfter(Event event, DateTime dateTime) {
    return event.start.isAfter(DateTime(dateTime.year, dateTime.month, dateTime.day));
  }

  bool isBefore(Event event, DateTime dateTime) {
    return event.start.isBefore(DateTime(dateTime.year, dateTime.month, dateTime.day).add(Duration(days: 1)));
  }

  Stream<Event?> streamEvent(String id) {
    return _events.doc(id).snapshots().map(eventFromDocumentSnapshot);
  }

  Stream<List<History>?> streamHistory(String uid) {
    return _histories //
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((histories) => histories.map(historyFromDocumentSnapshot).toList());
  }

  Future<void> checkOutVolunteer(String uid, String eid) async {
    await _events //
        .doc(eid)
        .update({
      "checkedId": FieldValue.arrayUnion([uid])
    });
  }

  Future<void> signUpToVolunteerEvent(Member member, String eid) async {
    await _events //
        .doc(eid)
        .update({
      "signUpsId": FieldValue.arrayUnion([member.uid]),
      "signUps": FieldValue.arrayUnion([
        {
          "uid": member.uid,
          "fullName": member.fullName,
          "gradeLevel": member.gradeLevel,
          "phoneNumber": member.phoneNumber,
          "emailAddress": member.emailAddress,
          "raised": 0.toDouble(),
        }
      ])
    });
  }

  Future<void> cancelVolunteerEvent(SignedUpMembers member, String eid) async {
    await _events //
        .doc(eid)
        .update({
      "signUpsId": FieldValue.arrayRemove([member.uid]),
      "signUps": FieldValue.arrayRemove([
        {
          "uid": member.uid,
          "fullName": member.fullName,
          "gradeLevel": member.gradeLevel,
          "phoneNumber": member.phoneNumber,
          "emailAddress": member.emailAddress,
          "raised": member.raised,
        }
      ])
    });
  }

  Future<void> updateVolunteerEvent(String eid) async {}

  Future<void> updateMemberPMC(
    String uid, {
    int points = 0,
    int minutes = 0,
    double collection = 0,
  }) async {
    updateMemberFields(uid, {
      if (points != 0) 'points': FieldValue.increment(points),
      if (minutes != 0) 'minutes': FieldValue.increment(minutes),
      if (collection != 0) 'collection': FieldValue.increment(collection),
    });
  }

  Future<void> createHistory(
    String uid, {
    Event? event,
    TimeOfDay? in_,
    TimeOfDay? out,
    String? message,
    int pointsEarned = 0,
    int minutesEarned = 0,
    double collectionEarned = 0,
  }) async {
    if (event != null) {
      final inDate = DateTime(
        event.start.year,
        event.start.month,
        event.start.day,
        in_!.hour,
        in_.minute,
      );

      final outDate = DateTime(
        event.end.year,
        event.end.month,
        event.end.day,
        out!.hour,
        out.minute,
      );

      await _histories.add({
        'uid': uid,
        'eventId': event.id,
        'eventTitle': event.title,
        'in': inDate,
        'out': outDate,
        if (message != null) 'message': message,
        'pointsEarned': pointsEarned,
        'minutesEarned': minutesEarned,
        'collectionEarned': collectionEarned,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      assert(message != null);

      await _histories.add({
        'uid': uid,
        'message': message,
        'pointsEarned': pointsEarned,
        'minutesEarned': minutesEarned,
        'collectionEarned': collectionEarned,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showError(context, "Incorrect username or password.");
    }
  }

  Future<UserCredential?> createAccount(BuildContext context, String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          showError(context, "Email is already in use.");
          break;
        default:
          showError(context, e.message!);
          break;
      }
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      showError(context, e.message!);
    }
  }

  Future<void> logout() async {
    _auth.signOut();
  }

  Event eventFromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot['eventType'] == "attendance") {
      return Event(
        id: snapshot.id,
        eventType: EventType.attendance,
        boardOnly: snapshot['boardOnly'],
        title: snapshot['title'],
        description: snapshot['description'],
        location: snapshot['location'],
        start: snapshot['start'].toDate(),
        end: snapshot['end'].toDate(),
        pointReward: snapshot['pointReward'],
      );
    }

    if (snapshot['eventType'] == "volunteer") {
      var signUps = List<SignedUpMembers>.from(snapshot['signUps'] //
          .map((map) {
        return SignedUpMembers(
          uid: map['uid'],
          fullName: map['fullName'],
          gradeLevel: map['gradeLevel'],
          phoneNumber: map['phoneNumber'],
          emailAddress: map['emailAddress'],
          raised: map['raised'].toDouble(),
        );
      }));

      return Event(
        id: snapshot.id,
        eventType: EventType.volunteer,
        boardOnly: snapshot['boardOnly'],
        title: snapshot['title'],
        description: snapshot['description'],
        location: snapshot['location'],
        start: snapshot['start'].toDate(),
        end: snapshot['end'].toDate(),
        capacity: snapshot['capacity'],
        totalRaised: snapshot['totalRaised'].toDouble(),
        checkedId: List<String>.from(snapshot['checkedId']),
        signUpsId: List<String>.from(snapshot['signUpsId']),
        signUps: signUps,
      );
    }

    throw Exception("Invalid Event Type");
  }

  History historyFromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();

    if (data!.containsKey("eventId")) {
      return History(
        uid: data['uid'],
        eid: data['eventId'],
        eventTitle: data['eventTitle'],
        in_: TimeOfDay.fromDateTime(data['in'].toDate()),
        out: TimeOfDay.fromDateTime(data['out'].toDate()),
        message: data['message'],
        pointsEarned: data['pointsEarned'],
        minutesEarned: data['minutesEarned'],
        collectionEarned: data['collectionEarned'].toDouble(),
        timestamp: data['timestamp'],
      );
    }

    return History(
      uid: data['uid'],
      message: data['message'],
      pointsEarned: data['pointsEarned'],
      minutesEarned: data['minutesEarned'],
      collectionEarned: data['collectionEarned'].toDouble(),
      timestamp: data['timestamp'],
    );
  }

  Member? memberFromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.exists
        ? Member(
            uid: snapshot['uid'],
            emailAddress: snapshot['emailAddress'],
            photoURL: snapshot['photoURL'],
            role: snapshot['role'],
            points: snapshot['points'],
            minutes: snapshot['minutes'],
            collection: snapshot['collection'].toDouble(),
            fullName: snapshot['fullName'],
            studentId: snapshot['studentId'],
            homeroom: snapshot['homeroom'],
            gradeLevel: snapshot['gradeLevel'],
            phoneNumber: snapshot['phoneNumber'],
            streetAddress: snapshot['streetAddress'],
            tShirtSize: snapshot['tShirtSize'],
            tShirtReceived: snapshot['tShirtReceived'],
            duesPaid: snapshot['duesPaid'],
          )
        : null;
  }

  Map<String, dynamic> memberToMap(Member member) {
    return {
      "uid": member.uid,
      "emailAddress": member.emailAddress,
      "photoURL": member.photoURL,
      "role": member.role,
      "points": member.points,
      "minutes": member.minutes,
      "collection": member.collection,
      "fullName": member.fullName,
      "studentId": member.studentId,
      "homeroom": member.homeroom,
      "gradeLevel": member.gradeLevel,
      "phoneNumber": member.phoneNumber,
      "streetAddress": member.streetAddress,
      "tShirtSize": member.tShirtSize,
      "tShirtReceived": member.tShirtReceived,
      "duesPaid": member.duesPaid,
    };
  }
}
