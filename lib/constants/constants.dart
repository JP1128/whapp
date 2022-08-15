import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:whapp/constants/theme.dart';

const defaultPadding = EdgeInsets.symmetric(
  vertical: 50.0,
  horizontal: 30.0,
);

const CircleAvatar volunteerAvatar = CircleAvatar(
  backgroundColor: volunteerColor,
  child: Icon(
    Icons.volunteer_activism_rounded,
    color: onVolunteerColor,
  ),
);

const CircleAvatar attendanceAvatar = CircleAvatar(
  backgroundColor: attendanceColor,
  child: Icon(
    Icons.check_rounded,
    color: onAttendanceColor,
  ),
);
