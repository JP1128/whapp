import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF212529);
const Color errorColor = Color(0xFFBD4747);
const Color successColor = Color(0xFF54CB5E);

const Color onVolunteerColor = Color(0xFF5D9562);
const Color volunteerColor = Color(0xFFE7F0E8);

const Color onAttendanceColor = Color(0xFFA3AD41);
const Color attendanceColor = Color(0xFFE6EAC7);

const List<Color> palette = [
  Color(0xFFFCFCFC),
  Color(0xFFF8F9FA),
  Color(0xFFE9ECEF),
  Color(0xFFDEE2E6),
  Color(0xFFCED4DA),
  Color(0xFFADB5BD),
  Color(0xFF6C757D),
  Color(0xFF495057),
  Color(0xFF343A40),
  Color(0xFF212529),
];

const thin = FontWeight.w100;
const extraLight = FontWeight.w200;
const light = FontWeight.w300;
const regular = FontWeight.w400;
const medium = FontWeight.w500;
const semiBold = FontWeight.w600;
const bold = FontWeight.w700;
const extraBold = FontWeight.w800;
const black = FontWeight.w900;

TextStyle roboto(double? fontSize, FontWeight? fontWeight, {Color? color}) => GoogleFonts.roboto(
      fontSize: fontSize ?? 12.0,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? palette.last,
    );

AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: palette.first,
  titleTextStyle: GoogleFonts.roboto(
    color: palette[9],
    fontWeight: FontWeight.w600,
  ),
  centerTitle: true,
  iconTheme: IconThemeData(
    color: palette[9],
    size: 20,
  ),
);

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  border: const OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  iconColor: palette[6],
  helperMaxLines: 1,
  errorMaxLines: 1,
  labelStyle: roboto(12, regular),
  focusColor: primaryColor,
);

ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),
    textStyle: MaterialStateProperty.all(roboto(15, bold)),
    minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
    backgroundColor: MaterialStateProperty.all(primaryColor),
  ),
);

OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    )),
    foregroundColor: MaterialStateProperty.all(primaryColor),
    textStyle: MaterialStateProperty.all(roboto(15, semiBold)),
    minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
  ),
);

BottomNavigationBarThemeData navigationBarThemeData = BottomNavigationBarThemeData(
  selectedItemColor: primaryColor,
  unselectedItemColor: primaryColor,
  type: BottomNavigationBarType.shifting,
  showUnselectedLabels: false,
  selectedLabelStyle: roboto(10, regular),
);

ButtonThemeData buttonTheme = const ButtonThemeData();

ChipThemeData chipTheme = ChipThemeData(
  labelStyle: roboto(12, medium),
);

final ThemeData lightTheme = ThemeData(
  appBarTheme: appBarTheme,
  brightness: Brightness.light,
  scaffoldBackgroundColor: palette[0],
  primaryColor: primaryColor,
  textTheme: GoogleFonts.robotoTextTheme(
    TextTheme(
      displayLarge: roboto(35, bold),
      displayMedium: roboto(25, semiBold),
      titleLarge: roboto(25, semiBold),
      titleMedium: roboto(20, semiBold),
      titleSmall: roboto(12, medium),
      bodyLarge: roboto(17, regular),
      bodyMedium: roboto(14, regular),
      bodySmall: roboto(12, regular),
    ),
  ),
  inputDecorationTheme: inputDecorationTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  bottomNavigationBarTheme: navigationBarThemeData,
  buttonTheme: buttonTheme,
  chipTheme: chipTheme,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  ),
);
