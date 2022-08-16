import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whapp/helpers/helper.dart';
import 'package:whapp/models/member.dart';

class StoreController extends GetxController {
  static final StoreController instance = Get.find();

  final _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Stream<Member?> streamMember(String uid) {
    return _db //
        .collection('members')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .map((data) => data != null //
            ? Member(
                uid: data['uid'],
                emailAddress: data['emailAddress'],
                photoURL: data['photoURL'],
                role: data['role'],
                points: data['points'],
                minutes: data['minutes'],
                collection: data['collection'].toDouble(),
                fullName: data['fullName'],
                studentId: data['studentId'],
                homeroom: data['homeroom'],
                gradeLevel: data['gradeLevel'],
                phoneNumber: data['phoneNumber'],
                streetAddress: data['streetAddress'],
                tShirtSize: data['tShirtSize'],
                tShirtReceived: data['tShirtReceived'],
                duesPaid: data['duesPaid'],
              )
            : null);
  }

  Future<void> updateMember(String uid, Map<String, dynamic> newValues) async {
    await _db //
        .collection('members')
        .doc(uid)
        .update(newValues);
  }
}
