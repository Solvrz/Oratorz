import 'package:flutter/material.dart' hide Tab;
import 'package:intl/intl.dart';

import './enums.dart';

extension ToolsString on String {
  String get capitalize => substring(0, 1).toUpperCase() + substring(1);

  Color get toColor => Color("0xFF$this".toInt);

  num get toNum => num.parse(this);
  double get toDouble => double.parse(this);
  int get toInt => int.parse(this);

  // TODO: Use These
  Tab get toTab => Tab.values.firstWhere(
        (e) =>
            e.toString() == "Tab.${toString().split("/").last.toUpperCase()}",
      );
  Mode get toMode => Mode.values.firstWhere(
        (e) =>
            e.toString() == "Mode.${toString().split("/").last.toUpperCase()}",
      );
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
  String get toFmattedDate => DateFormat("dd MMMM").format(this);
}

extension ToolsTextEditingController on TextEditingController {
  String get toText => text.trim();
}

extension ToolsTab on Tab {
  String get toText =>
      toString().split(".")[1].split(RegExp("(?=(?!^)[A-Z])")).join(" ");
}

extension ToolsMode on Mode {
  String get toText =>
      toString().split(".")[1].split(RegExp("(?=(?!^)[A-Z])")).join(" ");
}
