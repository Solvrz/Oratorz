import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final Widget? tablet;

  const Responsive({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  });

  static bool isMobile(BuildContext context) => context.width < 576;

  static bool isTablet(BuildContext context) =>
      context.width >= 576 && context.width <= 992;

  static bool isDesktop(BuildContext context) => context.width > 992;

  @override
  Widget build(BuildContext context) {
    final Size size = context.size!;

    if (size.width > 992) {
      return desktop;
    } else if (size.width >= 576 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
