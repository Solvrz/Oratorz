import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget flag(String delegate, {double size = 35}) => Image.asset(
      height: size,
      width: size,
      "flags/$delegate.png",
      errorBuilder: (
        _,
        exception,
        stackTrace,
      ) =>
          Container(),
    );

// TODO: Carousel
Widget carousel(BuildContext context) =>
    Text("Carousel Placeholder", style: context.textTheme.bodyText1);
