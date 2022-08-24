import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whapp/constants/theme.dart';

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

void showSuccess(String title, String message) {
  Get.snackbar(
    title,
    message,
    borderRadius: 10,
    isDismissible: true,
    shouldIconPulse: true,
    icon: Icon(Icons.check, color: palette.first),
    backgroundColor: successColor,
    snackPosition: SnackPosition.BOTTOM,
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 30,
    ),
    margin: const EdgeInsets.all(20),
    titleText: Text(
      title,
      style: poppins(15, semiBold, color: palette.first),
    ),
    messageText: Text(
      message,
      style: poppins(13, light, color: palette[1]),
    ),
  );
}

String? Function(String?) valueMatch(RegExp regex, String errorMessage) {
  return (String? val) => val == null || regex.hasMatch(val) ? null : errorMessage;
}

final RegExp nameRegExp = RegExp(r" *[a-z-]{2,}( [a-z-]{2,})+$ *", caseSensitive: false);
final RegExp homeroomNameRegExp = RegExp(r"^(dr|mrs?|ms)\. [a-z]{2,}", caseSensitive: false);
