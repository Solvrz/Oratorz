import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headline5: const TextStyle(fontWeight: FontWeight.bold),
    headline6: const TextStyle(fontSize: 18),
  ),
  cardTheme: CardTheme(
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    shadowColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          side: BorderSide(color: Colors.amber.shade400, width: 0.75),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 255, 250, 230),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.amber.shade400),
    ),
  ),
);
