import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './colors.dart';
import './constants.dart';

// ignore: avoid_classes_with_only_static_members
class MUNTheme {
  static ThemeData of(BuildContext context) {
    return ThemeData(
      primaryColor: MUNColors.PrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: MUNColors.PrimaryColor,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: MUNColors.PrimaryLightColor,
        iconColor: MUNColors.PrimaryColor,
        prefixIconColor: MUNColors.PrimaryColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
      ),

      textTheme: ThemeData.dark()
          .textTheme
          .copyWith(
            bodyLarge: GoogleFonts.eczar(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.4,
            ),
            bodyMedium: GoogleFonts.robotoCondensed(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            labelLarge: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.w700,
              letterSpacing: 2.8,
            ),
            headlineSmall: GoogleFonts.eczar(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          )
          .apply(
            displayColor: Colors.white,
            bodyColor: Colors.white,
          ),
      // TODO: Use This
      // appBarTheme: const AppBarTheme(
      //   systemOverlayStyle: SystemUiOverlayStyle.light,
      //   backgroundColor: AlerColors.primaryBackground,
      //   elevation: 0,
      // ),
      // scrollbarTheme: ScrollbarThemeData(
      //   radius: const Radius.circular(10),
      //   thumbColor: MaterialStateProperty.all(AlerColors.buttonColor),
      //   thickness: MaterialStateProperty.all(2),
      //   interactive: true,
      // ),
      // inputDecorationTheme: const InputDecorationTheme(
      //   labelStyle: TextStyle(
      //     color: AlerColors.gray,
      //     fontWeight: FontWeight.w500,
      //   ),
      //   filled: true,
      //   fillColor: AlerColors.inputBackground,
      //   focusedBorder: InputBorder.none,
      // ),
      // snackBarTheme: const SnackBarThemeData(
      //   elevation: 10,
      //   backgroundColor: AlerColors.buttonColor,
      //   contentTextStyle: TextStyle(color: Colors.white),
      // ),
      // bottomSheetTheme: const BottomSheetThemeData(
      //   backgroundColor: AlerColors.primaryBackground,
      //   modalBackgroundColor: Colors.transparent,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //       topRight: Radius.circular(25),
      //       topLeft: Radius.circular(25),
      //     ),
      //   ),
      // ),
      // floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //   elevation: 10,
      //   backgroundColor: AlerColors.buttonColor,
      //   foregroundColor: AlerColors.primaryBackground,
      // ),
      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(
      //     textStyle: MaterialStateProperty.all<TextStyle>(
      //       const TextStyle(color: AlerColors.white60),
      //     ),
      //     foregroundColor:
      //         MaterialStateProperty.all<Color>(AlerColors.buttonColor),
      //   ),
      // ),
    );
  }
}
