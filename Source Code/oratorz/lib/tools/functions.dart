import 'package:flutter/material.dart';

Widget flag(String delegate) => Image.asset(
      "flags/$delegate.png",
      errorBuilder: (
        _,
        exception,
        stackTrace,
      ) =>
          Container(),
    );
