import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoteTab extends StatelessWidget {
  const VoteTab({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: context.width / 2,
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            child: Center(
              child: Text("Vote Tab", style: context.textTheme.headline2),
            ),
          ),
        ),
      );
}
