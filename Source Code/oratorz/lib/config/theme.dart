import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './colors.dart';

// ignore: avoid_classes_with_only_static_members
class OratorzTheme {
  static ThemeData of(BuildContext context) {
    final TextTheme textTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      scaffoldBackgroundColor: OratorzColors.primaryColor,
      colorScheme: const ColorScheme.light().copyWith(
        primary: OratorzColors.primaryColor,
        secondary: OratorzColors.secondaryColor,
        tertiary: OratorzColors.tertiaryColor,
      ),
      textTheme: textTheme.copyWith(
        headline1: textTheme.headline5!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 54,
        ),
        headline2: textTheme.headline5!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        headline5: textTheme.headline5!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headline6: textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bodyText1: textTheme.bodyText1!.copyWith(fontSize: 16),
        bodyText2: textTheme.bodyText2!.copyWith(fontSize: 14),
        caption: textTheme.caption!.copyWith(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: OratorzColors.secondaryColor,
      ),
      cardTheme: CardTheme(
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.amber.shade400,
                width: 0.75,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 250, 230),
          ),
          foregroundColor:
              MaterialStateProperty.all<Color>(Colors.amber.shade400),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: OratorzColors.primaryColor,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: OratorzColors.primaryColor,
        prefixIconColor: OratorzColors.primaryColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        crossAxisMargin: -2,
        thumbColor: MaterialStateProperty.all(OratorzColors.secondaryColor),
        thickness: MaterialStateProperty.all(5),
        radius: const Radius.circular(20),
      ),
      snackBarTheme: const SnackBarThemeData(
        elevation: 10,
        backgroundColor: OratorzColors.secondaryColor,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 10,
        foregroundColor: OratorzColors.primaryColor,
        backgroundColor: OratorzColors.secondaryColor,
      ),
    );
  }
}
