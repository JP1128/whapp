class Member {
  Member({
    // User information
    required this.uid,
    required this.emailAddress,
    required this.photoURL,
    required this.role,
    // PMC
    required this.points,
    required this.minutes,
    required this.collection,
    // Student information
    required this.fullName,
    required this.studentId,
    required this.homeroom,
    required this.gradeLevel,
    // Contact information
    required this.phoneNumber,
    required this.streetAddress,
    required this.tShirtSize,
    required this.tShirtReceived,
    required this.duesPaid,
  });

  // User information
  String uid;
  String emailAddress;
  String? photoURL;
  int role; // 1 - admin, 2 - board, 3 - general

  int points;
  int minutes;
  double collection;

  // Student information
  String fullName;
  String studentId;
  String homeroom;
  String gradeLevel; // freshman, sophomore, junior, senior, supervisor

  // Contact information
  String phoneNumber;
  String streetAddress;

  // Member information
  String tShirtSize;
  bool? tShirtReceived;
  bool? duesPaid;

  @override
  String toString() {
    return fullName;
  }
}
