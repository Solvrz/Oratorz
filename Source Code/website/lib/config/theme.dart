// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './colors.dart';

class OratorzTheme {
  static ThemeData of(BuildContext context) {
    final TextTheme textTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: OratorzColors.primaryColor,
      hoverColor: Colors.grey.shade100,
      colorScheme: const ColorScheme.light().copyWith(
        primary: OratorzColors.primaryColor,
        secondary: OratorzColors.secondaryColor,
        tertiary: OratorzColors.tertiaryColor,
        onPrimary: OratorzColors.secondaryColor,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 54,
        ),
        displayMedium: textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        headlineSmall: textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headlineLarge: textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
        titleLarge: textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bodyLarge: textTheme.bodyLarge!.copyWith(fontSize: 16),
        bodyMedium: textTheme.bodyMedium!.copyWith(fontSize: 14),
        bodySmall: textTheme.bodySmall!.copyWith(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: OratorzColors.secondaryColor,
      ),
      tooltipTheme: const TooltipThemeData(
        margin: EdgeInsets.all(5),
      ),
      cardTheme: CardThemeData(
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(12),
          ),
          overlayColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 250, 230),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            Colors.amber.shade400,
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.amber.shade400,
                width: 0.75,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const StadiumBorder(),
          backgroundColor: OratorzColors.primaryColor,
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.grey.shade700,
        selectionColor: Colors.grey.shade500,
        selectionHandleColor: Colors.grey.shade700,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade200,
        iconColor: Colors.grey.shade600,
        prefixIconColor: Colors.grey.shade600,
        contentPadding: const EdgeInsets.all(12),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        crossAxisMargin: -2,
        thumbColor: WidgetStateProperty.all(OratorzColors.secondaryColor),
        thickness: WidgetStateProperty.all(5),
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
