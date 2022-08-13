import 'package:whapp/models/parent.dart';

class Member {
  Member({
    required this.uid,
    required this.emailAddress,
    required this.photoURL,
    required this.points,
    required this.minutes,
    required this.collection,
    required this.role,
    required this.fullName,
    required this.studentId,
    required this.homeroom,
    required this.gradeLevel,
    this.hispanic,
    this.ethnicities,
    this.cellPhone,
    this.address,
    this.primaryParent,
    this.tShirtSize,
    this.tShirtReceived,
    this.duesPaid,
  });

  // User Information
  String uid;
  String emailAddress;
  String photoURL;

  int points;
  int minutes;
  double collection;

  int role; // 1 - admin, 2 - board, 3 - general
  String fullName;

  // Student Information
  String studentId;
  String homeroom;
  int gradeLevel; // 9, 10, 11, 12

  // Ethnicity Information
  bool? hispanic;
  List<String>? ethnicities;

  // Contact Information
  String? cellPhone;
  String? address;

  // Primary Parent Information
  Parent? primaryParent;

  // Member Information
  String? tShirtSize;
  bool? tShirtReceived;
  bool? duesPaid;
}
