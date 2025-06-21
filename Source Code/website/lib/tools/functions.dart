import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

Widget flag(String delegate, {double size = 30}) => Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(1, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Image.asset(
        height: size,
        width: size,
        "flags/${delegate.split(" ")[0]}.png",
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => SvgPicture.asset(
          height: size,
          width: size,
          "images/Logo.svg",
        ),
      ),
    );

void snackbar(BuildContext context, Widget content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    margin: EdgeInsets.only(
      top: context.mediaQuerySize.height / 1.1,
      bottom: 16,
      right: context.mediaQuerySize.width / 3,
      left: context.mediaQuerySize.width / 3,
    ),
    behavior: SnackBarBehavior.floating,
    content: content,
  ),);
}

Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double elevation = lerpDouble(0, 6, animValue)!;
      return Material(
        elevation: elevation,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: child,
      );
    },
    child: child,
  );
}
