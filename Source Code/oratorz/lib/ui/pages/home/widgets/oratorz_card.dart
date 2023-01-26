import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class OratorzCard extends StatelessWidget {
  const OratorzCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: 35,
              width: 35,
              "images/Logo-Dark.png",
            ),
            const SizedBox(width: 8),
            Text(
              "Oratorz",
              style: context.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
