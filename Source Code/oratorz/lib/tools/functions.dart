import 'package:flutter/material.dart';

// TODO: Use This
// Widget logo(double size) => Hero(
//       tag: "logo",
//       child: Image.asset(
//         "assets/images/Logo.png",
//         height: screenSize.height(size),
//         width: screenSize.width(size),
//       ),
//     );

Widget divider({
  double height = 5,
  double thickness = 0.5,
}) =>
    Divider(
      height: height,
      thickness: thickness,
    );
