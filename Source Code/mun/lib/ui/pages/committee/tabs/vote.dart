import 'package:flutter/material.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Vote PAGE",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
