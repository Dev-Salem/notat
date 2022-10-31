import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get DarkTheme {
    return ThemeData(
      dialogBackgroundColor: Color.fromRGBO(31, 29, 43, 1),
      dialogTheme: DialogTheme(
          contentTextStyle:
              GoogleFonts.ubuntu(color: Colors.white, fontSize: 16),
          titleTextStyle: GoogleFonts.ubuntu(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
      colorScheme: const ColorScheme.light()
          .copyWith(secondary: const Color.fromRGBO(111, 111, 200, 1)),
      popupMenuTheme:
          const PopupMenuThemeData(textStyle: TextStyle(color: Colors.white)),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color.fromARGB(97, 111, 111, 200),
          cursorColor: Color.fromRGBO(111, 111, 200, 1)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(45, 70, 70, 110)))),
      hintColor: const Color.fromARGB(255, 187, 187, 242),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      cardColor: const Color.fromRGBO(39, 38, 53, 1), //color of the container
      scaffoldBackgroundColor:
          const Color.fromRGBO(31, 29, 43, 1), //background color
      primaryColor: const Color.fromRGBO(111, 111, 200, 1), //color of buttons
      tabBarTheme: const TabBarTheme(
          labelColor:
              Color.fromARGB(255, 216, 182, 57)), //color of tab bar label
    );
  }
}
