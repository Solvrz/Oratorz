import 'package:flutter/material.dart';

Widget flag(String delegate, {double? size}) => Image.asset(
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
