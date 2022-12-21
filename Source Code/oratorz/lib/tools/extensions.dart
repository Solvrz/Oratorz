import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './enums.dart';

extension ToolsString on String {
  String capitalize() => substring(0, 1).toUpperCase() + substring(1);

  Color toColor() => Color("0xFF$this".toInt());

  num toNum() => num.parse(this);
  double toDouble() => double.parse(this);
  int toInt() => int.parse(this);

  AlertType toAlertType() => AlertType.values.firstWhere(
        (e) => e.toString() == "AlertType.${toString().split(" ").join()}",
      );
}

extension ToolsDouble on double {
  String toCurrencyFormat({int decimalDigits = 2}) =>
      NumberFormat.simpleCurrency(
        decimalDigits: decimalDigits,
      ).format(this);
}

extension ToolsColor on Color {
  String code() => toString().toLowerCase().split("f")[2].split(")")[0];
}

extension ToolsLocale on Locale {
  String code() => toLanguageTag().replaceAll("-", "_");
}

extension ToolsDateTime on DateTime {
  String toFormattedDate() => DateFormat("dd MMMM").format(this);
}

extension ToolsTextEditingController on TextEditingController {
  String toText() => text.trim();
}

extension ToolsAlert on AlertType {
  String toText() =>
      toString().split(".")[1].split(RegExp("(?=(?!^)[A-Z])")).join(" ");
}
