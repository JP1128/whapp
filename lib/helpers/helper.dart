import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

int minuteFromTimeOfDay(TimeOfDay start, TimeOfDay end) {
  int endMinutes = end.hour * 60 + end.minute;
  int startMinutes = start.hour * 60 + start.minute;
  return endMinutes - startMinutes;
}

String getRoleName(int role) {
  switch (role) {
    case 1:
      return "admin";
    case 2:
      return "board member";
    case 3:
      return "general member";
    default:
      throw Exception("Invalid role");
  }
}

String? boolToString(bool? boo) {
  if (boo == null) {
    return null;
  }

  return boo ? "yes" : "no";
}

String initial(String fullName) {
  return fullName.split(" ").reduce((value, element) => value[0] + element[0]);
}

String formatDate(DateTime dateTime, String formatter) {
  return DateFormat(formatter).format(dateTime);
}

String weekday(int weekday) {
  switch (weekday) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wedsneday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      throw Exception();
  }
}

String parsePhoneNumber(String phoneNumber) {
  var a = phoneNumber.substring(0, 3);
  var b = phoneNumber.substring(3, 6);
  var c = phoneNumber.substring(6);
  return "$a-$b-$c";
}

Widget showAvatar(String svg, double size) {
  return SvgPicture.string(
    svg,
    width: size,
    height: size,
  );
}

Future<String> getAvatarString(String uid) async {
  var res = await Dio().get(
    'https://source.boringavatars.com/beam/500/$uid',
    options: Options(
      responseType: ResponseType.plain,
    ),
  );

  return res.data;
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AwesomeSnackbarContent(
        title: "Oh Snap!",
        message: message,
        contentType: ContentType.failure,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccess(BuildContext context, String title, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AwesomeSnackbarContent(
        title: "Oh Snap!",
        message: message,
        contentType: ContentType.failure,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showWIP(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 500),
      content: Text("Currently work in progress!"),
    ),
  );
}

String? Function(String?) valueMatch(RegExp regex, String errorMessage) {
  return (String? val) => val == null || regex.hasMatch(val) ? null : errorMessage;
}

final RegExp nameRegExp = RegExp(r" *[a-z-]{2,}( [a-z-]{2,})+$ *", caseSensitive: false);
final RegExp homeroomNameRegExp = RegExp(r"^(dr|mrs?|ms)\. [a-z]{2,}", caseSensitive: false);
