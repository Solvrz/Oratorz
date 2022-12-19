import 'package:flutter/material.dart';

import '/config/constants/constants.dart';

class VoteTab extends StatelessWidget {
  const VoteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
          child: Center(
            child: Text("Vote Tab", style: theme.textTheme.headline2),
          ),
        ),
      ),
    );
  }
}
