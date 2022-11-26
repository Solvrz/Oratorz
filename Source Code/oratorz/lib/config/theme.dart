import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './colors.dart';

// ignore: avoid_classes_with_only_static_members
class OratorzTheme {
  static ThemeData of(BuildContext context) {
    final TextTheme textTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      primaryColor: OratorzColors.PrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: textTheme.copyWith(
        headline1: textTheme.headline5!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 54),
        headline5: textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
        headline6: textTheme.headline6!.copyWith(fontSize: 18),
        bodyText1: textTheme.bodyText1!.copyWith(fontSize: 16),
        bodyText2: textTheme.bodyText2!.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(color: Colors.amber.shade400, width: 0.75),
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
          backgroundColor: OratorzColors.PrimaryColor,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: OratorzColors.PrimaryLightColor,
        iconColor: OratorzColors.PrimaryColor,
        prefixIconColor: OratorzColors.PrimaryColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
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
