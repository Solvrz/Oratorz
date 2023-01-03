import 'package:flutter/material.dart';
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
        errorBuilder: (_, __, ___) => Image.asset(
          height: size,
          width: size,
          "images/Logo.png",
          filterQuality: FilterQuality.high,
        ),
      ),
    );

Widget carousel(BuildContext context) =>
    Text("Carousel Placeholder", style: context.textTheme.bodyText1);
