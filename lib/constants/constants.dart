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

const Chip paidDuesChip = Chip(
  label: Text("Paid Dues", style: TextStyle(color: onAttendanceColor)),
  backgroundColor: attendanceColor,
);

const Chip tShirtReceivedChip = Chip(
  label: Text("T-Shirt Received", style: TextStyle(color: onVolunteerColor)),
  backgroundColor: volunteerColor,
);
