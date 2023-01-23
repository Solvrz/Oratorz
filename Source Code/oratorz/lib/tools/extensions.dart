import 'package:flutter/material.dart' hide Tab;
import 'package:intl/intl.dart';

extension ToolsString on String {
  String get capitalize => substring(0, 1).toUpperCase() + substring(1);

  Color get toColor => Color("0xFF$this".toInt);

  num get toNum => num.parse(this);
  double get toDouble => double.parse(this);
  int get toInt => int.parse(this);

  String get extension => ".${split("/")[1].split(".").last}";
}

extension ToolsDouble on double {
  String toCurrencyFormat({int decimalDigits = 2}) =>
      NumberFormat.simpleCurrency(
        decimalDigits: decimalDigits,
      ).format(this);
}

extension ToolsColor on Color {
  String get code => toString().toLowerCase().split("f")[2].split(")")[0];
}

extension ToolsLocale on Locale {
  String get code => toLanguageTag().replaceAll("-", "_");
}

extension ToolsDuration on Duration {
  String get time {
    final String _hour =
        inHours > 0 ? "${inHours.toString().padLeft(2, "0")}:" : "";
    final String _minutes =
        "${(inMinutes - inHours * 60).toString().padLeft(2, "0")}:";
    final String _seconds =
        (inSeconds - inMinutes * 60).toString().padLeft(2, "0");

    return "$_hour$_minutes$_seconds";
  }
}

extension ToolsDateTime on DateTime {
  String get toFormattedDate => DateFormat("dd MMMM").format(this);

  String get to12Hour => DateFormat("jm").format(this).toUpperCase();
  String get to24Hour => DateFormat("Hm").format(this);
}

extension ToolsTextEditingController on TextEditingController {
  String get toText => text.trim();
}

extension ToolsWidget on Widget {
  Widget get withBorders => Container(
        decoration: BoxDecoration(border: Border.all()),
        child: this,
      );
}
