import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembersCard extends StatelessWidget {
  const MembersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set EB Members",
              style: context.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
