//**
// Credit to Github: boringdesigners/boring-avatars
// */

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

const colorPalette = [
  0xFFFFAD08,
  0xFFEDD75A,
  0xFF73B06F,
  0xFF0C8F8F,
  0xFF405059,
];

double yiq(Color color) => ((color.red * 299) + (color.green * 587) + (color.blue * 114)) / 1000;

Color getContrast(Color color) => yiq(color) >= 128 ? Colors.black : Colors.white;

int getColor(int hash, List<int> colors) => colors[hash % colors.length];

int getDigit(int hash, int index) => ((hash / pow(10, index)) % 10).floor();

bool getBool(int hash, int index) => getDigit(hash, index) % 2 != 0;

int getUnit(int hash, int range, {int? index}) {
  int value = hash % range;
  if (index == null) return value;
  return getDigit(hash, index) % 2 == 0 ? -value : value;
}

class AvatarPainter extends CustomPainter {
  AvatarPainter(this.seed, this.width);

  String seed;
  double width;

  @override
  void paint(Canvas canvas, Size size) {
    var hash = seed.hashCode;

    final backgroundColor = Color(getColor(hash + 13, colorPalette));
    final headColor = Color(getColor(hash, colorPalette));
    final faceColor = getContrast(headColor);

    final headPreX = getUnit(hash, 100, index: 1);
    final headPreY = getUnit(hash, 100, index: 2);
    final headTranslateX = headPreX < 50 ? headPreX + width / 9 : headPreX;
    final headTranslateY = headPreY < 50 ? headPreY + width / 9 : headPreY;
    final headRotate = vm.radians(getUnit(hash, 360).toDouble());
    final headScale = 1 + getUnit(hash, width ~/ 12) / 100;

    final mouthOpen = getBool(hash, 2);
    final isCircle = getBool(hash, 1);

    final eyeSpread = getUnit(hash, 30);
    final mouthSpread = getUnit(hash, 10);

    final faceTranslateX = headTranslateX > width / 6 ? headTranslateX / 2 : getUnit(hash, 80, index: 1);
    final faceTranslateY = headTranslateY > width / 6 ? headTranslateY / 2 : getUnit(hash, 70, index: 2);
    final faceRotate = vm.radians(getUnit(hash, 10, index: 3).toDouble());

    final headPaint = Paint()..color = headColor;
    final facePaint = Paint()..color = faceColor;

    final center = width / 2;

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
          width: width,
          height: width,
        ),
        Radius.circular(isCircle ? width : width / 6),
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
