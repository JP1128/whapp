import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final inputBoxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  border: Border.all(
    color: Colors.black12,
  ),
);

final inputFieldTextStyle = GoogleFonts.poppins(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

TextStyle poppins(double? fontSize, FontWeight? fontWeight) {
  return GoogleFonts.poppins(
    fontSize: fontSize ?? 12.0,
    fontWeight: fontWeight ?? FontWeight.w400,
  );
}
