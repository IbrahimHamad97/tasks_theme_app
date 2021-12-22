import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final light = ThemeData(
      appBarTheme: AppBarTheme(color: Colors.yellow[300]),
      brightness: Brightness.light,
      primaryColor: Colors.white,
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white);

  static final dark = ThemeData(
      appBarTheme: AppBarTheme(color: Colors.red),
      brightness: Brightness.dark,
      backgroundColor: Colors.black);
}

TextStyle get textStyleSmol {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.blue : Colors.grey));
}

TextStyle get textStyleBig {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
}

InputDecoration get inputDec {
  return InputDecoration(
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0, color: Colors.grey)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0, color: Colors.grey)));
}
