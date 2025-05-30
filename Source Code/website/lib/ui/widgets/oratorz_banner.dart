import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/utils.dart';

class OratorzBanner extends StatelessWidget {
  const OratorzBanner({super.key, this.isSmall = false, this.elevation});

  final bool isSmall;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isSmall ? MainAxisSize.min : MainAxisSize.max,
          children: [
            SvgPicture.asset(
              height: 35,
              width: 35,
              "images/Logo.svg",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Oratorz",
                style: context.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
