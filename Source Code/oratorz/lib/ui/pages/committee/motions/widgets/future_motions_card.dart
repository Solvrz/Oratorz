import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FutureMotionsCard extends StatelessWidget {
  const FutureMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Future Motions",
              style: context.textTheme.headline5,
            ),
            const SizedBox(height: 8),
            Text(
              "No future motions added",
              style: context.textTheme.bodyText1,
            ),
            const Divider(height: 16),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
