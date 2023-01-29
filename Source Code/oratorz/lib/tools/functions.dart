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

Widget carousel(BuildContext context) => Text(
      "Carousel Placeholder",
      style: context.textTheme.bodyLarge,
    );

SnackBar getSnackbar(BuildContext context, Widget content) {
  return SnackBar(
    margin: EdgeInsets.only(
      top: context.mediaQuerySize.height / 1.1,
      bottom: 16,
      right: context.mediaQuerySize.width / 3,
      left: context.mediaQuerySize.width / 3,
    ),
    behavior: SnackBarBehavior.floating,
    content: content,
  );
}
