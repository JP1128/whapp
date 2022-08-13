import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

String? breakAddress(String? address) {
  if (address == null) {
    return null;
  }

  var i = address.indexOf(',');
  return "${address.substring(0, i)}\n${address.substring(i + 1)}";
}

void showError(String title, String message) {
  Get.snackbar(
    title,
    message,
    borderRadius: 10,
    isDismissible: true,
    shouldIconPulse: true,
    icon: Icon(Icons.error, color: palette.first),
    backgroundColor: errorColor,
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

final RegExp nameRegExp = RegExp(r"^[a-z-]{2,}( [a-z-]{2,})+$", caseSensitive: false);
final RegExp homeroomNameRegExp = RegExp(r"^(dr|mrs?|ms)\. [a-z]{2,}", caseSensitive: false);
