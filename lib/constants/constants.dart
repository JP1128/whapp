import 'package:flutter/material.dart';
import 'package:whapp/constants/theme.dart';

const horizontalPaddingValue = 30.0;
const verticalPaddingValue = 50.0;

const hPad = EdgeInsets.symmetric(horizontal: horizontalPaddingValue);
const vPad = EdgeInsets.symmetric(vertical: verticalPaddingValue);
const defaultPadding = EdgeInsets.symmetric(
  vertical: verticalPaddingValue,
  horizontal: horizontalPaddingValue,
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
