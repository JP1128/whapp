import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/event.dart';
import 'package:whapp/models/member.dart';
import 'package:whapp/services/firebase_exceptions.dart';

class FirebaseService extends ChangeNotifier {
  static final instance = FirebaseService._();

  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

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

  Stream<List<Event>?> streamEvents() {
    return _events //
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map(
          (events) => events.map(
            (event) {
              if (event['eventType'] == "attendance") {
                return Event(
                  id: event.id,
                  eventType: EventType.attendance,
                  boardOnly: event['boardOnly'],
                  title: event['title'],
                  description: event['description'],
                  location: event['location'],
                  start: event['start'].toDate(),
                  end: event['end'].toDate(),
                  pointReward: event['pointReward'],
                );
              }

              if (event['eventType'] == "volunteer") {
                var signUps = List<SignedUpMembers>.from(event['signUps'] //
                    .map((map) => SignedUpMembers(
                          uid: map['uid'],
                          fullName: map['fullName'],
                          phoneNumber: map['phoneNumber'],
                          emailAddress: map['emailAddress'],
                        )));

                return Event(
                  id: event.id,
                  eventType: EventType.volunteer,
                  boardOnly: event['boardOnly'],
                  title: event['title'],
                  description: event['description'],
                  location: event['location'],
                  start: event['start'].toDate(),
                  end: event['end'].toDate(),
                  capacity: event['capacity'],
                  totalRaised: event['totalRaised'].toDouble(),
                  signUpsId: List<String>.from(event['signUpsId']),
                  signUps: signUps,
                );
              }

              throw Exception("Invalid Event Type");
            },
          ).toList(),
        );
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
          "phoneNumber": member.phoneNumber,
          "emailAddress": member.emailAddress,
        }
      ])
    });
  }

  Future<void> cancelVolunteerEvent(Member member, String eid) async {
    await _events //
        .doc(eid)
        .update({
      "signUpsId": FieldValue.arrayRemove([member.uid]),
      "signUps": FieldValue.arrayRemove([
        {
          "uid": member.uid,
          "fullName": member.fullName,
          "phoneNumber": member.phoneNumber,
          "emailAddress": member.emailAddress,
        }
      ])
    });
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

  Event? eventFromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      switch (snapshot['eventType']) {
        case "attendance":
          return Event(
            id: snapshot['id'],
            eventType: EventType.attendance,
            boardOnly: snapshot['boardOnly'],
            title: snapshot['title'],
            description: snapshot['description'],
            location: snapshot['location'],
            start: snapshot['start'],
            end: snapshot['end'],
            pointReward: snapshot['pointReward'],
          );

        case "volunteer":
      }
    }

    return null;
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
