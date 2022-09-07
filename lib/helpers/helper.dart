import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whapp/widgets/avatar_painter.dart';
import 'package:vector_math/vector_math.dart' as vm;

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

Widget showAvatar(String uid, int size) {
  return FutureBuilder<ImageProvider>(
    future: drawAvatar(uid),
    builder: ((context, snapshot) {
      if (snapshot.hasData) {
        return CircleAvatar(
          backgroundImage: snapshot.data,
          radius: size.toDouble(),
        );
      }

      return CircularProgressIndicator();
    }),
  );
}

Future<ImageProvider> drawAvatar(String seed) async {
  var hash = seed.hashCode;

  final backgroundColor = Color(getColor(hash + 13, colorPalette));
  final headColor = Color(getColor(hash, colorPalette));
  final faceColor = getContrast(headColor);

  final headPreX = getUnit(hash, 100, index: 1);
  final headPreY = getUnit(hash, 100, index: 2);
  final headTranslateX = headPreX < 50 ? headPreX + 360 / 9 : headPreX;
  final headTranslateY = headPreY < 50 ? headPreY + 360 / 9 : headPreY;
  final headRotate = vm.radians(getUnit(hash, 360).toDouble());
  final headScale = 1 + getUnit(hash, 360 ~/ 12) / 100;

  final mouthOpen = getBool(hash, 2);
  final isCircle = getBool(hash, 1);

  final eyeSpread = getUnit(hash, 30);
  final mouthSpread = getUnit(hash, 10);

  final faceTranslateX = headTranslateX > 360 / 6 ? headTranslateX / 2 : getUnit(hash, 80, index: 1);
  final faceTranslateY = headTranslateY > 360 / 6 ? headTranslateY / 2 : getUnit(hash, 70, index: 2);
  final faceRotate = vm.radians(getUnit(hash, 10, index: 3).toDouble());

  final headPaint = Paint()..color = headColor;
  final facePaint = Paint()..color = faceColor;

  final center = 360 / 2;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromPoints(
      Offset.zero,
      Offset(360, 360),
    ),
  );

  // Draw background
  canvas.save();
  canvas.drawColor(backgroundColor, BlendMode.src);

  canvas.restore();

  // Draw head
  canvas.save();
  canvas.translate(headTranslateX.toDouble(), headTranslateY.toDouble());

  canvas.translate(center, center);
  canvas.rotate(headRotate);
  canvas.translate(-center, -center);

  canvas.scale(headScale);

  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center, center),
        width: 360,
        height: 360,
      ),
      Radius.circular(isCircle ? 360 : 360 / 6),
    ),
    headPaint,
  );

  canvas.restore();

  // Draw face
  canvas.save();
  canvas.translate(faceTranslateX.toDouble(), faceTranslateY.toDouble());

  canvas.translate(center, center);
  canvas.rotate(faceRotate);
  canvas.translate(-center, -center);

  var path = Path();
  final mouthPaint = Paint()..color = faceColor;

  if (mouthOpen) {
    mouthPaint
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    path.moveTo(160, 190.0 + mouthSpread);
    path.relativeCubicTo(15, 5, 25, 5, 40, 0);
  } else {
    path.moveTo(140, 190.0 + mouthSpread);
    path.relativeArcToPoint(
      const Offset(80, 0),
      radius: Radius.elliptical(1, 0.75),
      clockwise: false,
    );
  }

  canvas.drawPath(path, mouthPaint);

  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(160.0 - eyeSpread, 140),
      width: 10,
      height: 15,
    ),
    facePaint,
  );

  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(200.0 + eyeSpread, 140),
      width: 10,
      height: 15,
    ),
    facePaint,
  );

  canvas.restore();

  final picture = recorder.endRecording();
  final image = await picture.toImage(360, 360);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return MemoryImage(Uint8List.view(data!.buffer));
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
