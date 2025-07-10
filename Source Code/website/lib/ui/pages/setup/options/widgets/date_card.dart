import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateCard extends StatelessWidget {
  const DateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set Days",
              style: context.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
