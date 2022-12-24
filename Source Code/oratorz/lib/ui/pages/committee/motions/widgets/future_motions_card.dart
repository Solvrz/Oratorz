import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FutureMotionsCard extends StatelessWidget {
  const FutureMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 1.8,
      width: context.width / 3,
      child: Card(
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
                "No motions added yet.",
                style: context.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
